import 'package:flutter/material.dart';
import 'package:pms_module/ui/screens/drawerScreen/dispense/screens/manual_dispense_screen.dart';
import 'package:pms_module/ui/screens/drawerScreen/storeManagementScreen/opening_stock_screen.dart';
import 'package:pms_module/ui/screens/drawerScreen/storeManagementScreen/stock_reconciliation_screen.dart';
import '../screens/drawerScreen/dispense/screens/medicine_delivery_list_screen.dart';
import '../screens/drawerScreen/dispense/screens/medicine_delivery_screen.dart';

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
            iconColor: Colors.red,
            leading: const Icon(Icons.medical_information),
            title: const Text(
              'Dispense',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: <Widget>[
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Medicine Delivery',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pushNamed(context, MedicineDeliveryScreen.name);
                },
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Manual Dispense',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ManualDispenseScreen.name);
                },
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Medicine Delivery List',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pushNamed(context, MedicineDeliveryListScreen.name);
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.store, size: 30),
            iconColor: Colors.red,
            title: const Text(
              'Store Management',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: <Widget>[
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Opening Stock',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pushNamed(context, OpeningStockScreen.name);
                },
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Opening Stock Approve',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Stock Reconciliation',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pushNamed(context, StockReconsiliationScreen.name);
                },
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Stock Reconciliation Approval',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Demand Generate',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Demand Approval',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Stock List',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.file_copy, size: 30),
            iconColor: Colors.red,
            title: const Text(
              'Reports',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: <Widget>[
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Daily Medicine Delivery Report',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Opening Stock Report',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Stock Reconciliation Report',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Expired Medicine Report',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.settings, size: 30),
            iconColor: Colors.red,
            title: const Text(
              'Pharmacy Setup',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: <Widget>[
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Inventory Item',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Generic Setup',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {},
              ),
              ListTile(
                focusColor: Colors.blueGrey,
                title: const Text(
                  'Fiscal Year',
                  style: TextStyle(fontSize: 14),
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
