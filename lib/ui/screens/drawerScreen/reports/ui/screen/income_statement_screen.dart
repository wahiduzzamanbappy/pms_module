/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as excel;
import 'dart:typed_data';
import 'package:flutter_html/flutter_html.dart';

class IncomeStatementScreen extends StatefulWidget {
  const IncomeStatementScreen({super.key});
  static String name = 'income-statement';

  @override
  State<IncomeStatementScreen> createState() => _IncomeStatementScreenState();
}

class _IncomeStatementScreenState extends State<IncomeStatementScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  String? _selectedStore;
  String? _selectedUser;
  String? _invoiceHtml;

  // Sample Store & User data
  final List<String> _stores = ["Store 1", "Store 2", "Store 3"];
  final List<String> _users = ["User 1", "User 2", "User 3"];

  // Sample Invoice Data
  final List<Map<String, String>> _invoiceData = [
    {"date": "05-10-2025", "item": "Item 1", "amount": "100"},
    {"date": "05-10-2025", "item": "Item 2", "amount": "150"},
    {"date": "06-10-2025", "item": "Item 3", "amount": "200"},
  ];

  /// ✅ Generates HTML invoice for preview
  String _generateInvoiceHtml() {
    return """
    <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          table { width: 100%; border-collapse: collapse; margin-top: 20px; }
          th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }
          th { background-color: #f2f2f2; }
          h2 { text-align: center; }
        </style>
      </head>
      <body>
        <h2>Income Statement</h2>
        <p><strong>Store:</strong> ${_selectedStore ?? '-'} </p>
        <p><strong>User:</strong> ${_selectedUser ?? '-'} </p>
        <p><strong>From:</strong> ${_fromDateController.text.isEmpty ? '-' : _fromDateController.text}
           <strong>To:</strong> ${_toDateController.text.isEmpty ? '-' : _toDateController.text}</p>
        <table>
          <tr>
            <th>Date</th>
            <th>Item</th>
            <th>Amount</th>
          </tr>
          ${_invoiceData.map((item) {
      return "<tr><td>${item['date']}</td><td>${item['item']}</td><td>${item['amount']}</td></tr>";
    }).join()}
        </table>
      </body>
    </html>
    """;
  }

  /// ✅ Generates Excel file from invoice data
  Future<void> _generateExcel() async {
    final excelFile = excel.Excel.createExcel();
    final excel.Sheet sheet = excelFile['Income Statement'];

    // Header Row
    sheet.appendRow([
      excel.TextCellValue('Date'),
      excel.TextCellValue('Item'),
      excel.TextCellValue('Amount'),
    ]);

    // Data Rows
    for (final item in _invoiceData) {
      sheet.appendRow([
        excel.TextCellValue(item['date'] ?? ''),
        excel.TextCellValue(item['item'] ?? ''),
        excel.TextCellValue(item['amount'] ?? ''),
      ]);
    }

    // Save Excel File
    final fileBytes = await excelFile.save();
    if (fileBytes != null) {
      final uint8list = Uint8List.fromList(fileBytes);
      await _saveFile(uint8list, 'IncomeStatement.xlsx');
    }
  }

  /// ✅ Simulated file save (replace with path_provider or file_saver)
  Future<void> _saveFile(Uint8List fileBytes, String fileName) async {
    debugPrint('✅ File "$fileName" generated successfully (${fileBytes.lengthInBytes} bytes)');
  }

  /// ✅ Date Picker
  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income Statement"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // From Date
            TextField(
              controller: _fromDateController,
              decoration: const InputDecoration(
                labelText: "From Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(_fromDateController),
            ),
            const SizedBox(height: 12),

            // To Date
            TextField(
              controller: _toDateController,
              decoration: const InputDecoration(
                labelText: "To Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(_toDateController),
            ),
            const SizedBox(height: 12),

            // Store Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStore,
              decoration: const InputDecoration(
                labelText: "Select Store",
                border: OutlineInputBorder(),
              ),
              items: _stores.map((store) {
                return DropdownMenuItem(value: store, child: Text(store));
              }).toList(),
              onChanged: (value) => setState(() => _selectedStore = value),
            ),
            const SizedBox(height: 12),

            // User Dropdown
            DropdownButtonFormField<String>(
              value: _selectedUser,
              decoration: const InputDecoration(
                labelText: "Select User",
                border: OutlineInputBorder(),
              ),
              items: _users.map((user) {
                return DropdownMenuItem(value: user, child: Text(user));
              }).toList(),
              onChanged: (value) => setState(() => _selectedUser = value),
            ),
            const SizedBox(height: 20),

            // Generate Invoice Button
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text("Generate Invoice"),
              onPressed: () {
                setState(() {
                  _invoiceHtml = _generateInvoiceHtml();
                });
              },
            ),
            const SizedBox(height: 16),

            // HTML Preview
            if (_invoiceHtml != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Html(data: _invoiceHtml!),
              ),
            const SizedBox(height: 20),

            // Download Excel Button
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Download as Excel"),
              onPressed: _generateExcel,
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as excel;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:printing/printing.dart'; // for print dialog support
import 'package:flutter/services.dart' show rootBundle;

class IncomeStatementScreen extends StatefulWidget {
  const IncomeStatementScreen({super.key});
  static String name = 'income-statement';

  @override
  State<IncomeStatementScreen> createState() => _IncomeStatementScreenState();
}

