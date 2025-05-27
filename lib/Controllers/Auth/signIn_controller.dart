import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Screens/bottemNav/tab_view.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  var isLoading = false.obs; // Loading state

  // 🔹 Login User
  Future<void> loginUser(BuildContext context) async {
    try {
      isLoading.value = true; // Show loading

      String email = loginEmailController.text.trim();
      String password = loginPasswordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email and password are required!")),
        );
        return;
      }

      // 🔹 Firebase Authentication - Sign In User
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userId).get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not found in database!")),
        );
        return;
      }

      String userName = userDoc["name"] ?? "User";
      bool isApproved = userDoc["isApproved"] ?? false;

      // 🔹 Save user data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", userId);
      await prefs.setString("name", userName); // ✅ Name save hoga
      await prefs.setString("email", email);
      await prefs.setBool("isApproved", isApproved);

      if (isApproved) {
        Get.offAll(() => TabView());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your account is not approved yet!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false; // Hide loading
    }
  }
}
