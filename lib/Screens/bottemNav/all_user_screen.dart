import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sitaram_mandir/Controllers/custom_history_controller.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class AllUsersScreen extends StatelessWidget {

  final CustomDonationController customController = Get.put(CustomDonationController());


  Future<List<Map<String, dynamic>>> fetchApprovedUsers() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isApproved', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> userList = [];

    for (var userDoc in usersSnapshot.docs) {
      String userId = userDoc.id;
      String name = userDoc['name'] ?? "No Name";
      String phone = userDoc['phone'] ?? "No Phone";
      double totalAmount = await _fetchUserTotalAmount(userId);

      userList.add({
        'name': name,
        'phone': phone,
        'totalAmount': totalAmount,
      });
    }

    return userList;
  }

  Future<double> _fetchUserTotalAmount(String userId) async {
    double total = 0.0;

    // 🔥 Monthly Payments se Total Amount
    QuerySnapshot paymentsSnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in paymentsSnapshot.docs) {
      total += (doc['amountPaid'] ?? 0).toDouble();
    }

    // 🔥 Custom Payments se Total Amount
    QuerySnapshot customPaymentsSnapshot = await FirebaseFirestore.instance
        .collection('customPayments')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in customPaymentsSnapshot.docs) {
      total += (doc['amountPaid'] ?? 0).toDouble();
    }

    // 🔥 Monthly aur Custom ka Grand Total
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // ✅ Allows back press
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Total Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: CustomColor.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: RefreshIndicator(
            color: CustomColor.primaryColor,
            onRefresh: () async {
              await fetchApprovedUsers();
            },
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchApprovedUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  var allUsers = snapshot.data!;

                  return ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      String name = allUsers[index]['name'];
                      String phone = allUsers[index]['phone'];
                      double totalAmount = allUsers[index]['totalAmount'];

                      // var customDonations = customController.customDonations.where((donation) =>
                      // donation['name'].toString().toLowerCase() == name.toLowerCase()
                      // ).toList();
                      //
                      // // 🔥 Custom Donations ka Total Calculate karenge
                      // double customTotal = 0.0;
                      // customDonations.forEach((donation) {
                      //   customTotal += double.parse(donation['amountPaid'].toString());
                      // });
                      //
                      // // 🔥 Total Amount mein Custom Donation ka Total Add karenge
                      // double grandTotal = totalAmount + customTotal;

                      return Padding(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        child: Card(
                          color: Colors.white,
                          elevation: 7,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.shade300,
                              radius: 30,
                              child: Center(
                                child: Icon(Icons.perm_identity, size: 25, color: Colors.black),
                              ),
                            ),
                            title: Text(
                              name,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Mingzat-Regular",
                              ),
                            ),
                            subtitle: Text(phone),
                            trailing: Text(
                              "₹${totalAmount.toStringAsFixed(2)}", // ✅ Custom aur Normal ka Total Show karenge
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No approved users found"));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
