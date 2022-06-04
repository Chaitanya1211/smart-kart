import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_kart/pages/orderSummary.dart';

class DisplayItems extends StatefulWidget {
  String title;
  String documentId;
  DisplayItems({Key? key, required this.documentId, required this.title})
      : super(key: key);

  @override
  State<DisplayItems> createState() => _DisplayItemsState();
}

class _DisplayItemsState extends State<DisplayItems> {
  late Map<String, dynamic> details;
  String formatter = DateFormat('yMd').format(DateTime.now());
  var _itemId;
  var _itemName;
  int total = 0;
  var _itemCost;

  @override
  Future<void> scanQR() async {
    var barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      details = jsonDecode(barcodeScanRes);
      // print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _itemId = details['id'];
      _itemName = details['name'];
      _itemCost = details['cost'];
    });

    total += int.parse(_itemCost);
    CollectionReference currentInstance = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection('shoppings')
        .doc(widget.documentId)
        .collection('items')
        .doc()
        .set({
      "itemId": _itemId.toString(),
      "itemName": _itemName.toString(),
      "itemCost": _itemCost.toString()
    }) as CollectionReference<Object?>;
  }

  Widget build(BuildContext context) {
    // String shoppingTitle = widget.title;
    // FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(FirebaseAuth.instance.currentUser?.uid.toString())
    //     .collection('shoppings')
    //     .doc(widget.documentId)
    //     .set({'title': widget.title, 'date': formatter.toString()});
    final Stream<QuerySnapshot<Map<String, dynamic>>> itemsStream =
        FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .collection('shoppings')
            .doc(widget.documentId)
            .collection('items')
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: itemsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          final List storedocs = [];
          snapshot.data?.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            // a['id'] = document.id;
          }).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Container(
                        height: 20,
                        margin: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(widget.title),
                            ),
                            Container(
                              child: Text(formatter),
                            )
                          ],
                        )),
                    // Text(widget.title.toString()),
                    for (var i = 0; i < storedocs.length; i++) ...[
                      Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(storedocs[i]['itemId']),
                                ),
                                Container(
                                  child: Text(storedocs[i]['itemCost']),
                                ),
                                Container(
                                  child: Text(storedocs[i]['itemName']),
                                )
                              ],
                            ),
                          ))
                    ]
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
                elevation: 50,
                color: Colors.blue,
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Cart total : ${total}"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 50,
                            // backgroundColor : Colors.blue,
                            primary: Color.fromARGB(255, 3, 112, 255)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderSummary(
                                      documentId: widget.documentId,
                                      total: total.toString())));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.shopping_cart_checkout),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Checkout")
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                scanQR();
              },
              label: Text("Add Item"),
              icon: Icon(Icons.add),
            ),
          );
        });
  }
}
