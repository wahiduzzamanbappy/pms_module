/*
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
*/
import 'package:flutter/material.dart';
import '../widgets/drawer_module_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static const String name = '/dashboard-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, color: Colors.black87),
            label: const Text("Download Report",
                style: TextStyle(color: Colors.black87)),
          )
        ],
      ),
      drawer: DrawerModule(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("A quick data overview of the inventory.",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 16),

            // Top 4 status cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final items = [
                  InfoCard(
                    title: "Inventory Status",
                    value: "Good",
                    color: Colors.green,
                    icon: Icons.verified,
                    actionText: "View Detailed Report",
                    onTap: () {
                      print("Inventory report clicked");
                    },
                  ),
                  InfoCard(
                    title: "Revenue (October 2025)",
                    value: "Rs. 8,55,875",
                    color: Colors.amber,
                    icon: Icons.attach_money,
                    actionText: "View Detailed Report",
                    onTap: () {
                      print("Revenue report clicked");
                    },
                  ),
                  InfoCard(
                    title: "Medicines Available",
                    value: "298",
                    color: Colors.blue,
                    icon: Icons.local_hospital,
                    actionText: "Visit Inventory",
                    onTap: () {
                      print("Go to inventory");
                    },
                  ),
                  InfoCard(
                    title: "Medicine Shortage",
                    value: "01",
                    color: Colors.red,
                    icon: Icons.warning,
                    actionText: "Resolve Now",
                    onTap: () {
                      print("Resolve shortage");
                    },
                  ),
                ];
                return items[index];
              },
            ),

            const SizedBox(height: 24),

            // Inventory, Quick Report
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                      title: "Total no of Medicines",
                      value: "298",
                      subtitle: "24 Medicine Groups"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                      title: "Qty of Medicines Sold",
                      value: "70,856",
                      subtitle: "5,288 Invoices Generated"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // My Pharmacy, Customers
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                      title: "Total no of Suppliers",
                      value: "04",
                      subtitle: "05 Total Users"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                      title: "Total no of Customers",
                      value: "845",
                      subtitle: "Adalimumab frequently bought"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey, height: 1.2)),
                      Text(value,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: color)),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),

            // যদি actionText দেওয়া থাকে তবে বাটন দেখাবে
            if (actionText != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onTap,
                  child: Text(
                    actionText!,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const StatCard(
      {super.key,
        required this.title,
        required this.value,
        required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 4),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}