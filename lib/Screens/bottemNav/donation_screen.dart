import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Controllers/donation_controller.dart';
import 'package:sitaram_mandir/Screens/custom_donation_screen.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class DonationScreen extends StatelessWidget {
  final DonationController controller = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Donations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: CustomColor.primaryColor,
      ),
      body: RefreshIndicator(
        color: CustomColor.primaryColor,
        onRefresh: () async {
          await controller.fetchDonationData();
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Year & Month Dropdowns (Fixed RenderFlex Issue)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: _buildDropdown(controller.selectedYear, controller.yearList)),
                  SizedBox(width: 10), // 🔹 Extra space added to prevent overflow
                  Flexible(child: _buildDropdown(controller.selectedMonth, controller.monthList)),
                ],
              ),
              SizedBox(height: 20),

              /// 🔹 Total Revenue Card
              Obx(() => _buildRevenueCard("Total Revenue", controller.totalRevenue.value, Colors.orange)),
              SizedBox(height: 20),
              InkWell(
                onTap: (){
                  Get.to(()=>CustomDonationHistoryScreen());
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text("Custom Donation History",style: TextStyle(color: white,fontWeight: FontWeight.w700,fontSize: 18),),
                  ),
                ),
              ),
              SizedBox(height: 20),
              /// 🔹 Toggle Buttons
              Obx(() => _buildToggleButtons()),

              SizedBox(height: 20),

              /// 🔹 User List Based on Toggle Selection
              Obx(() => Expanded(
                child: ListView.builder(
                  itemCount: controller.showPaidUsers.value ? controller.paidUsers.length : controller.unpaidUsers.length,
                  itemBuilder: (context, index) {
                    var user = controller.showPaidUsers.value ? controller.paidUsers[index] : controller.unpaidUsers[index];
                    return _buildUserCard(user, controller.showPaidUsers.value);
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Build Dropdown UI (Fixed RenderFlex Issue)
  Widget _buildDropdown(RxString selectedValue, RxList<String> values) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue.value,
          isExpanded: true, // 🔹 Expand dropdown to prevent overflow
          items: values.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, overflow: TextOverflow.ellipsis), // 🔹 Prevent text overflow
            );
          }).toList(),
          onChanged: (String? newValue) {
            selectedValue.value = newValue!;
            controller.fetchDonationData();
          },
        ),
      )),
    );
  }

  /// 🔹 Build Revenue Card
  Widget _buildRevenueCard(String title, double amount, Color color) {
    return Card(
      color: Colors.white70,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 150,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColor.primaryColor)),
            SizedBox(height: 10),
            Text("₹${amount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  /// 🔹 Build Toggle Buttons
  Widget _buildToggleButtons() {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(10),
      selectedColor: Colors.white,
      fillColor: CustomColor.primaryColor,
      borderColor: CustomColor.primaryColor,
      selectedBorderColor: CustomColor.primaryColor,
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 55), child: Text("Paid Users", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 50), child: Text("Unpaid Users", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
      ],
      isSelected: [controller.showPaidUsers.value, !controller.showPaidUsers.value],
      onPressed: (index) {
        controller.showPaidUsers.value = index == 0;
      },
    );
  }

  /// 🔹 Build User Card
  Widget _buildUserCard(Map<String, dynamic> user, bool isPaid) {
    return Card(
      color: isPaid ? Colors.green.shade50 : Colors.red.shade50,
      child: ListTile(
        leading: Icon(
          isPaid ? Icons.check_circle : Icons.warning_rounded,
          color: isPaid ? Colors.green : Colors.red,
        ),
        title: Text(user["name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(user["phone"]),
        trailing: Text(
          isPaid ? "₹${user["amount"]}" : "Pending",
          style: TextStyle(color: isPaid ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
