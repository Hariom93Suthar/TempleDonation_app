import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationController extends GetxController {
  var selectedYear = DateFormat('yyyy').format(DateTime.now()).obs;
  var selectedMonth = DateFormat('MMMM').format(DateTime.now()).obs;
  var totalRevenue = 0.0.obs;
  var paidUsers = <Map<String, dynamic>>[].obs;
  var unpaidUsers = <Map<String, dynamic>>[].obs;
  var showPaidUsers = true.obs;

  var yearList = <String>[].obs;
  var monthList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateYearList();
    _generateMonthList();
    fetchDonationData();
  }

  /// 🔹 Generate Year List (2024 - Current Year)
  void _generateYearList() {
    int currentYear = DateTime.now().year;
    List<String> tempList = [];
    for (int year = 2024; year <= currentYear; year++) {
      tempList.add(year.toString());
    }
    yearList.assignAll(tempList);
  }

  /// 🔹 Generate Month List (January - December)
  void _generateMonthList() {
    List<String> tempList = [];
    for (int month = 1; month <= 12; month++) {
      tempList.add(DateFormat('MMMM').format(DateTime(0, month)));
    }
    monthList.assignAll(tempList);
  }

  /// 🔹 Fetch Paid & Unpaid Users for Selected Year & Month
  Future<void> fetchDonationData() async {
    String selectedFilter = "${selectedYear.value}-${DateFormat('MM').format(DateFormat('MMMM').parse(selectedMonth.value))}";

    QuerySnapshot paymentsSnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('month', isEqualTo: selectedFilter) // 🔹 Sirf selected month ke liye filter
        .get();

    QuerySnapshot allUsersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    double revenue = 0.0;
    List<Map<String, dynamic>> paid = [];
    List<Map<String, dynamic>> unpaid = [];
    Set<String> paidUserPhones = {}; // 🔹 Store paid user phone numbers

    // 🔹 Get paid users for selected month
    for (var doc in paymentsSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      revenue += data['amountPaid'];

      paid.add({
        "name": data["name"],
        "phone": data["phone"],
        "amount": data["amountPaid"]
      });

      paidUserPhones.add(data["phone"]); // 🔹 Store paid users' phone numbers
    }

    // 🔹 Get all users & filter unpaid ones
    for (var userDoc in allUsersSnapshot.docs) {
      Map<String, dynamic> user = {
        "userId": userDoc.id,
        "name": userDoc["name"],
        "phone": userDoc["phone"]
      };

      if (!paidUserPhones.contains(user["phone"])) {
        unpaid.add(user);
      }
    }

    totalRevenue.value = revenue;
    paidUsers.assignAll(paid);
    unpaidUsers.assignAll(unpaid);
  }
}
