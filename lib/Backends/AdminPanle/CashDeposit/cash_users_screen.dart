import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Controllers/Payments/CashDeposit/cash_deposit_user_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class CashDepositUserDataScreen extends StatelessWidget {
  final CashDepositUserDataController controller =
  Get.put(CashDepositUserDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Cash Deposit User Data',style: TextStyle(fontWeight: FontWeight.w500,color: white),),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Dropdown
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Obx(() => DropdownButton<String>(
                      value: controller.selectedYear.value.isEmpty
                          ? null
                          : controller.selectedYear.value,
                      hint: Text('Select Year'),
                      items: controller.years.map((year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedYear.value = value!;
                        controller.filterData();
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    )),
                  ),
                ),
                SizedBox(width: 20),

                // Month Dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Obx(() => DropdownButton<String>(
                      value: controller.selectedMonth.value.isEmpty
                          ? null
                          : controller.selectedMonth.value,
                      hint: Text('Select Month'),
                      items: controller.monthNames.map((month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedMonth.value = value!;
                        controller.filterData();
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Data Table
            Expanded(
              child: Obx(() => controller.cashDepositData.isEmpty
                  ? Center(child: Text('No Data Available'))
                  : ListView.builder(
                itemCount: controller.cashDepositData.length,
                itemBuilder: (context, index) {
                  var data = controller.cashDepositData[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17,color: Colors.blueAccent),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amount: ₹${data['amountPaid']}',style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                          Text('Date: ${data['date']}',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
