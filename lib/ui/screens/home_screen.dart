import 'package:flutter/material.dart';

import '../widgets/drawer_module_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static const String name = '/';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_outline_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: DrawerModule(),
      body: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [
                Card(
          child: Container(
            height: 50,
            width: 100,
            color: Colors.grey,
              child: Center(child: Text("Today's Delivery"),)
          ),), Card(
                    child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.grey,
                        child: Center(child: Text('Stock'),)
                    ),
                  ),
       Card(
          child: Container(
            height: 50,
            width: 100,
            color: Colors.grey,
              child: Center(child: Text('Expired Item'),)
          ),
        ),Card(
          child: Container(
            height: 50,
            width: 100,
            color: Colors.grey,
              child: Center(child: Text('Expired Item'),)
          ),
        ),
      ],),
    );
  }
}
