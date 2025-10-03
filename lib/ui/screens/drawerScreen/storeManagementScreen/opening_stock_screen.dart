import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class OpeningStockScreen extends StatefulWidget {
  const OpeningStockScreen({super.key});

  static const String name = '/openingStock';

  @override
  State<OpeningStockScreen> createState() => _OpeningStockScreenState();
}

class _OpeningStockScreenState extends State<OpeningStockScreen> {
  final TextEditingController _challanNoController = TextEditingController();
  DateTime? _challanDate;

  final List<Map<String, String>> _medicineList = [];

  @override
  void initState() {
    super.initState();
    _challanDate = DateTime.now(); // Auto-set to today
  }

/*   // ===== Pick Challan Date =====
  Future<void> _pickChallanDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _challanDate ?? now,
      firstDate: now, // <-- today or future
      lastDate: DateTime(2100), // optional future limit
    );
    if (picked != null) {
      setState(() {
        _challanDate = picked;
      });
    }
  }

// ===== Pick Expiry Date (past or today allowed) =====
  Future<void> _pickExpiryDate(TextEditingController controller) async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.parse(controller.text)
          : DateTime.now(),
      firstDate: now, // <-- today or future
      lastDate: DateTime(2100), // past or today only
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T')[0];
    }
  }*/

  // ===== Add/Edit Medicine Dialog =====
  void _showMedicineDialog({Map<String, String>? medicine, int? index}) {
    final TextEditingController name =
        TextEditingController(text: medicine?['name']);
    final TextEditingController code =
        TextEditingController(text: medicine?['code']);
    final TextEditingController type =
        TextEditingController(text: medicine?['type']);
    final TextEditingController generic =
        TextEditingController(text: medicine?['generic']);
    final TextEditingController batch =
        TextEditingController(text: medicine?['batch']);
    final TextEditingController expiry =
        TextEditingController(text: medicine?['expiry']);
    final TextEditingController qty =
        TextEditingController(text: medicine?['qty']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(medicine == null ? "Add Medicine" : "Edit Medicine"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: "Name")),
              TextField(
                  controller: code,
                  decoration: const InputDecoration(labelText: "Code")),
              TextField(
                  controller: type,
                  decoration: const InputDecoration(labelText: "Type")),
              TextField(
                  controller: generic,
                  decoration: const InputDecoration(labelText: "Generic")),
              TextField(
                  controller: batch,
                  decoration: const InputDecoration(labelText: "Batch")),
              TextField(
                controller: expiry,
                decoration: const InputDecoration(labelText: "Expiry Date"),
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: medicine != null &&
                            medicine['expiry']!.isNotEmpty
                        ? DateFormat('dd-MM-yyyy').parse(medicine['expiry']!)
                        : DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    expiry.text = DateFormat('dd-MM-yyyy').format(picked);
                  }
                },
              ),
              TextField(
                controller: qty,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
          ElevatedButton(
            onPressed: () {
              if (name.text.isEmpty || code.text.isEmpty || qty.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Name, Code, and Quantity are required")),
                );
                return;
              }

              final newMedicine = {
                'name': name.text,
                'code': code.text,
                'type': type.text,
                'generic': generic.text,
                'batch': batch.text,
                'expiry': expiry.text,
                'qty': qty.text,
              };

              setState(() {
                if (index == null) {
                  _medicineList.add(newMedicine);
                } else {
                  _medicineList[index] = newMedicine;
                }
              });
              Navigator.pop(context);
            },
            child: Text(medicine == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  // ===== Delete Medicine =====
  void _deleteMedicine(int index) {
    setState(() {
      _medicineList.removeAt(index);
    });
  }

  // ===== Save Opening Stock =====
  void _saveOpeningStock() {
    if (_challanNoController.text.isEmpty || _challanDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Challan No and Date are required")),
      );
      return;
    }
    if (_medicineList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one medicine")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening stock saved successfully!")),
    );

    _challanNoController.clear();
    _challanDate = null;
    _medicineList.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _challanNoController,
                      decoration: const InputDecoration(
                        labelText: "Challan No",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  /*  Expanded(
                    child: InkWell(
                      onTap: () async {
                        DateTime now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _challanDate ?? now,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _challanDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Challan Date",
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_challanDate != null
                            ? DateFormat('dd-MM-yyyy').format(_challanDate!)
                            : "Select Date"),
                      ),
                    ),
                  ),*/
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Challan Date",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        "${_challanDate!.day.toString().padLeft(2, '0')}-"
                        "${_challanDate!.month.toString().padLeft(2, '0')}-"
                        "${_challanDate!.year}",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _showMedicineDialog(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Opening"),
              ),
              const SizedBox(height: 20),
              _medicineList.isEmpty
                  ? const Text("No medicine added yet")
                  : SizedBox(
                      height: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor:
                                MaterialStateProperty.all(Colors.blue),
                            headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            border:
                                TableBorder.all(color: Colors.blue.shade200),
                            columns: const [
                              DataColumn(label: Text("SL")),
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("Code")),
                              DataColumn(label: Text("Type")),
                              DataColumn(label: Text("Generic")),
                              DataColumn(label: Text("Batch")),
                              DataColumn(label: Text("Expiry")),
                              DataColumn(label: Text("Qty")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: List.generate(_medicineList.length, (index) {
                              final medicine = _medicineList[index];
                              return DataRow(
                                onSelectChanged: (_) => _showMedicineDialog(
                                    medicine: medicine, index: index),
                                cells: [
                                  DataCell(Text("${index + 1}")),
                                  DataCell(Text(medicine['name']!)),
                                  DataCell(Text(medicine['code']!)),
                                  DataCell(Text(medicine['type']!)),
                                  DataCell(Text(medicine['generic']!)),
                                  DataCell(Text(medicine['batch']!)),
                                  DataCell(Text(medicine['expiry']!)),
                                  DataCell(Text(medicine['qty']!)),
                                  DataCell(IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteMedicine(index),
                                  )),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _saveOpeningStock,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      _challanNoController.clear();
                      _challanDate = null;
                      _medicineList.clear();
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
            ],
          ),
        ),
      ),
    );
  }
}
