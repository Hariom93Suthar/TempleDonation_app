import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sitaram_mandir/Screens/Auth/admin_permission_screen.dart';
import 'package:sitaram_mandir/Screens/bottemNav/tab_view.dart';
import 'package:sitaram_mandir/Screens/welcom_screen.dart';
import 'package:sitaram_mandir/Widgets/custom_loading_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDwYidB5cjo6COhh1SgD1FJhWMH2eISE3U",
        authDomain: "sitarammandir-9312c.firebaseapp.com",
        projectId: "sitarammandir-9312c",
        storageBucket: "sitarammandir-9312c.firebasestorage.app",
        messagingSenderId: "141566649480",
        appId: "1:141566649480:web:4fe662d8acc834f3a66b3d",
        measurementId: "G-76Q1XP68CB",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sitaram Mandir',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthCheckScreen(),
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  Future<void> _navigateUser() async {
    await Future.delayed(Duration(seconds: 1));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        bool isApproved = userDoc['isApproved'] ?? false;

        if (isApproved) {
          Get.offAll(() => TabView());
        } else {
          Get.offAll(() => PendingApprovalScreen());
        }
      } else {
        Get.offAll(() => WelcomeScreen());
      }
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomLoadingAPI() // Loading Indicator
      ),
    );
  }
}
