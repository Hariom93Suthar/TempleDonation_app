import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Controllers/Auth/signIn_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';
import 'package:sitaram_mandir/Widgets/custom_loading_api.dart';
import 'package:sitaram_mandir/Widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation; // Animation for fade-in effect

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Setting up the fade-in animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();  // Start animation when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: Text(
                  "Login here",
                  style: TextStyle(
                    color: Colors.teal.shade500,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Sub-text with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: Text(
                  "Your support keeps the temple alive! Login to continue",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              // Email field with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: CustomTextField.authformfield(
                  controller: controller.loginEmailController,
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,

                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
              ),
              SizedBox(height: 20),
              // Password field with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: CustomTextField.authformfield(
                  controller: controller.loginPasswordController,
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                  validator: (val) {
                    if (val!.length < 8) {
                      return "Password must be at least 8 characters";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              // Forgot Password button with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Forgot Password?", style: TextStyle(color: Colors.teal)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Login Button with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: _buildbutton(context,controller),
              ),
              SizedBox(height: 30),
              // Create New Account button with Fade-in animation
              FadeTransition(
                opacity: _animation,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Create New account!",
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
    );
  }

  Widget _buildbutton(BuildContext context, LoginController controller) {
    return InkWell(
      onTap: () {
        controller.loginUser(context); // Login function call
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() => AnimatedContainer(
            duration: Duration(milliseconds: 700),
            child: Container(
              child: Center(
                child: Text(
                  controller.isLoading.value ? "" : "Login",
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
