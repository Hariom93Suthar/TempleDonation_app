import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Screens/Auth/admin_permission_screen.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs; // Loading state

  Future<void> registerUser(BuildContext context) async {
    try {
      isLoading.value = true; // Show loading

      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("All fields are required!")),
        );
        return;
      }

      // Firebase Authentication - Create User
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Firestore - Save user details
      await _firestore.collection("users").doc(userId).set({
        "name": name,
        "email": email,
        "phone": phone,
        "createdAt": Timestamp.now(),
        "userId": userId,
        "isApproved": false, // Admin approval needed
      });

      // Save user data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", userId);
      await prefs.setString("name", name);
      await prefs.setString("email", email);
      await prefs.setString("phone", phone);
      await prefs.setBool("isApproved", false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful! Waiting for admin approval.")),
      );

      // Navigate to Pending Approval Screen
      //Get.offAllNamed("/pendingApproval");
      Get.offAll(PendingApprovalScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false; // Hide loading
    }
  }


  Future<void> checkApproval(BuildContext context) async {
    try {
      isLoading.value = true; // Show loading

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");

      if (userId != null) {
        DocumentSnapshot userDoc = await _firestore.collection("users").doc(userId).get();
        bool isApproved = userDoc["isApproved"] ?? false;
        await prefs.setBool("isApproved", isApproved);

        if (isApproved) {
          Get.offAllNamed("/mainScreen"); // Redirect to main screen
        } else {
          Get.offAllNamed("/pendingApproval"); // Stay on pending screen
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error checking approval: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false; // Hide loading
    }
  }
}
