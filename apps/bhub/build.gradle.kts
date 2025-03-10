plugins {
    // Android
    id("com.android.application") version "8.2.2" apply false
    id("com.android.library") version "8.2.2" apply false
    
    // Kotlin
    kotlin("android") version "1.9.22" apply false
    kotlin("multiplatform") version "1.9.22" apply false
    kotlin("native.cocoapods") version "1.9.22" apply false
    
    // Compose
    id("org.jetbrains.compose") version "1.5.12" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven("https://maven.pkg.jetbrains.space/public/p/compose/dev")
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}