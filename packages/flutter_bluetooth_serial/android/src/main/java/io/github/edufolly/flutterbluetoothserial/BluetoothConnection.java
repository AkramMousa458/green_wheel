package io.github.edufolly.flutterbluetoothserial;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;
import java.util.Arrays;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.os.ParcelUuid;
import android.util.Log;

/// Universal Bluetooth serial connection class (for Java)
public abstract class BluetoothConnection
{
    private static final String TAG = "FlutterBluePlugin";
    protected static final UUID DEFAULT_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

    protected BluetoothAdapter bluetoothAdapter;

    protected ConnectionThread connectionThread = null;

    public boolean isConnected() {
        return connectionThread != null && connectionThread.requestedClosing != true;
    }



    public BluetoothConnection(BluetoothAdapter bluetoothAdapter) {
        this.bluetoothAdapter = bluetoothAdapter;
    }



    // @TODO . `connect` could be done perfored on the other thread
    // @TODO . `connect` parameter: timeout
    // @TODO . `connect` other methods than `createRfcommSocketToServiceRecord`, including hidden one raw `createRfcommSocket` (on channel).
    // @TODO ? how about turning it into factoried?
    /// Connects to given device by hardware address
    public void connect(String address, UUID uuid) throws IOException {
        if (isConnected()) {
            throw new IOException("already connected");
        }

        BluetoothDevice device = bluetoothAdapter.getRemoteDevice(address);
        if (device == null) {
            throw new IOException("device not found");
        }

        bluetoothAdapter.cancelDiscovery();

        // Discovery must finish before RFCOMM connect on many devices.
        try {
            Thread.sleep(350);
        } catch (InterruptedException ignored) {}

        BluetoothSocket socket = null;
        IOException lastException = null;
        String connectedVia = null;

        BluetoothSocket secureSocket = device.createRfcommSocketToServiceRecord(uuid);
        BluetoothSocket insecureSocket = device.createInsecureRfcommSocketToServiceRecord(uuid);

        BluetoothSocket[] candidates = new BluetoothSocket[] {
            secureSocket,
            insecureSocket,
        };

        for (int i = 0; i < candidates.length; i++) {
            BluetoothSocket candidate = candidates[i];
            if (candidate == null) {
                continue;
            }

            String label = i == 0 ? "secure SPP UUID" : "insecure SPP UUID";
            try {
                candidate.connect();
                socket = candidate;
                connectedVia = label;
                break;
            } catch (IOException connectException) {
                lastException = connectException;
                Log.w(TAG, "Connect failed via " + label + ": " + connectException.getMessage());
                try {
                    candidate.close();
                } catch (Exception ignored) {}
            }
        }

        if (socket == null) {
            ParcelUuid[] uuids = device.getUuids();
            if (uuids != null) {
                for (ParcelUuid parcelUuid : uuids) {
                    if (parcelUuid == null) {
                        continue;
                    }
                    UUID deviceUuid = parcelUuid.getUuid();
                    BluetoothSocket[] uuidCandidates = new BluetoothSocket[] {
                        device.createRfcommSocketToServiceRecord(deviceUuid),
                        device.createInsecureRfcommSocketToServiceRecord(deviceUuid),
                    };
                    for (int i = 0; i < uuidCandidates.length; i++) {
                        BluetoothSocket candidate = uuidCandidates[i];
                        if (candidate == null) {
                            continue;
                        }
                        String label = "device UUID " + deviceUuid + (i == 0 ? " secure" : " insecure");
                        try {
                            candidate.connect();
                            socket = candidate;
                            connectedVia = label;
                            break;
                        } catch (IOException connectException) {
                            lastException = connectException;
                            Log.w(TAG, "Connect failed via " + label + ": " + connectException.getMessage());
                            try {
                                candidate.close();
                            } catch (Exception ignored) {}
                        }
                    }
                    if (socket != null) {
                        break;
                    }
                }
            }
        }

        if (socket == null) {
            for (int channel = 1; channel <= 3; channel++) {
                try {
                    java.lang.reflect.Method method =
                        device.getClass().getMethod("createRfcommSocket", int.class);
                    BluetoothSocket fallbackSocket =
                        (BluetoothSocket) method.invoke(device, channel);
                    fallbackSocket.connect();
                    socket = fallbackSocket;
                    connectedVia = "RFCOMM channel " + channel;
                    break;
                } catch (Exception fallbackException) {
                    lastException = new IOException(fallbackException);
                    Log.w(TAG, "Connect failed via RFCOMM channel " + channel);
                }
            }
        }

        if (socket == null) {
            if (lastException != null) {
                throw lastException;
            }
            throw new IOException("socket connection not established");
        }

        Log.d(TAG, "Connected via " + connectedVia + " to " + address);

        connectionThread = new ConnectionThread(socket);
        connectionThread.start();
    }
    /// Connects to given device by hardware address (default UUID used)
    public void connect(String address) throws IOException {
        connect(address, DEFAULT_UUID);
    }
    
    /// Disconnects current session (ignore if not connected)
    public void disconnect() {
        if (isConnected()) {
            connectionThread.cancel();
            connectionThread = null;
        }
    }

    /// Writes to connected remote device 
    public void write(byte[] data) throws IOException {
        if (!isConnected()) {
            throw new IOException("not connected");
        }

        connectionThread.write(data);
    }

    /// Callback for reading data.
    protected abstract void onRead(byte[] data);

    /// Callback for disconnection.
    protected abstract void onDisconnected(boolean byRemote);

    /// Thread to handle connection I/O
    private class ConnectionThread extends Thread  {
        private final BluetoothSocket socket;
        private final InputStream input;
        private final OutputStream output;
        private boolean requestedClosing = false;
        
        ConnectionThread(BluetoothSocket socket) {
            this.socket = socket;
            InputStream tmpIn = null;
            OutputStream tmpOut = null;

            try {
                tmpIn = socket.getInputStream();
                tmpOut = socket.getOutputStream();
            } catch (IOException e) {
                e.printStackTrace();
            }

            this.input = tmpIn;
            this.output = tmpOut;
        }

        /// Thread main code
        public void run() {
            byte[] buffer = new byte[1024];
            int bytes;

            while (!requestedClosing) {
                try {
                    bytes = input.read(buffer);
                    if (bytes <= 0) {
                        break;
                    }

                    onRead(Arrays.copyOf(buffer, bytes));
                } catch (IOException e) {
                    // `input.read` throws when closed by remote device
                    break;
                }
            }

            // Make sure output stream is closed
            if (output != null) {
                try {
                    output.close();
                }
                catch (Exception e) {}
            }

            // Make sure input stream is closed
            if (input != null) {
                try {
                    input.close();
                }
                catch (Exception e) {}
            }

            // Callback on disconnected, with information which side is closing
            onDisconnected(!requestedClosing);

            // Just prevent unnecessary `cancel`ing
            requestedClosing = true;
        }

        /// Writes to output stream
        public void write(byte[] bytes) {
            try {
                output.write(bytes);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        /// Stops the thread, disconnects
        public void cancel() {
            if (requestedClosing) {
                return;
            }
            requestedClosing = true;

            // Flush output buffers befoce closing
            try {
                output.flush();
            }
            catch (Exception e) {}

            // Close the connection socket
            if (socket != null) {
                try {
                    // Might be useful (see https://stackoverflow.com/a/22769260/4880243)
                    Thread.sleep(111);

                    socket.close();
                }
                catch (Exception e) {}
            }
        }
    }
}
