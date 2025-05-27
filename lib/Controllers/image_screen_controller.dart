// Import Statements
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ImageController extends GetxController {
  ScreenshotController screenshotController = ScreenshotController();
  String userName = '';
  String amount = '';
  String date = '';
  String time = '';
  String transactionId = '';

  // Set Data Function
  void setData({
    required String name,
    required String amt,
    required String dt,
    required String tm,
    required String txnId,
  }) {
    userName = name;
    amount = amt;
    date = dt;
    time = tm;
    transactionId = txnId;
    update();
  }

  // Share Image Function
  void shareImage() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/receipt.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      await Share.shareXFiles([XFile(imageFile.path)],
          text: "Check out my payment receipt!");
    }
  }
}