class _IncomeStatementScreenState extends State<IncomeStatementScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  String? _selectedStore;
  String? _selectedUser;
  String? _invoiceHtml;
  String? _invoiceFilePath;

  final List<String> _stores = ["Store 1", "Store 2", "Store 3"];
  final List<String> _users = ["User 1", "User 2", "User 3"];

  final List<Map<String, String>> _invoiceData = [
    {"date": "05-10-2025", "item": "Item 1", "amount": "100"},
    {"date": "05-10-2025", "item": "Item 2", "amount": "150"},
    {"date": "06-10-2025", "item": "Item 3", "amount": "200"},
  ];

  /// ✅ Generates Invoice HTML
  String _generateInvoiceHtml() {
    return """
    <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          table { width: 100%; border-collapse: collapse; margin-top: 20px; }
          th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }
          th { background-color: #f2f2f2; }
          h2 { text-align: center; }
          .buttons { margin-top: 20px; text-align: center; }
          button { padding: 10px 16px; margin: 5px; border: none; cursor: pointer; border-radius: 4px; }
          .print-btn { background-color: #0066b2; color: white; }
          .excel-btn { background-color: #00c9a7; color: white; }
        </style>
        <script>
          function printInvoice() {
            window.print();
          }
        </script>
      </head>
      <body>
        <h2>Income Statement</h2>
        <p><strong>Store:</strong> ${_selectedStore ?? '-'} </p>
        <p><strong>User:</strong> ${_selectedUser ?? '-'} </p>
        <p><strong>From:</strong> ${_fromDateController.text.isEmpty ? '-' : _fromDateController.text}
           <strong>To:</strong> ${_toDateController.text.isEmpty ? '-' : _toDateController.text}</p>

        <table>
          <tr><th>Date</th><th>Item</th><th>Amount</th></tr>
          ${_invoiceData.map((item) {
      return "<tr><td>${item['date']}</td><td>${item['item']}</td><td>${item['amount']}</td></tr>";
    }).join()}
        </table>

        <div class="buttons">
          <button class="print-btn" onclick="printInvoice()">🖨️ Print Invoice</button>
        </div>
      </body>
    </html>
    """;
  }

  /// ✅ Generate Excel
  Future<void> _generateExcel() async {
    final excelFile = excel.Excel.createExcel();
    final excel.Sheet sheet = excelFile['Income Statement'];

    sheet.appendRow([
      excel.TextCellValue('Date'),
      excel.TextCellValue('Item'),
      excel.TextCellValue('Amount'),
    ]);

    for (final item in _invoiceData) {
      sheet.appendRow([
        excel.TextCellValue(item['date'] ?? ''),
        excel.TextCellValue(item['item'] ?? ''),
        excel.TextCellValue(item['amount'] ?? ''),
      ]);
    }

    final fileBytes = await excelFile.save();
    if (fileBytes != null) {
      final uint8list = Uint8List.fromList(fileBytes);
      await _saveFile(uint8list, 'IncomeStatement.xlsx');
    }
  }

  /// ✅ Save File to device temporary directory
  Future<void> _saveFile(Uint8List fileBytes, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(fileBytes);
    debugPrint('✅ File saved at: ${file.path}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ File saved: ${file.path}')),
    );
  }

  /// ✅ Generate Invoice + Save as HTML file
  Future<void> _generateInvoice() async {
    final htmlContent = _generateInvoiceHtml();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/IncomeStatement.html');
    await file.writeAsString(htmlContent);

    setState(() {
      _invoiceHtml = htmlContent;
      _invoiceFilePath = file.path;
    });
  }

  /// ✅ Date Picker
  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income Statement"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Pickers
            TextField(
              controller: _fromDateController,
              decoration: const InputDecoration(
                labelText: "From Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(_fromDateController),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _toDateController,
              decoration: const InputDecoration(
                labelText: "To Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(_toDateController),
            ),
            const SizedBox(height: 12),

            // Dropdowns
            DropdownButtonFormField<String>(
              value: _selectedStore,
              decoration: const InputDecoration(
                labelText: "Select Store",
                border: OutlineInputBorder(),
              ),
              items: _stores.map((store) {
                return DropdownMenuItem(value: store, child: Text(store));
              }).toList(),
              onChanged: (value) => setState(() => _selectedStore = value),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _selectedUser,
              decoration: const InputDecoration(
                labelText: "Select User",
                border: OutlineInputBorder(),
              ),
              items: _users.map((user) {
                return DropdownMenuItem(value: user, child: Text(user));
              }).toList(),
              onChanged: (value) => setState(() => _selectedUser = value),
            ),
            const SizedBox(height: 20),

            // Generate Invoice Button
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text("Generate Invoice"),
              onPressed: _generateInvoice,
            ),
            const SizedBox(height: 16),

            // Invoice Preview with Buttons
            if (_invoiceHtml != null)
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Html(data: _invoiceHtml!),
                  ),
                  const SizedBox(height: 12),

                  // Print and Download Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text("Print Invoice"),
                        onPressed: () async {
                          if (_invoiceFilePath != null) {
                            await Printing.layoutPdf(
                              onLayout: (format) async =>
                              await Printing.convertHtml(
                                  html: _invoiceHtml ?? ''),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text("Download Excel"),
                        onPressed: _generateExcel,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
