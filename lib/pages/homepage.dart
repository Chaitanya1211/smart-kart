import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_kart/pages/detailsFilling.dart';
import 'package:smart_kart/pages/showDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> shoppingStream =
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .collection('shoppings')
          .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: shoppingStream,
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
            a['id'] = document.id;
          }).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text("Hello User"),
              elevation: 20,
            ),
            body: Container(
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  for (var i = 0; i < storedocs.length; i++) ...[
                    Card(
                      elevation: 20,
                      shadowColor: Colors.black,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 9,
                                ),
                                Text(
                                  storedocs[i]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 9,
                                ),
                                Text("Expense : ${storedocs[i]['amount']}/-")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Date of shopping",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(storedocs[i]['date'])
                                    ],
                                  ),
                                ),
                                Container(
                                  child: TextButton(
                                    child: Text("View More"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShowDetails(
                                                  id: storedocs[i]['id'],
                                                  amount: storedocs[i]
                                                      ['amount'],
                                                  date: storedocs[i]['date'],
                                                  title: storedocs[i]['title'],
                                                  payId: storedocs[i]
                                                      ['paymentId'])));
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ]
                ],
              ),
            ),
            // floatingActionButton: FloatingActionButton.extended(
            //   elevation: 3,
            //   label: Text("Start New"),
            //   icon: Icon(Icons.add),
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Details()));
            //   },
            // ),
            bottomNavigationBar: BottomAppBar(
                elevation: 20,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 75,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                    builder: (context) => Details()));
                          },
                          child: Text("Start New Shopping"))
                    ],
                  ),
                )),
          );
        });
    // return Scaffold(
    //   appBar: AppBar(title: Text("Hello User")),
    //   body: Container(
    //     child: Center(child: Text("All the shoppings will be shown here")),
    //   ),
    //   floatingActionButton: FloatingActionButton.extended(
    //     elevation: 3,
    //     label: Text("Start New"),
    //     icon: Icon(Icons.add),
    //     onPressed: () {
    //       Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => Details()));
    //     },
    //   ),
    // );
  }
}
