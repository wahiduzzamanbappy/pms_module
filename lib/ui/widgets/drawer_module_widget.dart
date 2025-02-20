import 'package:flutter/material.dart';
import 'package:pms_module/ui/screens/drawerScreen/storeManagementScreen/opening_stock_screen.dart';
import 'package:pms_module/ui/screens/drawerScreen/storeManagementScreen/stock_reconciliation_screen.dart';
import 'package:pms_module/ui/screens/sign_in_screen.dart';
import 'package:pms_module/ui/screens/sign_up_screen.dart';

class DrawerModule extends StatelessWidget {
  const DrawerModule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Center(
            child: DrawerHeader(
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.blueAccent),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.grey, child: Icon(Icons.person)),
                currentAccountPictureSize: Size.fromRadius(20),
                accountName: const Text('John Doe'),
                accountEmail: const Text('johndoe@gmail.com'),
              ),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.medical_information),
            title: const Text(
              'Dispense',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Medicine Delivery',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pushNamed(context, SignInScreen.name);
                },
              ),
              ListTile(
                title: const Text(
                  'Medicine Delivery List',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pushNamed(context, SignUpScreen.name);
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.store, size: 30),
            title: const Text(
              'Store Management',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Opening Stock',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pushNamed(context, OpeningStockScreen.name);
                },
              ),
              ListTile(
                title: const Text(
                  'Opening Stock Approve',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Stock Reconciliation',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.pushNamed(context, StockReconsiliationScreen.name);
                },
              ),
              ListTile(
                title: const Text(
                  'Stock Reconciliation Approval',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Demand Generate',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Demand Approval',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Stock List',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.file_copy, size: 30),
            title: const Text(
              'Reports',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Daily Medicine Delivery Report',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Opening Stock Report',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Stock Reconciliation Report',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Expired Medicine Report',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.settings, size: 30),
            title: const Text(
              'Pharmacy Setup',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Inventory Item',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Generic Setup',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Fiscal Year',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
