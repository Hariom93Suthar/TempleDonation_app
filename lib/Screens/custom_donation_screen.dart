import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sitaram_mandir/Controllers/custom_history_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class CustomDonationHistoryScreen extends StatelessWidget {
  final CustomDonationController controller = Get.put(CustomDonationController(),permanent: true);

  List<Color> avatarColors = [
    Colors.deepPurpleAccent,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
  ];

  // 🔹 Function to Get Fixed Color Based on Name
  Color getColorForName(String name) {
    int hashCode = name.hashCode;
    int colorIndex = hashCode % avatarColors.length;
    return avatarColors[colorIndex];
  }

  /// 🔹 Year List (2024 to Current Year)
  List<String> getYears() {
    int currentYear = DateTime.now().year;
    List<String> years = [];
    for (int year = 2024; year <= currentYear; year++) {
      years.add(year.toString());
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Custom Donation History',
          style: TextStyle(fontWeight: FontWeight.w500, color: white),
        ),
        backgroundColor: CustomColor.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Total Custom Amount
            Obx(() => Card(
              color: Colors.teal.shade500,
              elevation: 4,
              child: ListTile(
                title: Text("Total Custom Amount",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: white)),
                trailing: Text("₹${controller.totalAmount.value.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: white)),
              ),
            )),
            SizedBox(height: 20),

            /// 🔹 Search & Filter
            Row(
              children: [
                /// 🔹 Search by Name
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search by Name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                      controller.filterDonations();
                    },
                  ),
                ),
                SizedBox(width: 10),

                /// 🔹 Year Dropdown
                Obx(() => DropdownButton<String>(
                  value: controller.selectedYear.value.isEmpty ? null : controller.selectedYear.value,
                  hint: Text('Year'),
                  items: getYears().map((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedYear.value = value!;
                    controller.filterDonations();
                  },
                )),
                SizedBox(width: 10),

                /// 🔹 Month Dropdown
                Obx(() => DropdownButton<String>(
                  value: controller.selectedMonth.value.isEmpty ? null : controller.selectedMonth.value,
                  hint: Text('Month'),
                  items: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
                      .map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedMonth.value = value!;
                    controller.filterDonations();
                  },
                )),
              ],
            ),
            SizedBox(height: 20),

            /// 🔹 User List with Refresh Indicator
            Expanded(
              child: Obx(() => RefreshIndicator(
                onRefresh: () async {
                  controller.selectedYear.value = '';
                  controller.selectedMonth.value = '';
                  controller.searchQuery.value = '';
                  await controller.fetchDonations();
                },
                child: controller.isLoading.value
                    ? Center(child: CircularProgressIndicator()) // 🔹 Loading Indicator
                    : controller.filteredDonations.isEmpty
                    ? Center(
                  child: Lottie.asset("assets/images/Animation - 1737694620707.json",height: 200)
                ) // 🔹 No Data Message
                    : ListView.builder(
                  itemCount: controller.filteredDonations.length,
                  itemBuilder: (context, index) {
                    var donation = controller.filteredDonations[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: Colors.white,
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          donation['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(donation['date']),
                        trailing: Text(
                          "₹${donation['amountPaid']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              fontSize: 17),
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor:
                          getColorForName(donation['name']),
                          child: Text(
                            donation['name']
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
            ),

          ],
        ),
      ),
    );
  }
}
