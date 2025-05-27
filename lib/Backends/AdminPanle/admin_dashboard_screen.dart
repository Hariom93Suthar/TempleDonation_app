import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sitaram_mandir/Backends/AdminPanle/CashDeposit/cash_deposit_screen.dart';
import 'package:sitaram_mandir/Backends/AdminPanle/product_management.dart';
import 'package:sitaram_mandir/Backends/AdminPanle/user_management.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  int totalUsers = 0;
  double totalRevenue = 0.0;
  double totalItemPurchase = 0.0;
  int totalProducts = 0;

  late AnimationController _controller;
  late Animation<int> _userCountAnimation;
  late Animation<double> _revenueAnimation;
  late Animation<double> _purchaseAnimation;
  late Animation<int> _productCountAnimation;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();

    // 🔹 Animation Controller
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _userCountAnimation = IntTween(begin: 0, end: totalUsers).animate(_controller);
    _revenueAnimation = Tween<double>(begin: 0, end: totalRevenue).animate(_controller);
    _purchaseAnimation = Tween<double>(begin: 0, end: totalItemPurchase).animate(_controller);
    _productCountAnimation = IntTween(begin: 0, end: totalProducts).animate(_controller);
  }

  /// 🔹 Firestore Se Data Fetch Karke State Update Karega
  Future<void> _fetchDashboardData() async {
    int users = await _fetchTotalUsers();
    double revenue = await _fetchTotalRevenue();
    double purchase = await _fetchTotalPurchaseAmount();
    int products = await _fetchTotalProducts();

    setState(() {
      totalUsers = users;
      totalRevenue = revenue;
      totalItemPurchase = purchase;
      totalProducts = products;
    });

    // 🔹 Update Animations & Start Counting Effect
    _userCountAnimation = IntTween(begin: 0, end: totalUsers).animate(_controller);
    _revenueAnimation = Tween<double>(begin: 0, end: totalRevenue).animate(_controller);
    _purchaseAnimation = Tween<double>(begin: 0, end: totalItemPurchase).animate(_controller);
    _productCountAnimation = IntTween(begin: 0, end: totalProducts).animate(_controller);

    _controller.forward();
  }

  Future<int> _fetchTotalUsers() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    return usersSnapshot.docs.length;
  }

  Future<double> _fetchTotalRevenue() async {
    double total = 0.0;

    try {
      // 🔹 Payments Collection
      QuerySnapshot paymentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .get();

      for (var doc in paymentsSnapshot.docs) {
        total += (doc['amountPaid'] ?? 0.0).toDouble();
      }

      // 🔹 CustomPayments Collection
      QuerySnapshot customPaymentsSnapshot = await FirebaseFirestore.instance
          .collection('customPayments')
          .get();

      for (var doc in customPaymentsSnapshot.docs) {
        total += (doc['amountPaid'] ?? 0.0).toDouble();
      }
    } catch (e) {
      print('Error fetching revenue: $e');
    }

    return total;
  }


  Future<double> _fetchTotalPurchaseAmount() async {
    double total = 0.0;
    QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance.collection('purchases').get();
    for (var doc in purchaseSnapshot.docs) {
      total += (doc['itemAmount'] ?? 0.0).toDouble();
    }
    return total;
  }

  Future<int> _fetchTotalProducts() async {
    QuerySnapshot productsSnapshot = await FirebaseFirestore.instance.collection('purchases').get();
    return productsSnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Admin Dashboard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
        backgroundColor: CustomColor.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await _fetchTotalRevenue();
          await _fetchDashboardData();
          await _fetchTotalPurchaseAmount();
          await _fetchTotalUsers();
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome, Admin!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal)),
              SizedBox(height: 20),

              // 🔹 Dashboard Cards with Animated Counting Effect
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dashboardCard("Total Users", Icons.people, Colors.blue, _userCountAnimation),
                  _dashboardCard("Total Revenue", Icons.currency_rupee, Colors.green, _revenueAnimation),
                ],
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dashboardCard("Purchases Amount", Icons.shopping_basket, Colors.orange, _purchaseAnimation),
                  _dashboardCard("Total Products", Icons.store, Colors.purple, _productCountAnimation),
                ],
              ),
              SizedBox(height: 20),

              // 🔹 Management Sections
              Expanded(
                child: ListView(
                  children: [
                    _managementTile("User Management", Icons.person, Colors.blue, () {
                      Get.to(() => UserManagementScreen());
                    }),
                    _managementTile("Product Management", Icons.store, Colors.green, () {
                      Get.to(() => ProductManagementScreen());
                    }),
                    _managementTile("Cash Deposit", Icons.account_balance_wallet_rounded, Colors.teal, () {
                      Get.to(() => CashDepositScreen());
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Dashboard Card with Animated Counting
  Widget _dashboardCard(String title, IconData icon, Color color, Animation animation) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Text(
                    title.contains("Revenue") || title.contains("Purchases")
                        ? "₹${animation.value.toStringAsFixed(2)}"
                        : animation.value.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Management List Tile UI
  Widget _managementTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100,
        width: double.infinity,
        child: ListTile(
          leading: Icon(icon, size: 30, color: color),
          title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: onTap,
        ),
      ),
    );
  }
}
