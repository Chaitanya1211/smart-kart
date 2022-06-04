import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowDetails extends StatefulWidget {
  String payId;
  String title;
  String amount;
  String date;
  String id;
  ShowDetails(
      {Key? key,
      required this.id,
      required this.amount,
      required this.date,
      required this.title,
      required this.payId})
      : super(key: key);

  @override
  State<ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> itemsStream =
        FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .collection('shoppings')
            .doc(widget.id)
            .collection('items')
            .snapshots();
    return StreamBuilder(
        stream: itemsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List storedocs = [];
          snapshot.data?.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            // a['id'] = document.id;
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Order Details"),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                padding: EdgeInsets.all(8),
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   width: 50,
                        // ),
                        Text(
                          "Item's List",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  for (var i = 0; i < storedocs.length; i++) ...[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(storedocs[i]['itemName']),
                              Text(" ₹ ${storedocs[i]['itemCost']} /-")
                            ]),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      height: 5,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                  ]
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.blue,
              child: Container(
                height: 120,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date : ${widget.date}"),
                        Text("Expense : ${widget.amount}/-")
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text("Payment ID : ${widget.payId}")],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
