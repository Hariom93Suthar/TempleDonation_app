import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Controllers/home_screen_controller.dart';
import 'package:sitaram_mandir/Screens/purches_see_history.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController()); // 🔹 Inject Controller

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
        title: Text(
          'Revenue Management',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        elevation: 4.0,
      ),
      body: RefreshIndicator(
        color: CustomColor.primaryColor,
        onRefresh: controller.fetchAllData, // 🔹 Pull-to-refresh
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          children: [
            _buildAnimatedCard("Total Revenue", controller.totalRevenue, Colors.green, height, width),
            SizedBox(height: height * .02),
            _buildAnimatedCard("Remaining Amount", controller.remainingRevenue, Colors.orange, height, width),
            SizedBox(height: height * .02),
            _buildAnimatedCardWithButton("Purchase Item", controller.buyProductsAmount, Colors.red, height, width),
          ],
        ),
      ),
    );
  }

  /// 🔹 Animated Card with Obx()
  Widget _buildAnimatedCard(String title, RxDouble value, Color color, double height, double width) {
    return Card(
      elevation: 10,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 25),
        height: height * .20,
        width: width * .90,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 1.2),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "Mingzat-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: height * .02),

            // 🔥 Animated Number Counter with Obx
            Obx(() => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value.value),
              duration: Duration(seconds: 3),
              builder: (context, double val, child) {
                return Text(
                  "₹${val.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  /// 🔹 Animated Card with Button (for Purchase Item)
  Widget _buildAnimatedCardWithButton(String title, RxDouble value, Color color, double height, double width) {
    return Card(
      elevation: 10,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 25),
        height: height * .25,  // 🔹 Increased height for button
        width: width * .90,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 1.2),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "Mingzat-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: height * .02),

            // 🔥 Animated Number Counter with Obx
            Obx(() => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value.value),
              duration: Duration(seconds: 3),
              builder: (context, double val, child) {
                return Text(
                  "₹${val.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                );
              },
            )),

            SizedBox(height: height * .02),

            // 🔹 "SEE HISTORY" Button Inside Purchase Item Container
            InkWell(
              onTap: () {
                Get.to(PurchesSeeHistory());
              },
              child: Container(
                child: Center(
                  child: Text(
                    "SEE HISTORY",
                    style: TextStyle(
                      fontFamily: "Mingzat-Regular",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                height: 40,
                width: width * .50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColor.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
