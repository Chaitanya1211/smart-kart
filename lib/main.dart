import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_kart/pages/detailsFilling.dart';
import 'package:smart_kart/pages/homepage.dart';
import 'package:smart_kart/pages/login.dart';
import 'package:smart_kart/pages/register.dart';
import 'package:smart_kart/pages/shoppingInstance.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _inititlaization = Firebase.initializeApp();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _inititlaization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Someting went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              routes: {
                // '/screen1': (BuildContext context) => new Screen1(),
                '/login': (BuildContext context) => const Login(),
                '/register': (BuildContext context) => const Register(),
                '/homePage': (BuildContext context) => const HomePage(),
                '/detailsOfShopping': (BuildContext context) => const Details(),
                // '/instance': (BuildContext context) =>  DisplayItems(),
                // '/summary': (BuildContext context) => const Summary(),
                // '/login': (BuildContext context) => const Login(),
              },
              title: 'Flutter Demo',
              theme: ThemeData(
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: const Login(),
              debugShowCheckedModeBanner: false,
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
