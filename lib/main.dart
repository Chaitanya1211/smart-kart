import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_kart/pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _inititlaization = Firebase.initializeApp();
  // const MyApp({Key? key}) : super(key: key);

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
