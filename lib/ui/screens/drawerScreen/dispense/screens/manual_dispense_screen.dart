import 'package:flutter/material.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class ManualDispenseScreen extends StatefulWidget {
  const ManualDispenseScreen({super.key});

  static const String name = '/manual-dispense-screen';

  @override
  _ManualDispenseScreenState createState() => _ManualDispenseScreenState();
}

class _ManualDispenseScreenState extends State<ManualDispenseScreen> {
  final _patientFormKey = GlobalKey<FormState>(); // Patient form key
  final _medicineFormKey = GlobalKey<FormState>(); // Medicine form key

  String? selectedPatient;
  String? selectedGender;
  String? selectedValue;
  String? selectedMaritalStatus;
  String? selectedStore;
  String? selectedPayment;
  String? selectedMobileBank;

  final TextEditingController _referenceTEController = TextEditingController();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _ageTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _sRateController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  List<Map<String, dynamic>> medicineEntryList = [];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Form Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _patientFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Patient Form",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent)),
                      const Divider(),
                      _buildTextArea(dropdownColumns, isPortrait),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Medicine Entry Form
            _buildMedicineEntryForm(),
            const SizedBox(height: 20),

            // Medicine Entry List
            _buildMedicineEntryList(),
            const SizedBox(height: 20),

            // Payment Method Section
            _buildPaymentMethodSection(),
            const SizedBox(height: 20),

            // Save & Reset Buttons
            Center(
              child: Wrap(
                spacing: 16,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_patientFormKey.currentState!.validate()) {
                        if (medicineEntryList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please add at least one medicine!')),
                          );
                          return;
                        }

                        // Generate Invoice Logic
                        String invoiceDetails = generateInvoice();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(invoiceDetails)),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedPatient = null;
                        selectedStore = null;
                        selectedPayment = null;
                        selectedMobileBank = null;
                        _referenceTEController.clear();
                        _nameTEController.clear();
                        _mobileTEController.clear();
                        _ageTEController.clear();
                        _addressTEController.clear();
                        medicineEntryList.clear();
                      });
                      _patientFormKey.currentState?.reset();
                      _medicineFormKey.currentState?.reset();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepOrange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Payment Method Section
  Widget _buildPaymentMethodSection() {
    String selectedPaymentMethod = 'Cash';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Payment Method",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent)),
            const Divider(),
            DropdownButtonFormField<String>(
              value: selectedPaymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  selectedPayment = value;
                  selectedMobileBank = null;
                  _referenceTEController.clear();
                });
              },
              validator: (value) =>
                  value == null ? 'Please select payment method' : null,
              items: ['Cash', 'Card', 'Mobile Banking']
                  .map((method) =>
                      DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
            ),
            if (selectedPayment == 'Mobile Banking') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedMobileBank,
                decoration: const InputDecoration(
                  labelText: 'Mobile Banking Service',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) {
                  setState(() => selectedMobileBank = value);
                },
                validator: (value) => value == null
                    ? 'Please select a mobile banking service'
                    : null,
                items: ['Bkash', 'Nagad', 'Rocket']
                    .map((service) =>
                        DropdownMenuItem(value: service, child: Text(service)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referenceTEController,
                decoration: const InputDecoration(
                  labelText: 'Reference Number',
                  border: OutlineInputBorder(),
                  isDense: true,
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
          ],
        ),
      ),
    );
  }

  // Form Fields
  _buildTextArea(int dropdownColumns, bool isPortrait) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: dropdownColumns,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TextFormField(
          controller: _nameTEController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          validator: (String? value) =>
              (value?.trim().isEmpty ?? true) ? 'Enter your Name!' : null,
        ),
        TextFormField(
          controller: _ageTEController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          validator: (String? value) =>
              (value?.trim().isEmpty ?? true) ? 'Enter your Age!' : null,
        ),
        TextFormField(
          controller: _mobileTEController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Contact Number',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          validator: (String? value) {
            String phoneNumber = value?.trim() ?? '';
            RegExp regExp = RegExp(r'^(?:\+88|88)?01[3-9]\d{8}$');
            if (phoneNumber.isEmpty || !regExp.hasMatch(phoneNumber)) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
        DropdownButtonFormField<String>(
          value: selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) => setState(() => selectedGender = value),
          validator: (value) => value == null ? 'Please select gender' : null,
          items: ['Male', 'Female']
              .map((method) =>
                  DropdownMenuItem(value: method, child: Text(method)))
              .toList(),
        ),
        DropdownButtonFormField<String>(
          value: selectedMaritalStatus,
          decoration: const InputDecoration(
            labelText: 'Marital Status',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) => setState(() => selectedMaritalStatus = value),
          validator: (value) =>
              value == null ? 'Please select Marital Status' : null,
          items: ['Divorced', 'Married', 'Unmarried', 'Widowed']
              .map((method) =>
                  DropdownMenuItem(value: method, child: Text(method)))
              .toList(),
        ),
        TextFormField(
          controller: _addressTEController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          validator: (String? value) =>
              (value?.trim().isEmpty ?? true) ? 'Enter your Address!' : null,
        ),
      ],
    );
  }

  // Medicine Entry Form
  Widget _buildMedicineEntryForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _medicineFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Medicine Entry",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent)),
              const Divider(),
              TextFormField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter medicine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter stock';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'S.Rate',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter selling rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Qty',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_medicineFormKey.currentState!.validate()) {
                    setState(() {
                      medicineEntryList.add({
                        'medicineName': _medicineNameController.text,
                        'category': _categoryController.text,
                        'stock': _stockController.text,
                        'sRate': _sRateController.text,
                        'qty': _qtyController.text,
                        'totalAmount': double.parse(_sRateController.text) *
                            double.parse(_qtyController.text),
                      });

                      // Clear form after adding entry
                      _medicineNameController.clear();
                      _categoryController.clear();
                      _stockController.clear();
                      _sRateController.clear();
                      _qtyController.clear();
                    });
                  }
                },
                child: const Text('Add to List'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Medicine Entry List
  Widget _buildMedicineEntryList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Medicine Entry List",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent)),
            const Divider(),
            if (medicineEntryList.isEmpty)
              const Text('No entries added yet.')
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: medicineEntryList.length,
                itemBuilder: (context, index) {
                  final medicine = medicineEntryList[index];
                  return ListTile(
                    title: Text(medicine['medicineName']),
                    subtitle: Text(
                        'Category: ${medicine['category']}, Stock: ${medicine['stock']}, S. Rate: ${medicine['sRate']}'),
                    trailing: Text(
                      'Total: ${medicine['totalAmount'].toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Generate Invoice Logic
  String generateInvoice() {
    double totalAmount = medicineEntryList.fold(0.0, (sum, item) {
      return sum + item['totalAmount'];
    });

    return 'Invoice Generated:\nTotal Medicine Amount: ৳${totalAmount.toStringAsFixed(2)}';
  }
}
