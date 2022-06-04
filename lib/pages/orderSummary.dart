import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smart_kart/pages/paymentSuccess.dart';

class OrderSummary extends StatefulWidget {
  String documentId;
  String total;
  OrderSummary({Key? key, required this.documentId, required this.total})
      : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  late Razorpay _razorpay;
  int total = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_P8aWBN2Kj6tDS4',
      'amount': num.parse(widget.total) * 100,
      'name': "SMART KART",
      'description': 'Payment of ${widget.total}/-',
      'prefill': {'contact': '1234567890', 'email': 'abc@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String payId = response.paymentId!;
    // Fluttertoast.showToast(
    //     msg: "Payment Success" + response.paymentId!,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.green,
    //     textColor: Colors.black,
    //     fontSize: 16.0);
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection('shoppings')
        .doc(widget.documentId)
        .set(
            {'paymentId': payId.toString(), 'amount': widget.total.toString()});

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PaymentSuccess(id: payId)));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Failed \n" + response.code.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget build(BuildContext context) {
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
            body: Container(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Order Summary",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
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
                    )
                  ],
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(children: [
                      SizedBox(
                        width: 233,
                      ),
                      Container(
                        child: Text(
                          "Total : ₹ ${widget.total} /-",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            )),
            bottomNavigationBar: BottomAppBar(
              elevation: 50,
              color: Colors.blue,
              child: Container(
                height: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 21, 20, 15),
                        child: Column(
                          children: [
                            Text('Total Items : ${storedocs.length}'),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Total Cost  : ${widget.total}/-")
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 50,
                            // backgroundColor : Colors.blue,
                            primary: Color.fromARGB(255, 3, 112, 255)),
                        onPressed: () {
                          openCheckout();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.payment),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Continue to Pay")
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
    // return Scaffold();
  }
}
