import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Controllers/Auth/signUp_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';
import 'package:sitaram_mandir/Widgets/custom_loading_api.dart';
import 'package:sitaram_mandir/Widgets/text_field.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with TickerProviderStateMixin {
  final RegisterController controller = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation; // Use Animation<double> instead of Animation
  bool _isLoading = false;

  // Function to trigger loading state
  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Tween needs to be of type double
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();  // Start the animation when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heading with Animation
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.teal.shade500,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Sub-heading with Animation
                FadeTransition(
                  opacity: _animation,
                  child: Text(
                    "Support the temple by donating! Register to contribute",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 40),
                // Custom Name Field with Animation
                CustomTextField.authformfield(
                  keyboardType: TextInputType.name,
                  controller: controller.nameController,
                  hintText: "Enter fullName",
                  prefixIcon: Icon(Icons.drive_file_rename_outline_sharp),
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name can't be empty";
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField.authformfield(
                  keyboardType: TextInputType.number,
                  controller: controller.phoneController,
                  hintText: "Enter mobileNo.",
                  prefixIcon: Icon(Icons.phone),
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Mobile can't be empty";
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField.authformfield(
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  hintText: "Enter email",
                  prefixIcon: Icon(Icons.email),
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                SizedBox(height: 20),
                CustomTextField.authformfield(
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  controller: controller.passwordController,
                  hintText: "Enter password",
                  prefixIcon: Icon(Icons.lock),
                  validator: (val) {
                    if (val!.length < 8) {
                      return "Password must be at least 8 characters";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                // Animated Button
                FadeTransition(
                  opacity: _animation,
                  child: _buildbutton(context,controller),
                ),
                SizedBox(height: 30),
                // "Already have an account?" Text
                FadeTransition(
                  opacity: _animation,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Already have an account!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildbutton(BuildContext context, RegisterController controller) {
    return InkWell(
      onTap: () {
        controller.registerUser(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() => AnimatedContainer(
            duration: Duration(milliseconds: 700),
            child: Container(
              child: Center(
                child: Text(
                  controller.isLoading.value ? "" : "Register",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CustomColor.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.shade300,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          )),
          Obx(() => controller.isLoading.value ? CustomLoadingAPI1() : SizedBox.shrink()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
