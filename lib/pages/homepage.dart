import 'package:flutter/material.dart';
import 'package:smart_kart/pages/detailsOfShopping.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello User")),
      body: Container(
        child: Center(child: Text("All the shoppings will be shown here")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 3,
        label: Text("Start New"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Details()));
        },
      ),
    );
  }
}
