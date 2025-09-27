import 'package:flutter/material.dart';
import '../widgets/drawer_module_widget.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String name = '/dashboard-screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    //final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar:AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
              child: Center(child: Text('Expirable Item'),)
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
