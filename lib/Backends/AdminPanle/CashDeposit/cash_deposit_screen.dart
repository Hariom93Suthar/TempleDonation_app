import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Backends/AdminPanle/CashDeposit/cash_users_screen.dart';
import 'package:sitaram_mandir/Controllers/Payments/CashDeposit/cash_deposit_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class CashDepositScreen extends StatelessWidget {
  final CashDepositController controller = Get.put(CashDepositController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Cash Deposit',style: TextStyle(fontWeight: FontWeight.w500,color: white),),
          centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 100,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      'Total Cash Deposit',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColor.primaryColor),
                    ),
                    SizedBox(height: 10),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: controller.totalCashDeposit.value),
                      duration: Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Text(
                          '₹ ${value.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: CustomColor.primaryColor1),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
            // Custom Dropdown as TextField Style
            SizedBox(height: 20,),
            Obx(() => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade400),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButton<String>(
                value: controller.selectedUser.value.isEmpty
                    ? null
                    : controller.selectedUser.value,
                hint: Text('Select User',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade500),),

                items: controller.userNames.map((name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.onUserSelected(value);
                },
                isExpanded: true,
                underline: SizedBox(),
              ),
            )),
            SizedBox(height: 20),

            // User ID TextField
            Obx(() => TextField(
              decoration: InputDecoration(
                hintText: "User ID",
                hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
              controller:
              TextEditingController(text: controller.userId.value),
            )),
            SizedBox(height: 20),

            // Phone TextField
            Obx(() => TextField(
              decoration: InputDecoration(
                hintText: "Phone",
                hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
              controller:
              TextEditingController(text: controller.phone.value),
            )),
            SizedBox(height: 20),

            // Amount TextField
            Obx(() => TextField(
              decoration: InputDecoration(
                hintText: "Amount",
                hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
              controller: TextEditingController(
                  text: controller.amount.value.toString()),
            )),
            SizedBox(height: 20),

            // Submit Payment Button
            Obx(() => ElevatedButton(
              onPressed: (controller.selectedUser.value.isNotEmpty &&
                  controller.amount.value > 0 &&
                  !controller.alreadyPaidThisMonth.value)
                  ? controller.submitPayment
                  : null,
              child: Text('Submit Payment',style: TextStyle(fontWeight: FontWeight.w700,color: white,fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            )),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Get.to(()=>CashDepositUserDataScreen());
              },
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width*.85,
                decoration: BoxDecoration(
                  color: CustomColor.primaryColor1,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  child: Text("Cash Deposit Users",style: TextStyle(
                      fontWeight: FontWeight.w700,color: Colors.white,fontSize: 17),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
