import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class OpeningStockApprovalScreen extends StatefulWidget {
  const OpeningStockApprovalScreen({super.key});

  static String name = 'opening-stock-approve';

  @override
  _OpeningStockApprovalScreenState createState() =>
      _OpeningStockApprovalScreenState();
}

class _OpeningStockApprovalScreenState
    extends State<OpeningStockApprovalScreen> {
  final TextEditingController _storeTEController = TextEditingController();
  final TextEditingController _fromDateTEController = TextEditingController();
  final TextEditingController _toDateTEController = TextEditingController();

  DateTime? _fromDate;
  DateTime? _toDate;

  List<Map<String, dynamic>> stockData = [];

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate, // Set initial date to today's date
      firstDate: DateTime(1900), // Minimum selectable date
      lastDate: DateTime.now(), // Maximum selectable date
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      setState(() {
        controller.text = formattedDate; // Set selected date to the TextField
      });
    }
  }


    @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme; // Correct usage of TextTheme

    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme), // Check PMSAppBar widget
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Row (Store, Date)
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text("Select Store"),
                    items: ["Store 1", "Store 2"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child:  TextField(
                    controller: _fromDateTEController,
                    decoration: const InputDecoration(labelText: "From Date"),
                    readOnly: true,
                    onTap: () => _selectDate(_fromDateTEController), // Show date picker
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _toDateTEController,
                    decoration: const InputDecoration(labelText: "To Date"),
                    readOnly: true,
                    onTap: () => _selectDate(_toDateTEController), // Show date picker
                  ),
                ),
                SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text("Search"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                ),
                SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _storeTEController.clear();
                    _fromDate = null;
                    _toDate= null;
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Data Table
            Expanded(
              child: ListView.builder(
                itemCount: stockData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Text(stockData[index]["sl"].toString()),
                      title: Text(stockData[index]["store"]),
                      subtitle: Text("Date: ${stockData[index]["date"]}"),
                      trailing: stockData[index]["action"] == null
                          ? ElevatedButton(
                        onPressed: () => (' '),
                        child: Text("Approve"),
                      )
                          : Text(stockData[index]["action"]!),
                    ),
                  );
                },
              ),
            ),

           /* // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: currentPage > 1
                      ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                      : null,
                ),
                Text("Page $currentPage"),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: currentPage < 3
                      ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
