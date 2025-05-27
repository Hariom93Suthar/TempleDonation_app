import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class PendingApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/Animation - 1737694620707.json', // 🔹 Ensure this file exists
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                "Approval Pending",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Your account is under review. Once approved by the admin, you will be able to access all features.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 30),
              Icon(
                Icons.hourglass_empty_rounded,
                color: CustomColor.primaryColor,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                "Please wait for admin approval...",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
