import 'package:flutter/material.dart';
import 'package:smart_kart/pages/homepage.dart';

class PaymentSuccess extends StatefulWidget {
  String id;
  PaymentSuccess({Key? key, required this.id}) : super(key: key);

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Thanks For Shopping With Us",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Your Payment was successfull !! ",
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Text("The Payment ID is : ${widget.id}"),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: const Text(
                  "Click here ",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomePage()));
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      ModalRoute.withName('/login'));
                  // Navigator.popUntil(context, MaterialPageRoute(builder: (context)=> HomePage()));
                },
              ),
              const Text(" to go towards Dashboard")
            ],
          ),
        ],
      )),
    );
  }
}
