import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomDonationController extends GetxController {
  RxList<Map<String, dynamic>> customDonations = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredDonations = <Map<String, dynamic>>[].obs;
  RxDouble totalAmount = 0.0.obs;
  RxString searchQuery = ''.obs;
  RxString selectedYear = ''.obs;
  RxString selectedMonth = ''.obs;
  var isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchDonations();
  }

  /// 🔥 Fetch Data from Firestore
  Future<void> fetchDonations() async {
    isLoading.value = true;  // 🔹 Loading Start
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('customPayments')
          .orderBy('date', descending: true)  // 🔥 Date-wise sorting (latest first)
          .get();

      List<Map<String, dynamic>> fetchedDonations = snapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'amountPaid': doc['amountPaid'],
          'date': doc['date'],
        };
      }).toList();

      customDonations.value = fetchedDonations;
      filteredDonations.value = fetchedDonations;
      calculateTotalAmount();
    } catch (e) {
      print('Error fetching donations: $e');
    } finally {
      isLoading.value = false;  // 🔹 Loading End
    }
  }


  /// 🔥 Calculate Total Custom Amount
  void calculateTotalAmount() {
    double total = 0.0;
    for (var donation in filteredDonations) {
      total += double.parse(donation['amountPaid'].toString());
    }
    totalAmount.value = total;
  }

  /// 🔥 Search and Filter Logic
  void filterDonations() {
    List<Map<String, dynamic>> tempList = customDonations;

    // 🔹 Search by Name
    if (searchQuery.isNotEmpty) {
      tempList = tempList.where((item) =>
          item['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }

    // 🔹 Filter by Year & Month
    if (selectedYear.isNotEmpty) {
      tempList = tempList.where((item) =>
          item['date'].toString().contains(selectedYear.value)).toList();
    }
    if (selectedMonth.isNotEmpty) {
      tempList = tempList.where((item) =>
          item['date'].toString().contains(selectedMonth.value)).toList();
    }

    filteredDonations.value = tempList;
    calculateTotalAmount();
  }
}
