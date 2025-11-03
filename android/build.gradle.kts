// android/build.gradle.kts

plugins {
    // Nothing here — Flutter adds plugins dynamically
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // This version works well with Flutter 3.24+
        classpath("com.android.tools.build:gradle:8.8.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.23")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: redirect build output to root /build folder
val newBuildDir = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
