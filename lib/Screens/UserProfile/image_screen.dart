import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sitaram_mandir/Utils/colors.dart';
import '../../Controllers/image_screen_controller.dart';

class ImageScreen extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Receipt",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
      ),
      body: GetBuilder<ImageController>(builder: (controller) {
        return Screenshot(
          controller: controller.screenshotController,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  SvgPicture.asset(
                    'assets/images/ram.svg',
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal.shade200, Colors.teal.shade500],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Text(
                          "Thank You for Your Devotion and Support.\nMay Divine Grace Shine Upon You!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SVG Logo Image
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Center(
                      child: Card(
                        color: Colors.teal.shade200,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Ram Mandir Payment Receipt",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                color: Colors.teal,
                                thickness: 2,
                                height: 20,
                              ),
                              Card(
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: "Name: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueAccent, // Name ka alag color
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.userName,
                                          style: TextStyle(
                                            color: Colors.black87, // Value ka alag color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: "Amount: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue, // Amount ka alag color
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "₹${controller.amount}",
                                          style: TextStyle(
                                            color: Colors.green, // Value ka alag color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: "Date: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue, // Date ka alag color
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.date,
                                          style: TextStyle(
                                            color: Colors.black54, // Value ka alag color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: "Time: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue, // Time ka alag color
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.time,
                                          style: TextStyle(
                                            color: Colors.black54, // Value ka alag color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: "Txn ID: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue, // Txn ID ka alag color
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.transactionId,
                                          style: TextStyle(
                                            color: Colors.black54, // Value ka alag color
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () {
                                  controller.shareImage();
                                  },
                                icon: Icon(Icons.share,color: Colors.black,),
                                label: Text("Share Image",style: TextStyle(color: white),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
