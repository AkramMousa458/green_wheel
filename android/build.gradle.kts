import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Legacy plugins (e.g. flutter_bluetooth_serial 0.4.0) ship compileSdk 30 and
// no namespace. Re-apply in afterEvaluate so their build.gradle cannot overwrite
// us, but only raise SDK — never downgrade plugins that already target newer APIs.
subprojects {
    afterEvaluate {
        extensions.findByType(LibraryExtension::class.java)?.apply {
            if (namespace.isNullOrBlank()) {
                namespace = project.group.toString().ifBlank {
                    "io.github.edufolly.flutterbluetoothserial"
                }
            }
            val minLegacyCompileSdk = 34
            if (compileSdk == null || compileSdk!! < minLegacyCompileSdk) {
                compileSdk = minLegacyCompileSdk
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
