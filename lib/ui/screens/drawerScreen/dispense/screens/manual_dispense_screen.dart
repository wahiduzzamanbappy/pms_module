import 'package:flutter/material.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class ManualDispenseScreen extends StatefulWidget {
  const ManualDispenseScreen({super.key});

  static const String name = '/manual-dispense-screen';

  @override
  _ManualDispenseScreenState createState() => _ManualDispenseScreenState();
}

class _ManualDispenseScreenState extends State<ManualDispenseScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedPrescription;
  String? selectedPatient;
  String? selectedStore;
  String? selectedPayment;
  String? selectedMobileBank;

  final TextEditingController _referenceTEController = TextEditingController();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _ageTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final screenWidth = mediaQuery.size.width;

    int dropdownColumns = 1;
    if (screenWidth >= 1200) {
      dropdownColumns = 3;
    } else if (screenWidth >= 800 || !isPortrait) {
      dropdownColumns = 2;
    }

    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: dropdownColumns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isPortrait ? 1: 1,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TextFormField(
                    controller: _nameTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Name!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 10),
                  TextFormField(
                    controller: _ageTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: 'Age'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Age!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 10),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        const InputDecoration(hintText: 'Contact Number'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Contact Number!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(width: 10),
                  TextFormField(
                    controller: _addressTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Address'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Address!';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedPayment,
                    decoration: const InputDecoration(
                      labelText: 'Select Payment Method',

                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value;
                        selectedMobileBank = null;
                        _referenceTEController.clear();
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a payment method' : null,
                    items: ['Cash', 'Card', 'Mobile Banking']
                        .map((method) => DropdownMenuItem(
                            value: method, child: Text(method)))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedPayment == 'Mobile Banking') ...[
                DropdownButtonFormField<String>(
                  value: selectedMobileBank,
                  decoration: const InputDecoration(
                    labelText: 'Select Mobile Banking Service',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() => selectedMobileBank = value);
                  },
                  validator: (value) => value == null
                      ? 'Please select a mobile banking service'
                      : null,
                  items: ['Bkash', 'Nagad', 'Rocket']
                      .map((service) => DropdownMenuItem(
                          value: service, child: Text(service)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _referenceTEController,
                  decoration: const InputDecoration(
                    labelText: 'Reference Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (selectedPayment == 'Mobile Banking' &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter reference number';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Patient Information',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Divider(),
                      _buildInfoRow('Patient ID', 'PT001'),
                      _buildInfoRow('Name', 'John Doe'),
                      _buildInfoRow('Age', '45'),
                      _buildInfoRow('Gender', 'Male'),
                      _buildInfoRow('Blood Group', 'A+'),
                      _buildInfoRow('Patient Type', 'Outdoor'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Prescription Data',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('SL')),
                    DataColumn(label: Text('Prescription ID')),
                    DataColumn(label: Text('Prescription Date')),
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('RX1001')),
                      DataCell(Text('2025-07-24')),
                      DataCell(Text('Medicine')),
                      DataCell(
                          TextButton(onPressed: () {}, child: Text('View'))),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Medicine Data',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  // width: screenWidth,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('SL')),
                      DataColumn(label: Text('Item Type')),
                      DataColumn(label: Text('Item Name')),
                      DataColumn(label: Text('Generic')),
                      DataColumn(label: Text('Pres. Qty')),
                      DataColumn(label: Text('Stock Qty')),
                      DataColumn(label: Text('Del. Qty')),
                      DataColumn(label: Text('Rem. Qty')),
                      DataColumn(label: Text('Replace Medicine')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Tablet')),
                        DataCell(Text('Napa 500mg')),
                        DataCell(Text('Paracetamol')),
                        DataCell(Text('10')),
                        DataCell(Text('50')),
                        DataCell(Text('10')),
                        DataCell(Text('0')),
                        DataCell(
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Replace',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.check_box),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Wrap(
                  spacing: 16,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Form submitted successfully')),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedPrescription = null;
                          selectedPatient = null;
                          selectedStore = null;
                          selectedPayment = null;
                          selectedMobileBank = null;
                          _referenceTEController.clear();
                        });
                        _formKey.currentState?.reset();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
