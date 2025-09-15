# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep just_audio classes
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audioservice.** { *; }

# Keep audio service classes
-keep class com.ryanheise.audioservice.AudioService { *; }
-keep class com.ryanheise.audioservice.MediaButtonReceiver { *; }
-keep class com.ryanheise.audioservice.AudioServiceActivity { *; }

# Keep just_audio platform interface
-keep class com.ryanheise.just_audio_platform_interface.** { *; }

# Keep ExoPlayer classes (used by just_audio)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Keep OkHttp classes (used for network requests)
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep Gson classes if used
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep Flutter plugin classes
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes with @Keep annotation
-keep @androidx.annotation.Keep class * {*;}
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}
