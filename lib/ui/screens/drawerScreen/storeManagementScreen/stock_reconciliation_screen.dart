/*
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class StockReconsiliationScreen extends StatefulWidget {
  const StockReconsiliationScreen({super.key});

  static const String name = '/stockReconsiliation';

  @override
  State<StockReconsiliationScreen> createState() => _StockReconsiliationScreenState();
}

class _StockReconsiliationScreenState extends State<StockReconsiliationScreen> {
  final TextEditingController _challanNoTEController = TextEditingController();
  final TextEditingController _itemNameTEController = TextEditingController();
  final TextEditingController _itemCodeTEController = TextEditingController();
  final TextEditingController _genericTEController = TextEditingController();
  final TextEditingController _categoryTEController = TextEditingController();
  final TextEditingController _uoMTEController = TextEditingController();
  final TextEditingController _batchNoTEController = TextEditingController();
  final TextEditingController _openingQtyTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _itemNameTEController,
                          decoration: const InputDecoration(
                              hintText: 'Item Name',
                              border: OutlineInputBorder(),
                              labelText: 'Item Name'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _itemCodeTEController,
                          decoration: const InputDecoration(
                              hintText: 'Item Code',
                              border: OutlineInputBorder(),
                              labelText: 'Item Code'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _genericTEController,
                          decoration: const InputDecoration(
                              hintText: 'Generic',
                              border: OutlineInputBorder(),
                              labelText: 'Generic'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _categoryTEController,
                          decoration: const InputDecoration(
                              hintText: 'Category',
                              border: OutlineInputBorder(),
                              labelText: 'Category'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _uoMTEController,
                          decoration: const InputDecoration(
                              hintText: 'Recon. Type',
                              border: OutlineInputBorder(),
                              labelText: 'Recon. Type'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _batchNoTEController,
                          decoration: const InputDecoration(
                              hintText: 'Recon. Qty',
                              border: OutlineInputBorder(),
                              labelText: 'Recon Qty'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: DateFormatField(
                          type: DateFormatType.type4,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Expired Date",
                          ),
                          onComplete: (date) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _openingQtyTEController,
                          decoration: const InputDecoration(
                              hintText: 'Reason',
                              border: OutlineInputBorder(),
                              labelText: 'Reason'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () {}, child: Text('Save'),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class StockReconsiliationScreen extends StatefulWidget {
  const StockReconsiliationScreen({super.key});

  static const String name = '/stockReconsiliation';

  @override
  State<StockReconsiliationScreen> createState() =>
      _StockReconsiliationScreenState();
}

class _StockReconsiliationScreenState extends State<StockReconsiliationScreen> {
  final TextEditingController _challanNoTEController = TextEditingController();
  final TextEditingController _itemNameTEController = TextEditingController();
  final TextEditingController _itemCodeTEController = TextEditingController();
  final TextEditingController _genericTEController = TextEditingController();
  final TextEditingController _categoryTEController = TextEditingController();
  final TextEditingController _uoMTEController = TextEditingController();
  final TextEditingController _batchNoTEController = TextEditingController();
  final TextEditingController _openingQtyTEController = TextEditingController();
  final TextEditingController _reconQtyController = TextEditingController();
  String? _reconType = 'On'; // Default value
  String? _selectedMedicine;
  Map<String, double> medicines = {
    "Aspirin": 100.0,
    "Paracetamol": 50.0,
    "Amoxicillin": 200.0,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                // Item Information Row
                Row(
                  children: [
                    _buildExpandedDropdown(
                      label: 'Medicine',
                      value: _selectedMedicine,
                      onChanged: (value) {
                        setState(() {
                          _selectedMedicine = value;
                        });
                      },
                      items: medicines.keys.toList(),
                    ),
                    const SizedBox(width: 10),
                    _buildExpandedTextField(
                      controller: _itemCodeTEController,
                      label: 'Item Code',
                      hint: 'Item Code',
                    ),
                    const SizedBox(width: 10),
                    _buildExpandedTextField(
                      controller: _genericTEController,
                      label: 'Generic',
                      hint: 'Generic',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Category and UoM Row
                Row(
                  children: [
                    _buildExpandedTextField(
                      controller: _categoryTEController,
                      label: 'Category',
                      hint: 'Category',
                    ),
                    const SizedBox(width: 10),
                    _buildExpandedDropdown(
                      label: 'Recon. Type',
                      value: _reconType,
                      onChanged: (value) {
                        setState(() {
                          _reconType = value;
                        });
                      },
                      items: ['On', 'Off'],
                    ),
                    const SizedBox(width: 10),
                    _buildExpandedTextField(
                      controller: _reconQtyController,
                      label: 'Recon Qty',
                      hint: 'Recon Qty',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Expiry Date and Reason Row
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: DateFormatField(
                          type: DateFormatType.type4,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Expired Date",
                          ),
                          onComplete: (date) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildExpandedTextField(
                      controller: _openingQtyTEController,
                      label: 'Reason',
                      hint: 'Reason',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    _updateStock();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a text field with expanded width
  Widget _buildExpandedTextField(
      {required TextEditingController controller,
        required String label,
        required String hint,
        TextInputType keyboardType = TextInputType.text}) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ),
    );
  }

  // Helper method to build a dropdown with expanded width
  Widget _buildExpandedDropdown(
      {required String label,
        required String? value,
        required Function(String?) onChanged,
        required List<String> items}) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: onChanged,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
        ),
      ),
    );
  }

  // Method to update stock based on recon type
  void _updateStock() {
    if (_selectedMedicine != null) {
      double reconQty = double.tryParse(_reconQtyController.text) ?? 0.0;
      double currentStock = medicines[_selectedMedicine!] ?? 0.0;

      if (_reconType == 'On') {
        medicines[_selectedMedicine!] = currentStock + reconQty;
      } else if (_reconType == 'Off') {
        medicines[_selectedMedicine!] = currentStock - reconQty;
      }

      // Show updated stock
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Stock for $_selectedMedicine updated to ${medicines[_selectedMedicine!]}'),
        ),
      );

      // Clear input fields after saving
      _reconQtyController.clear();
    }
  }
}

