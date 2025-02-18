import 'package:flutter/material.dart';

import '../widgets/drawer_module_widget.dart';
import '../widgets/pms_app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static const String name = '/';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme,
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
