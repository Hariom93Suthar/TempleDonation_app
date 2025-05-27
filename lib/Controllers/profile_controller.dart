import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitaram_mandir/Screens/welcom_screen.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userName = "".obs;
  var userEmail = "".obs;
  var isLoading = false.obs;
  var myAmount = 0.0.obs;
  var customAmount = 0.0.obs;
  var TotalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    calculateDonation();
    fetchCustomAmount();
  }

  /// 🔹 Fetch User Data from SharedPreferences or Firestore
  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");

    if (name != null && email != null) {
      userName.value = name;
      userEmail.value = email;
    } else {
      await fetchFirestoreUserData(); // 🔹 If not found in SharedPreferences, fetch from Firestore
    }
  }

  /// 🔹 Fetch User Data from Firestore & Update SharedPreferences
  Future<void> fetchFirestoreUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        String name = userDoc["name"] ?? "User Name";
        String email = userDoc["email"] ?? "User Email";

        userName.value = name;
        userEmail.value = email;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", name);
        await prefs.setString("email", email);
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
    }
  }

  /// 🔹 Calculate Total Donation Amount from Firestore

  Future<void> calculateDonation() async {
    isLoading.value = true;
    double totalMyAmount = 0.0;
    double totalCustomAmount = 0.0;

    try {
      // Payments collection se myAmount fetch karo
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .get();

      for (var doc in paymentsSnapshot.docs) {
        totalMyAmount += (doc['amountPaid'] as num).toDouble();
      }
      myAmount.value = totalMyAmount;

      // CustomPayments collection se customAmount fetch karo
      final customPaymentsSnapshot = await _firestore
          .collection('customPayments')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .get();

      for (var doc in customPaymentsSnapshot.docs) {
        totalCustomAmount += (doc['amountPaid'] as num).toDouble();
      }
      customAmount.value = totalCustomAmount;

      // TotalAmount = myAmount + customAmount
      TotalAmount.value = myAmount.value + customAmount.value;
    } catch (e) {
      print("Error fetching donation data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Refresh Data (Now also refreshes Firestore User Data)
  Future<void> refreshData() async {
    await fetchFirestoreUserData();
    await calculateDonation();
    myAmount.value + customAmount.value;
    myAmount.value;
    customAmount.value;
  }

  /// 🔹 Logout Function
  Future<void> logoutUser() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 🔹 Clear local data
    Get.offAll(WelcomeScreen());
  }

  // 🔹 Custom Donation Total Calculation
  Future<void> fetchCustomAmount() async {
    isLoading.value = true;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot customPaymentSnapshot = await FirebaseFirestore.instance
        .collection('customPayments')
        .where('userId', isEqualTo: user.uid)
        .get();

    double customTotal = 0.0;
    for (var doc in customPaymentSnapshot.docs) {
      customTotal += (doc['amountPaid'] ?? 0).toDouble();
    }
    customAmount.value = customTotal;
    isLoading.value = false;
  }
}
