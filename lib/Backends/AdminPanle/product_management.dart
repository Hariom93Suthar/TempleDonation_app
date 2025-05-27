import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sitaram_mandir/Utils/colors.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 🔹 Product Save Karega Firestore Me "purchases" Collection Me
  Future<void> _saveProduct() async {
    if (_productNameController.text.isEmpty || _amountController.text.isEmpty) {
      _showSnackbar("Please fill all fields", Colors.red);
      return;
    }

    await FirebaseFirestore.instance.collection('purchases').add({
      'productName': _productNameController.text.trim(),
      'date': _selectedDate,
      'itemAmount': double.parse(_amountController.text.trim()),
    });

    _productNameController.clear();
    _amountController.clear();
    setState(() {
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });

    _showSnackbar("Product Saved Successfully!", Colors.green);
  }

  /// 🔹 Firestore Se Data Delete Karega
  Future<void> _deleteProduct(String docId) async {
    await FirebaseFirestore.instance.collection('purchases').doc(docId).delete();
    _showSnackbar("Product Deleted Successfully!", Colors.red);
  }

  /// 🔹 Firestore Se Data Update Karega
  Future<void> _updateProduct(String docId, String newName, double newAmount) async {
    await FirebaseFirestore.instance.collection('purchases').doc(docId).update({
      'productName': newName,
      'itemAmount': newAmount,
    });
    _showSnackbar("Product Updated Successfully!", Colors.blue);
  }

  /// 🔹 Snackbar Message Show Karega
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  /// 🔹 Date Picker Ko Show Karega
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Product Management",style: TextStyle(color: white,fontWeight: FontWeight.w500),),
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Product Name Input
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
               hintText: "Product Name",
                hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.shopping_cart),
              ),
            ),
            SizedBox(height: 15),

            // 🔹 Amount Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Amount",
                hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            SizedBox(height: 15),

            // 🔹 Date Picker
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select Date",
                  hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedDate, style: TextStyle(fontSize: 16)),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  backgroundColor: CustomColor.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Save Product", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Product List
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('purchases').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child:Lottie.asset("assets/images/Animation - 1737694620707.json",height: 200));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      return Card(
                        elevation: 4,
                        child: ListTile(
                          leading: Icon(Icons.shopping_cart, color: Colors.green),
                          title: Text(data['productName'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Date: ${data['date']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹${data['itemAmount']}", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),

                              // 🔹 Edit Button
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditDialog(doc.id, data['productName'], data['itemAmount']);
                                },
                              ),

                              // 🔹 Delete Button
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteProduct(doc.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Product Edit Dialog
  void _showEditDialog(String docId, String currentName, double currentAmount) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController amountController = TextEditingController(text: currentAmount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Product Name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _updateProduct(docId, nameController.text.trim(), double.parse(amountController.text.trim()));
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
