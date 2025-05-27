import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sitaram_mandir/Utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("User Management",style: TextStyle(color: white),),
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users available"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              String userId = user.id;
              String name = user['name'] ?? "No Name";
              String email = user['email'] ?? "No Email";
              String phone = user['phone'] ?? "No Phone";
              bool isApproved = user['isApproved'] ?? false;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 User Details
                      Text("Name: $name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 5),
                      Text("Email: $email", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      SizedBox(height: 5),

                      // ✅ Phone Number with Copy & Call Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Phone: $phone",
                            style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              // 📋 Copy Button
                              IconButton(
                                icon: Icon(Icons.copy, color: Colors.grey[700]),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: phone));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Phone number copied!"))
                                  );
                                },
                              ),

                              // 📞 Call Button
                              IconButton(
                                icon: Icon(Icons.call, color: Colors.green),
                                onPressed: () {
                                  _makePhoneCall(phone);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // 🔹 Actions Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ✅ Approval Toggle
                          Row(
                            children: [
                              Text("Approve", style: TextStyle(fontSize: 14, color: Colors.black54)),
                              Switch(
                                value: isApproved,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  _updateApprovalStatus(userId, value);
                                },
                              ),
                            ],
                          ),

                          // ✅ Edit Button
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editUser(userId, name, phone);
                            },
                          ),

                          // ✅ Delete Button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(userId),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 🔹 Update User Approval Status in Firestore
  void _updateApprovalStatus(String userId, bool newStatus) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isApproved': newStatus,
    });
  }

  /// 🔹 Delete User from Firestore
  void _deleteUser(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(userId).delete();
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 🔹 Edit User Function (Name & Phone Update)
  void _editUser(String userId, String currentName, String currentPhone) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController phoneController = TextEditingController(text: currentPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(userId).update({
                'name': nameController.text.trim(),
                'phone': phoneController.text.trim(),
              });
              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  /// 🔹 Call Function
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not launch call!"))
      );
    }
  }
}
