import 'package:flutter/material.dart';
import 'package:sitaram_mandir/Screens/bottemNav/all_user_screen.dart';
import 'package:sitaram_mandir/Screens/bottemNav/donation_screen.dart';
import 'package:sitaram_mandir/Screens/bottemNav/home_screen.dart';
import 'package:sitaram_mandir/Screens/bottemNav/profile_screen.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _currentIndex = 0; // 🔹 Active Tab Index

  final List<Widget> _screens = [
    HomeScreen(),
    AllUsersScreen(),
    DonationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // 🔹 Active Screen Show Karega
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // 🔹 Labels Always Visible
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/hicon.png", height: 24),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/micon.png", height: 24),
            label: "Members",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/dicon.png", height: 24),
            label: "Donation",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/picon.png", height: 24),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
