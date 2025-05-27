import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentHistoryController extends GetxController {
  var selectedYear = DateFormat('yyyy').format(DateTime.now()).obs;
  var selectedMonth = DateFormat('MM').format(DateTime.now()).obs;
  var yearList = <String>[].obs;
  var monthList = <String>[].obs;
  var paymentHistory = <Map<String, dynamic>>[].obs;
  var customPaymentHistory = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isScheduledSelected = true.obs; // Toggle Button ke liye
  var isScheduledHistory = true.obs; // Toggle ke liye Observable


  @override
  void onInit() {
    super.onInit();
    _generateYearList();
    _generateMonthList();
    fetchPaymentHistory();
    fetchCustomPaymentHistory();
  }

  /// 🔹 Generate Year List (2020 - Current Year)
  void _generateYearList() {
    int currentYear = DateTime.now().year;
    for (int year = 2020; year <= currentYear; year++) {
      yearList.add(year.toString());
    }
  }

  /// 🔹 Generate Month List (January - December)
  void _generateMonthList() {
    monthList.clear();
    for (int month = 1; month <= 12; month++) {
      monthList.add(month.toString().padLeft(2, '0'));
    }
  }

  /// 🔹 Fetch Scheduled Payment History
  Future<void> fetchPaymentHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String selectedFilter = "${selectedYear.value}-${selectedMonth.value}";

    try {
      isLoading.value = true;
      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('userId', isEqualTo: user.uid)
          .where('month', isEqualTo: selectedFilter)
          .get();

      if (paymentsSnapshot.docs.isEmpty) {
        paymentHistory.clear();
      } else {
        paymentHistory.value = paymentsSnapshot.docs.map((doc) {
          var data = doc.data();
          return {
            'amount': data['amountPaid'] ?? 0,
            'date': data['date'] is Timestamp
                ? (data['date'] as Timestamp).toDate()
                : DateTime.now(),
          };
        }).toList();
      }
    } catch (e) {
      print("Firestore Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCustomPaymentHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String selectedFilter = "${selectedYear.value}-${selectedMonth.value}";

    try {
      isLoading.value = true;
      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('customPayments')
          .where('userId', isEqualTo: user.uid)
          .where('month', isEqualTo: selectedFilter)
          .get();

      if (paymentsSnapshot.docs.isEmpty) {
        customPaymentHistory.clear();
      } else {
        customPaymentHistory.value = paymentsSnapshot.docs.map((doc) {
          var data = doc.data();
          return {
            'amount': data['amountPaid'] ?? 0,
            'date': data['date'] is Timestamp
                ? (data['date'] as Timestamp).toDate()
                : DateTime.now(),
          };
        }).toList();
      }
    } catch (e) {
      print("Firestore Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Refresh Function
  void refreshHistory() {
    if (isScheduledSelected.value) {
      fetchPaymentHistory();
    } else {
      fetchCustomPaymentHistory();
    }
  }

  /// 🔹 Toggle History View
  void toggleHistoryView(bool isScheduled) {
    isScheduledSelected.value = isScheduled;
  }
}
