import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sitaram_mandir/Controllers/Payments/customPayments_controllers.dart';
import 'package:sitaram_mandir/Controllers/Payments/payment_controller.dart';

class PaymentScreen extends StatelessWidget {

  final RazorpayController paymentController = Get.put(RazorpayController());
  CustomPaymentController customPaymentController = Get.put(CustomPaymentController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Payments", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Lottie.asset("assets/images/Animation - 1738998460990.json", height: 150)),
                SizedBox(height: 20),

                Text("Custom Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                SizedBox(height: 10),
                Text(
                  "Want to donate more? Enter your custom amount and contribute as per your wish.",
                  style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: customPaymentController.customAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                    hintStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: customPaymentController.startCustomPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text("Pay Amount", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),

                SizedBox(height: 50),
                Text("Fixed Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                SizedBox(height: 10),
                Text(
                  "Pay your monthly donation securely. If you’ve already paid this month, wait for the next cycle.",
                  style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),

                Obx(() => Center(
                  child: Text(
                    paymentController.alreadyPaidThisMonth.value
                        ? "You have already paid for this month!"
                        : "Your Due Amount",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                )),

                SizedBox(height: 10),
                Obx(() => Center(
                  child: Text(
                    paymentController.alreadyPaidThisMonth.value ? "₹0.00" : "₹${paymentController.amount.value}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: paymentController.alreadyPaidThisMonth.value ? Colors.green : Colors.orange,
                    ),
                  ),
                )),

                SizedBox(height: 20),
                Obx(() {
                  if (!paymentController.alreadyPaidThisMonth.value) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: paymentController.startDefaultPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text("Pay ₹${paymentController.amount.value}", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;
//   double amount = 100.0;
//   String userName = "Fetching...";
//   String userPhone = "Fetching...";
//   TextEditingController manualAmountController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _fetchUserDetails();
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   /// 🔹 Fetch Current User Details from Firestore
//   Future<void> _fetchUserDetails() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//
//     if (userDoc.exists) {
//       setState(() {
//         userName = userDoc['name'] ?? 'No Name';
//         userPhone = userDoc['phone'] ?? 'No Phone';
//       });
//     }
//   }
//
//   /// 🔹 Start Payment with Razorpay
//   void _startPayment(double paymentAmount) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Please login first!"),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     var options = {
//       'key': 'rzp_live_xxxxxxxxxxxxxx', // 🔹 Live API Key
//       'amount': (paymentAmount * 100).toInt(),
//       'currency': 'INR',
//       'name': 'Ram Mandir Donation',
//       'description': 'Donation ₹$paymentAmount',
//       'prefill': {
//         'contact': userPhone,
//         'email': user.email ?? '',
//       },
//       'theme': {'color': '#FF9800'},
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   /// 🔹 Payment Success Handling
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     _savePaymentDetails(response.paymentId ?? "Unknown");
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("Payment Successful!"),
//       backgroundColor: Colors.green,
//     ));
//   }
//
//   /// 🔹 Payment Error Handling
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("Payment Failed: ${response.message}"),
//       backgroundColor: Colors.red,
//     ));
//   }
//
//   /// 🔹 External Wallet Handling
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("External Wallet Selected: ${response.walletName}"),
//       backgroundColor: Colors.blue,
//     ));
//   }
//
//   /// 🔹 Save Payment Details in Firestore
//   Future<void> _savePaymentDetails(String paymentId) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
//     String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
//
//     await FirebaseFirestore.instance.collection('payments').add({
//       'userId': user.uid,
//       'name': userName,
//       'phone': userPhone,
//       'amountPaid': amount,
//       'date': formattedDate,
//       'month': currentMonth,
//       'paymentId': paymentId,
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Payments", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.teal,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Enter Custom Amount"),
//             TextField(
//               controller: manualAmountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: "Enter Amount",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 double enteredAmount = double.tryParse(manualAmountController.text) ?? 0;
//                 if (enteredAmount > 0) {
//                   _startPayment(enteredAmount);
//                 }
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//               child: Text("Pay Now", style: TextStyle(fontSize: 18, color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

