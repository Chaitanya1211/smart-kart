import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_kart/pages/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _contactNo = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
                hintText: "Name", prefixIcon: const Icon(Icons.face)),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _contactNo,
            decoration: const InputDecoration(
                hintText: "Contact Number",
                prefixIcon: const Icon(Icons.contact_phone)),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _email,
            decoration: const InputDecoration(
                hintText: "Email", prefixIcon: const Icon(Icons.email)),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "Password", prefixIcon: const Icon(Icons.password)),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _email.text.trim(),
                        password: _password.text.trim())
                    .then((value) {
                  // print(value.user!.uid);
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(value.user!.uid)
                      .set({
                    "uid": value.user!.uid,
                    "name": _name.text,
                    "email": _email.text,
                    "contactNo": _contactNo.text
                  });

                  Fluttertoast.showToast(
                      msg: "Registration Successfull !!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.black,
                      fontSize: 16.0);

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => const Login()));
                  Navigator.pop(context);
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(
                      msg: "Registration Unsuccessfull \n Try again",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.black,
                      fontSize: 16.0);
                });
              },
              child: Text("Register"))
        ],
      ),
    ));
  }
}
