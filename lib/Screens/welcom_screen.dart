import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Screens/Auth/signUp_screen.dart';
import 'package:sitaram_mandir/Screens/Auth/signin_screen.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Ram Mandir",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryColor,
              ),

            ),
            Image.asset(
              'assets/images/6876640.jpg', // Replace with relevant image asset

            ),
            SizedBox(height: 20),
            Text(
              "Empower Your Temple, Elevate Your Soul",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              //textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              "Your contribution preserves tradition, sustains spirituality, and spreads positivity. Be a part of something divine!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black45,
              ),
              //textAlign: TextAlign.center,
            ),
            Spacer(),
            Row(
              children: [
                InkWell(
                    onTap: (){
                      Get.to(()=>LoginScreen());
                    },
                    child: _buildbutton(context,"SignIn")),
                Spacer(),
                InkWell(
                    onTap: (){
                      Get.to(()=>RegistrationScreen());
                    },
                    child: _buildbutton(context,"SignUp")),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildbutton(BuildContext context,String txt){
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width*.30,
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text("$txt",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 17
        ),
        ),
      ),
    );
  }
}
