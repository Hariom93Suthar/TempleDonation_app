import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Backends/AdminPanle/auth_screen.dart';
import 'package:sitaram_mandir/Controllers/profile_controller.dart';
import 'package:sitaram_mandir/Backends/PaymentGateway/payments.dart';
import 'package:sitaram_mandir/Screens/UserProfile/payments_history.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class ProfileScreen extends StatelessWidget {

  final ProfileController profileController = Get.put(ProfileController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          'Your Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: white,),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cancel
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Yaha par logout function call karenge
                          profileController.logoutUser();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: CustomColor.primaryColor,
        onRefresh: () async {
          await profileController.refreshData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Column(
              children: [
                SizedBox(height: 10),

                // 🔹 Show User Name & Email from ProfileController
                Align(
                  alignment: Alignment.center,
                  child: Obx(() => Text(
                    profileController.userName.value, // 🔹 Live name update
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Mingzat-Regular"),
                  )),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Obx(() => Text(
                    profileController.userEmail.value, // 🔹 Live email update
                    style: TextStyle(fontSize: 15),
                  )),
                ),
                SizedBox(height: 20),
                Divider(height: 2, color: Colors.black),
                SizedBox(height: 20),

                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => PaymentScreen());
                      },
                      child: _buildCard(
                        "Amount Pay",
                        "assets/images/upi.png",
                        height,
                        width,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.to(UserPaymentHistoryScreen(), transition: Transition.rightToLeftWithFade, duration: Duration(seconds: 1));
                      },
                      child: _buildCard(
                        "History",
                        "assets/images/his.png",
                        height,
                        width,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // 🔹 Your Total Donation Card
                Card(
                  elevation: 10,
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Title with Total Amount on Right Corner
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Total Donation",
                              style: TextStyle(
                                fontSize: height * .022,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Mingzat-Regular",
                              ),
                            ),
                            Obx(() {
                              // 🔹 Calculate Total Amount
                              return Text(
                                "₹${profileController.TotalAmount.value.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: height * .021,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: height * .02),

                        // 🔹 Row with Two Cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 🔹 Scheduled Donation Card
                            Expanded(
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.teal, width: 1.2),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Scheduled Donation",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height * .01),
                                      // 🔹 Scheduled Donation Amount with Loading Indicator
                                      Obx(() {
                                        if (profileController.isLoading.value) {
                                          return CircularProgressIndicator(); // 🔄 Loader
                                        } else {
                                          return Text(
                                            "₹${profileController.myAmount.value.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.teal,
                                            ),
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * .03), // 🔹 Space between the two cards

                            // 🔹 Additional Donation Card
                            Expanded(
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: CustomColor.primaryColor, width: 1.2),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Additional Donation",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height * .01),
                                      // 🔹 Additional Donation Amount with Loading Indicator
                                      Obx(() {
                                        if (profileController.isLoading.value) {
                                          return CircularProgressIndicator(); // 🔄 Loader
                                        } else {
                                          return Text(
                                            "₹${profileController.customAmount.value.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: CustomColor.primaryColor,
                                            ),
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),


                SizedBox(height: 20),

                // 🔹 Admin Panel Button
                Card(
                  elevation: 10,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => AdminLoginScreen());
                    },
                    child: Container(
                      height: height * .17,
                      width: width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 1.2),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings, size: 50, color: Colors.teal),
                          SizedBox(height: 8),
                          Text("Admin Panel Access", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
                        ],
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

  /// 🔹 Reusable Card Widget
  Widget _buildCard(String title, String imagePath, double height, double width) {
    return Card(
      elevation: 10,
      color: Colors.transparent,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: height * .02, fontWeight: FontWeight.bold, fontFamily: "Mingzat-Regular"),
              ),
              SizedBox(height: height * .02),
              Image.asset(imagePath, height: 50),
            ],
          ),
        ),
        height: height * .20,
        width: width * .42,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 1.2),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
