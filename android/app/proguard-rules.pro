# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Kauri - Keep only Android entrypoints and JNI boundaries, allowing R8 to obfuscate internal classes (K-20)
-keep class cm.tbg.kauri.MainActivity { *; }

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

# Apache Tika (dépendance transitive) référence des API JVM absentes d'Android :
# javax.xml.stream (StAX), java.awt, javax.imageio... Sans ces règles, R8 échoue en release avec
# "Missing class javax.xml.stream.XMLStreamException". Ces chemins de code ne sont jamais
# exécutés sur Android.
-dontwarn javax.xml.stream.**
-dontwarn javax.xml.**
-dontwarn java.awt.**
-dontwarn javax.imageio.**
-dontwarn javax.swing.**
-dontwarn javax.script.**
-dontwarn org.apache.tika.**
-dontwarn org.w3c.dom.**
-dontwarn org.slf4j.**
