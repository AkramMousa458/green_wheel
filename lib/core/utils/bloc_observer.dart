// ignore_for_file: deprecated_member_use
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// A simple BLoC observer for logging lifecycle events.
class AppBlocObserver extends BlocObserver {
  final Logger _logger;

  AppBlocObserver({Logger? logger})
    : _logger = logger ?? Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    _logger.d('Created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.v('State changed: ${bloc.runtimeType} -> ${change.nextState}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (event != null) {
      _logger.v('Event: ${bloc.runtimeType} -> $event');
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.v('Transition: ${bloc.runtimeType} -> ${transition.event}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.e('Error in ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    _logger.d('Closed: ${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
