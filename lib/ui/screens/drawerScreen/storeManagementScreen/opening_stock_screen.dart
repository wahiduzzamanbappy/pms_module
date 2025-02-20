import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class OpeningStockScreen extends StatefulWidget {
  const OpeningStockScreen({super.key});

  static const String name = '/openingStock';

  @override
  State<OpeningStockScreen> createState() => _OpeningStockScreenState();
}

class _OpeningStockScreenState extends State<OpeningStockScreen> {
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
                          controller: _challanNoTEController,
                          decoration: const InputDecoration(
                              hintText: 'Challan No',
                              border: OutlineInputBorder(),
                              labelText: 'Challan No'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                            labelText: "Date",
                          ),
                          onComplete: (date) {},
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
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
                              hintText: 'UoM',
                              border: OutlineInputBorder(),
                              labelText: 'UoM'),
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
                              hintText: 'Batch No',
                              border: OutlineInputBorder(),
                              labelText: 'Batch No'),
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
                              hintText: 'Opening Qty',
                              border: OutlineInputBorder(),
                              labelText: 'Opening Qty'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: () {}, child: Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
