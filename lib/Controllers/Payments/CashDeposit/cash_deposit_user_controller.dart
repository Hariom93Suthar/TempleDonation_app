import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CashDepositUserDataController extends GetxController {
  var selectedYear = ''.obs;
  var selectedMonth = ''.obs;
  var cashDepositData = [].obs;
  var allData = [].obs;

  // Month List with Names
  final List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Dynamic Year List
  List<String> get years {
    int currentYear = DateTime.now().year;
    List<String> yearList = [];
    for (int year = 2024; year <= currentYear; year++) {
      yearList.add(year.toString());
    }
    return yearList;
  }

  @override
  void onInit() {
    fetchCashDepositData();
    super.onInit();
  }

  void fetchCashDepositData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('paymentId', isEqualTo: 'Cash Deposit')
        .get();

    var data = snapshot.docs.map((doc) {
      print(doc.data()); // Debugging ke liye
      return {
        'name': doc['name'],
        'amountPaid': doc['amountPaid'].toString(),
        'date': doc['date']
      };
    }).toList();

    allData.value = data;
    cashDepositData.value = data;
  }

  void filterData() {
    if (selectedYear.isNotEmpty && selectedMonth.isNotEmpty) {
      cashDepositData.value = allData.where((element) {
        DateTime date = DateTime.parse(element['date']);
        String monthName = monthNames[date.month - 1];
        return date.year.toString() == selectedYear.value &&
            monthName == selectedMonth.value;
      }).toList();
    } else {
      cashDepositData.value = allData;
    }
  }
}
