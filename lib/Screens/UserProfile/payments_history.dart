import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sitaram_mandir/Controllers/UserProfile/history_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class UserPaymentHistoryScreen extends StatelessWidget {
  final PaymentHistoryController controller = Get.put(PaymentHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
        title: Text(
          'Payment History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: CustomColor.primaryColor,
        onRefresh: () async {
          controller.paymentHistory;
          controller.customPaymentHistory;
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔘 Toggle Button for Switching History Type
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text('Scheduled History'),
                    selected: controller.isScheduledHistory.value,
                    onSelected: (selected) {
                      controller.isScheduledHistory.value = true;
                      controller.fetchPaymentHistory();
                    },
                  ),
                  SizedBox(width: 30),
                  ChoiceChip(
                    label: Text('CustomPay History'),
                    selected: !controller.isScheduledHistory.value,
                    onSelected: (selected) {
                      controller.isScheduledHistory.value = false;
                      controller.fetchCustomPaymentHistory();
                    },
                  ),
                ],
              )),


              SizedBox(height: 20),

              // 🔹 Year & Month Dropdown Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Year Dropdown
                  Container(
                    height: 25,
                    width: 85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedYear.value,
                          items: controller.yearList.map((String year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(year),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedYear.value = newValue!;
                            controller.fetchPaymentHistory();
                          },
                        ),
                      )),
                    ),
                  ),

                  // Month Dropdown
                  Container(
                    height: 25,
                    width: 106,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedMonth.value,
                          items: controller.monthList.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(DateFormat('MMMM').format(
                                  DateTime(0, int.parse(month)))),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedMonth.value = newValue!;
                            controller.fetchPaymentHistory();
                          },
                        ),
                      )),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 🔹 Payment History List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // 🔥 Check if Scheduled or Additional History is selected
                  final paymentList = controller.isScheduledHistory.value
                      ? controller.paymentHistory
                      : controller.customPaymentHistory;

                  if (paymentList.isEmpty) {
                    return Center(
                      child: Lottie.asset("assets/images/Animation - 1737694620707.json", height: 200),
                    );
                  }
                  return ListView.builder(
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      final payment = paymentList[index];
                      return Card(
                        color: Colors.teal.shade200,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 25,
                            child: Icon(Icons.arrow_upward, size: 20),
                          ),
                          title: Text(
                            "Amount: ₹${payment['amount']}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            "Date: ${DateFormat('dd MMM yyyy').format(payment['date'])}",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
