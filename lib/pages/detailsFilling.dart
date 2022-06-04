import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_kart/pages/shoppingInstance.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String formatter = DateFormat('yMd').format(DateTime.now());
  // String collectionId = DateTime.now().microsecondsSinceEpoch.toString();
  TextEditingController _title = TextEditingController();
  TextEditingController _budget = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text("Please fill in the details before the shopping"),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: _title,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: "Title",
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: _budget,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: "Set Limit In Ruppees",
                        prefixIcon: Icon(Icons.money),
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // Container(margin: EdgeInsets.all(5), child: Text(formatter)),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      String docId =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(
                              FirebaseAuth.instance.currentUser?.uid.toString())
                          .collection('shoppings')
                          .doc(docId)
                          .set({
                        'title': _title.text,
                        'date': formatter.toString()
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => DisplayItems(
                                    documentId: docId,
                                    title: _title.text,
                                  ))));
                    },
                    child: Text("Start Shopping"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
