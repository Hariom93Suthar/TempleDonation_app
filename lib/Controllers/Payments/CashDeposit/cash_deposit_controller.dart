import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CashDepositController extends GetxController {
  var selectedUser = RxString('');
  var userId = RxString('');
  var phone = RxString('');
  var amount = RxDouble(0.0);
  var alreadyPaidThisMonth = RxBool(false);
  var userNames = <String>[].obs;
  // Add this variable in your controller
  var totalCashDeposit = RxDouble(0.0);

  @override
  void onInit() {
    super.onInit();
    fetchUserNames();
    fetchTotalCashDeposit(); // Call the new function here
  }

  // Fetch Users for Dropdown
  Future<void> fetchUserNames() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    userNames.value = usersSnapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  // On User Selection - Auto-fill Details
  Future<void> onUserSelected(String? name) async {
    if (name == null) return;
    alreadyPaidThisMonth.value = false;

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      selectedUser.value = name;
      userId.value = userDoc.id;
      phone.value = userDoc['phone'];
      checkIfAlreadyPaid();
    }
  }

  // Check If Already Paid for Current Month
  Future<void> checkIfAlreadyPaid() async {
    if (userId.value.isEmpty) return;

    String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    QuerySnapshot paymentSnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: userId.value)
        .where('month', isEqualTo: currentMonth)
        .get();

    if (paymentSnapshot.docs.isNotEmpty) {
      alreadyPaidThisMonth.value = true;
      amount.value = 0.0;
    } else {
      calculatePendingAmount();
    }
  }

  // Calculate Pending Amount
  Future<void> calculatePendingAmount() async {
    if (userId.value.isEmpty) return;

    String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    QuerySnapshot paymentHistory = await FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: userId.value)
        .orderBy('month', descending: true)
        .get();

    if (paymentHistory.docs.isEmpty) {
      amount.value = 100.0;
      return;
    }

    DocumentSnapshot lastPayment = paymentHistory.docs.first;
    String lastPaidMonth = lastPayment["month"];

    DateTime lastPaidDate = DateTime.parse(lastPaidMonth + "-01");
    DateTime currentDate = DateTime.parse(currentMonth + "-01");

    int missedMonths = ((currentDate.year - lastPaidDate.year) * 12) +
        (currentDate.month - lastPaidDate.month);

    amount.value = missedMonths > 3 ? 300.0 : missedMonths * 100.0;
    if (amount.value < 100.0) amount.value = 100.0;
  }

  // Submit Payment Details
  Future<void> savePaymentDetails(String paymentId) async {
    if (selectedUser.value.isEmpty || userId.value.isEmpty || phone.value.isEmpty) {
      Get.snackbar('Error', 'User details are missing!');
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    await FirebaseFirestore.instance.collection('payments').add({
      'userId': userId.value,
      'name': selectedUser.value,
      'phone': phone.value,
      'amountPaid': amount.value,
      'date': formattedDate,
      'month': currentMonth,
      'paymentId': paymentId,
    });

    alreadyPaidThisMonth.value = true;
  }

  // On Submit Button Click
  void submitPayment() async {
    if (selectedUser.value.isEmpty || amount.value == 0) {
      Get.snackbar('Error', 'Please select a user and ensure amount is not zero!');
      return;
    }

    String paymentId = "Cash Deposit";

    try {
      await savePaymentDetails(paymentId);
      selectedUser.value = '';
      phone.value = '';
      userId.value = '';
      amount.value = 0;
      Get.snackbar('Success', 'Payment Submitted Successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    }
  }

  // Update this function in CashDepositController
  Future<void> fetchTotalCashDeposit() async {
    QuerySnapshot paymentsSnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('paymentId', isEqualTo: 'Cash Deposit')
        .get();

    double total = 0.0;
    for (var doc in paymentsSnapshot.docs) {
      total += (doc['amountPaid'] as num).toDouble();
    }
    totalCashDeposit.value = total;
  }

}
