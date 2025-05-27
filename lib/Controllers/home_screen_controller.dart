import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxDouble totalRevenue = 0.0.obs;
  RxDouble buyProductsAmount = 0.0.obs;
  RxDouble remainingRevenue = 0.0.obs;

  /// 🔹 Fetch Total Revenue, Buy Products & Remaining Revenue
  Future<void> fetchAllData() async {
    double tempTotalRevenue = await _calculateTotalRevenue();
    double tempBuyProducts = await _calculateBuyProductsAmount();

    totalRevenue.value = tempTotalRevenue;
    buyProductsAmount.value = tempBuyProducts;
    remainingRevenue.value = totalRevenue.value - buyProductsAmount.value;
  }

  /// 🔹 Calculate Total Revenue (Sum of All Payments)
  Future<double> _calculateTotalRevenue() async {
    double total = 0.0;

    // 🔹 Get Payments Collection Total
    final paymentsSnapshot = await FirebaseFirestore.instance.collection('payments').get();
    for (var doc in paymentsSnapshot.docs) {
      double amount = (doc['amountPaid'] ?? 0).toDouble();
      total += amount;
    }

    // 🔹 Get CustomPayments Collection Total
    final customPaymentsSnapshot = await FirebaseFirestore.instance.collection('customPayments').get();
    for (var doc in customPaymentsSnapshot.docs) {
      double customAmount = (doc['amountPaid'] ?? 0).toDouble();
      total += customAmount;
    }
    return total;
  }


  /// 🔹 Calculate Total Buy Products Amount (Admin Side Upload)
  Future<double> _calculateBuyProductsAmount() async {
    double total = 0.0;
    final buyProductsSnapshot = await FirebaseFirestore.instance.collection('purchases').get();

    for (var doc in buyProductsSnapshot.docs) {
      double amount = (doc['itemAmount'] ?? 0).toDouble();
      total += amount;
    }
    return total;
  }

  @override
  void onInit() {
    fetchAllData();
    super.onInit();
  }
}
