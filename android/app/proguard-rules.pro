# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Kauri
-keep class cm.tbg.kauri.** { *; }

# Drift
-keep class androidx.room.db.** { *; }

# Retrofit / Dio
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions
-keepattributes *Annotation*

# Serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Ignore warnings
-dontwarn javax.annotation.**
-dontwarn retrofit2.Platform$Java8

# Play Core (Deferred components / SplitCompat)
-dontwarn com.google.android.play.core.**

# MLKit Text Recognition (optional languages)
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
