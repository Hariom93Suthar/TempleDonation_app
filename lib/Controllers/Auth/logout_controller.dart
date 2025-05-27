import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Screens/welcom_screen.dart';

class LogoutController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Logout Function
  Future<void> logOut() async {
    try {
      await _auth.signOut(); // Sign out from Firebase
      Get.snackbar(
        "Logged Out",
        "You have been logged out successfully.",
        backgroundColor: Colors.greenAccent,
      );
      Get.offAll(WelcomeScreen()); // This will remove all the previous routes and push WelcomeScreen
    } catch (e) {
      print("Error logging out: $e");
      Get.snackbar(
        "Error",
        "Something went wrong while logging out. Please try again.",
        backgroundColor: Colors.redAccent,
      );
    }
  }
}
