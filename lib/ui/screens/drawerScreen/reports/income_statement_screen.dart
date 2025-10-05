import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_html/flutter_html.dart'; // For HTML Rendering

class IncomeStatementScreen extends StatefulWidget {
  const IncomeStatementScreen({super.key});

  @override
  _IncomeStatementScreenState createState() => _IncomeStatementScreenState();
}

class _IncomeStatementScreenState extends State<IncomeStatementScreen> {
  final TextEditingController _fromDateTEController = TextEditingController();
  final TextEditingController _toDateTEController = TextEditingController();
  String? _selectedStore;
  String? _selectedUser;
  String? _invoiceHtml;

  // Sample Store and User Data
  List<String> stores = ["Store 1", "Store 2", "Store 3"];
  List<String> users = ["User 1", "User 2", "User 3"];

  // Sample data for the invoice (In a real scenario, this would be dynamic)
  List<Map<String, String>> invoiceData = [
    {"date": "05-10-2025", "item": "Item 1", "amount": "100"},
    {"date": "05-10-2025", "item": "Item 2", "amount": "150"},
    {"date": "06-10-2025", "item": "Item 3", "amount": "200"},
  ];

  // Generate the invoice in HTML format for printing
  String generateInvoiceHtml() {
    String htmlContent = """
    <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; }
          table { width: 100%; border-collapse: collapse; }
          th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }
        </style>
      </head>
      <body>
        <h2>Income Statement</h2>
        <p><strong>Store:</strong> $_selectedStore</p>
        <p><strong>User:</strong> $_selectedUser</p>
        <p><strong>From:</strong> ${_fromDateTEController.text} <strong>To:</strong> ${_toDateTEController.text}</p>
        <table>
          <tr>
            <th>Date</th>
            <th>Item</th>
            <th>Amount</th>
          </tr>
          ${invoiceData.map((item) {
      return "<tr><td>${item['date']}</td><td>${item['item']}</td><td>${item['amount']}</td></tr>";
    }).join()}
        </table>
      </body>
    </html>
    """;
    return htmlContent;
  }

  // Generate the invoice in Excel format
  Future<void> generateExcel() async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];
    sheet.appendRow(['Date', 'Item', 'Amount']);

    invoiceData.forEach((item) {
      sheet.appendRow([item['date'], item['item'], item['amount']]);
    });

    // Convert to bytes and save the Excel file
    var fileBytes = await excel.save();
    final result = await _saveFile(fileBytes!, 'IncomeStatement.xlsx');
  }

  // Save the generated Excel file
  Future<void> _saveFile(Uint8List fileBytes, String fileName) async {
    final buffer = fileBytes.buffer.asUint8List();
    // Implement file saving here (e.g., using path_provider, share, or any other method)
    // For now, you can print the success message or implement your desired method for saving
    print('File saved as $fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Income Statement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // From Date Picker
            TextField(
              controller: _fromDateTEController,
              decoration: InputDecoration(labelText: "From Date"),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _fromDateTEController.text = DateFormat('dd-MM-yyyy').format(picked);
                  });
                }
              },
            ),
            SizedBox(height: 8),
            // To Date Picker
            TextField(
              controller: _toDateTEController,
              decoration: InputDecoration(labelText: "To Date"),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _toDateTEController.text = DateFormat('dd-MM-yyyy').format(picked);
                  });
                }
              },
            ),
            SizedBox(height: 8),
            // Store Dropdown
            DropdownButton<String>(
              value: _selectedStore,
              hint: Text("Select Store"),
              onChanged: (value) {
                setState(() {
                  _selectedStore = value;
                });
              },
              items: stores.map((store) {
                return DropdownMenuItem(value: store, child: Text(store));
              }).toList(),
            ),
            SizedBox(height: 8),
            // User Dropdown
            DropdownButton<String>(
              value: _selectedUser,
              hint: Text("Select User"),
              onChanged: (value) {
                setState(() {
                  _selectedUser = value;
                });
              },
              items: users.map((user) {
                return DropdownMenuItem(value: user, child: Text(user));
              }).toList(),
            ),
            SizedBox(height: 16),
            // Generate Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _invoiceHtml = generateInvoiceHtml(); // Generate HTML invoice
                });
              },
              child: Text("Generate Invoice"),
            ),
            SizedBox(height: 16),
            // Render HTML Invoice (for printing)
            if (_invoiceHtml != null)
              Html(
                data: _invoiceHtml,
              ),
            SizedBox(height: 16),
            // Download Excel Button
            ElevatedButton(
              onPressed: () {
                generateExcel(); // Generate Excel Invoice
              },
              child: Text("Download as Excel"),
            ),
          ],
        ),
      ),
    );
  }
}
