import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitaram_mandir/Backends/AdminPanle/admin_dashboard_screen.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false; // 🔹 Checkbox State

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// 🔹 Load Saved Email & Password From SharedPreferences
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString("admin_email") ?? "";
      _passwordController.text = prefs.getString("admin_password") ?? "";
      _rememberMe = prefs.getBool("remember_me") ?? false;
    });
  }

  /// 🔹 Save Email & Password in SharedPreferences
  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString("admin_email", _emailController.text.trim());
      await prefs.setString("admin_password", _passwordController.text.trim());
      await prefs.setBool("remember_me", true);
    } else {
      await prefs.remove("admin_email");
      await prefs.remove("admin_password");
      await prefs.setBool("remember_me", false);
    }
  }

  /// 🔹 Firestore Se Admin Email & Password Fetch Karke Verify Karna
  Future<void> _verifyAdmin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('Admin')
          .doc('Crn8npet0yWmiGAkoin4')
          .get();

      if (adminDoc.exists) {
        String storedEmail = adminDoc['email'];
        String storedPassword = adminDoc['pass'];
        String storedRole = adminDoc['role'];

        if (_emailController.text.trim() == storedEmail &&
            _passwordController.text.trim() == storedPassword &&
            storedRole == "admin") {
          await _saveCredentials(); // 🔹 Save Credentials on Successful Login
          Get.off(() => AdminDashboard());
        } else {
          _showErrorSnackbar("Invalid Email or Password");
        }
      } else {
        _showErrorSnackbar("Admin Not Found!");
      }
    } catch (e) {
      _showErrorSnackbar("Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 🔹 Show Error Message in Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // 🔹 Light Background
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Admin Login",style: TextStyle(color: white),),
        backgroundColor: CustomColor.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 100, color: Colors.teal),
            SizedBox(height: 10),
            Text(
              "Admin Panel Login",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
            ),
            SizedBox(height: 20),

            // 🔹 Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Admin Email",
                hintStyle: TextStyle(color: greyA6A,fontWeight: FontWeight.w700),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: Icon(Icons.email, color: Colors.teal),
              ),
            ),
            SizedBox(height: 15),

            // 🔹 Password Input
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Admin Password",
                hintStyle: TextStyle(color: greyA6A,fontWeight: FontWeight.w700),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: Icon(Icons.lock, color: Colors.teal),
              ),
            ),
            SizedBox(height: 10),

            // 🔹 Remember Me Checkbox
            Row(
              children: [
                Checkbox(
                  checkColor: CustomColor.primaryColor,
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                Text(
                  "Remember Me",
                  style: TextStyle(fontSize: 16, color: Colors.teal.shade800),
                ),
              ],
            ),

            SizedBox(height: 20),

            // 🔹 Login Button
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _verifyAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
