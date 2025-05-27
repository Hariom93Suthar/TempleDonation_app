import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sitaram_mandir/Controllers/image_screen_controller.dart';
import 'package:sitaram_mandir/Screens/UserProfile/image_screen.dart';

class CustomPaymentController extends GetxController {
  late Razorpay _razorpay;
  var customAmount = 0.0.obs;
  var userName = "Fetching...".obs;
  var userPhone = "Fetching...".obs;
  TextEditingController customAmountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchUserDetails();
  }

  @override
  void onClose() {
    _razorpay.clear();
    customAmountController.dispose();
    super.onClose();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      userName.value = userDoc['name'] ?? 'No Name';
      userPhone.value = userDoc['phone'] ?? 'No Phone';
    }
  }

  void startCustomPayment() {
    double enteredAmount = double.tryParse(customAmountController.text) ?? 0;
    if (enteredAmount <= 0) {
      Get.snackbar("Invalid Amount", "Please enter a valid amount!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    customAmount.value = enteredAmount;
    _startPayment(customAmount.value);
  }

  void _startPayment(double paymentAmount) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Login Required", "Please login first!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    var options = {
      'amount': (paymentAmount * 100).toInt(),
      'currency': 'INR',
      'name': 'Custom Payment',
      'description': 'Payment ₹$paymentAmount',
      'prefill': {
        'contact': userPhone.value,
        'email': user.email ?? '',
      },
      'theme': {'color': '#FF9800'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _savePaymentDetails(response.paymentId ?? "Unknown");
    customAmountController.clear();

    ImageController imageController = Get.put(ImageController());
    imageController.setData(
      name: userName.value,
      amt: customAmount.value.toString(),
      dt: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      tm: DateFormat('hh:mm:ss a').format(DateTime.now()),
      txnId: response.paymentId ?? "Unknown",
    );

    Get.to(() => ImageScreen());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Unknown Error",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", response.walletName ?? "Unknown Wallet",
        backgroundColor: Colors.blue, colorText: Colors.white);
  }

  Future<void> _savePaymentDetails(String paymentId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    await FirebaseFirestore.instance.collection('customPayments').add({
      'userId': user.uid,
      'name': userName.value,
      'phone': userPhone.value,
      'amountPaid': customAmount.value,
      'month': currentMonth,
      'date': formattedDate,
      'paymentId': paymentId,
    });
  }
}
