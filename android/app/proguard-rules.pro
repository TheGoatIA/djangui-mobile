# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Djangui
-keep class com.djangui.djangui.** { *; }

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
