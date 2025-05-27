# Razorpay SDK Rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep Annotations for Proguard
-keepattributes *Annotation*
-keep class **.annotation.Keep { *; }
-keep class **.annotation.KeepClassMembers { *; }
