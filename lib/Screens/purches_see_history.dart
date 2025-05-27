import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sitaram_mandir/Utils/colors.dart'; // 🔹 Date Formatting Ke Liye

class PurchesSeeHistory extends StatefulWidget {
  const PurchesSeeHistory({super.key});

  @override
  State<PurchesSeeHistory> createState() => _PurchesSeeHistoryState();
}

class _PurchesSeeHistoryState extends State<PurchesSeeHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColor.primaryColor,
        title: const Text(
          "Item Purchase History",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('purchases').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child:  Lottie.asset(
                  'assets/images/Animation - 1737694620707.json', // 🔹 Ensure this file exists
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
            );
          }

          // 🔹 Data Fetched From Firestore
          final purchases = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              var purchaseData = purchases[index].data() as Map<String, dynamic>;

              String itemName = purchaseData['productName'] ?? "Unknown";
              double amount = (purchaseData['itemAmount'] ?? 0.0).toDouble();
              String purchaseDate = purchaseData['date'] ?? "Unknown Date";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.shopping_bag, color: Colors.deepPurple),
                  title: Text(
                    itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "Amount: ₹${amount.toStringAsFixed(2)}\nDate: $purchaseDate",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
