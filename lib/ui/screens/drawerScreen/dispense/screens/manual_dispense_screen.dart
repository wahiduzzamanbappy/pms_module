/*
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
                          WidgetStateProperty.all<Color>(Colors.blue),
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
                          WidgetStateProperty.all<Color>(Colors.deepOrange),
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
*/
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class ManualDispenseScreen extends StatefulWidget {
  const ManualDispenseScreen({super.key});

  static const String name = '/manual-dispense-screen';

  @override
  _ManualDispenseScreenState createState() => _ManualDispenseScreenState();
}

class _ManualDispenseScreenState extends State<ManualDispenseScreen> {
  final _patientFormKey = GlobalKey<FormState>();
  final _medicineFormKey = GlobalKey<FormState>();

  String? selectedPatient;
  String? selectedGender;
  String? selectedValue;
  String? selectedMaritalStatus;
  String? selectedStore;
  String? selectedPayment;
  String? selectedMobileBank;

  // Tracks the currently chosen payment method inside the payment card
  String _selectedPaymentMethod = 'Cash';

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

  // ── Invoice number counter (increment per session / replace with DB sequence) ──
  int _invoiceCounter = 1;

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

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
            // ── Patient Form ──
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
                      const Text(
                        "Patient Form",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent),
                      ),
                      const Divider(),
                      _buildTextArea(dropdownColumns, isPortrait),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Medicine Entry Form ──
            _buildMedicineEntryForm(),
            const SizedBox(height: 20),

            // ── Medicine Entry List ──
            _buildMedicineEntryList(),
            const SizedBox(height: 20),

            // ── Payment Method ──
            _buildPaymentMethodSection(),
            const SizedBox(height: 20),

            // ── Save & Reset Buttons ──
            Center(
              child: Wrap(
                spacing: 16,
                children: [
                  // ── SAVE → Generate PDF Invoice ──
                  OutlinedButton.icon(
                    onPressed: _onSavePressed,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.blue),
                    ),
                  ),

                  // ── RESET ──
                  OutlinedButton.icon(
                    onPressed: _onResetPressed,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.deepOrange),
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

  // ─────────────────────────────────────────────
  // BUTTON HANDLERS
  // ─────────────────────────────────────────────

  /// Validates form → builds invoice data → opens PDF preview/print screen.
  Future<void> _onSavePressed() async {
    if (!_patientFormKey.currentState!.validate()) return;

    if (medicineEntryList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medicine!')),
      );
      return;
    }

    // Build the payment info string from selected method
    String paymentInfo = 'Payment Method: $_selectedPaymentMethod';
    if (_selectedPaymentMethod == 'Mobile Banking' &&
        selectedMobileBank != null) {
      paymentInfo +=
      ' (${selectedMobileBank!}) — Ref: ${_referenceTEController.text}';
    }

    // Map medicineEntryList → InvoiceLineItem list
    final items = medicineEntryList
        .map((e) => InvoiceLineItem(
      name: e['medicineName'] as String,
      category: e['category'] as String,
      price: double.tryParse(e['sRate'].toString()) ?? 0.0,
      quantity: int.tryParse(e['qty'].toString()) ?? 1,
      date: DateTime.now(),
    ))
        .toList();

    final invoiceNumber =
    _invoiceCounter.toString().padLeft(7, '0'); // e.g. 0000001

    final invoiceData = InvoiceData(
      invoiceNumber: invoiceNumber,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      // Bill From — clinic details (hardcoded; swap with settings values)
      fromName: 'ePharmacy App',
      fromAddress: 'Dhaka',
      fromCity: 'Dhaka',
      fromPhone: '01000000000',
      // Bill To — patient details from form
      toName: _nameTEController.text.trim(),
      toAddress: _addressTEController.text.trim(),
      toCity: '',
      items: items,
      taxRate: 0.0, // Set e.g. 0.05 for 5% tax
      paymentInfo: paymentInfo,
    );

    // Open Flutter's built-in PDF preview + print dialog
    await Printing.layoutPdf(
      onLayout: (_) async {
        final pdf = await InvoicePdfGenerator.generate(invoiceData);
        return pdf.save();
      },
      name: 'Invoice_$invoiceNumber',
    );

    // Increment counter after successful generation
    setState(() => _invoiceCounter++);
  }

  void _onResetPressed() {
    setState(() {
      selectedPatient = null;
      selectedGender = null;
      selectedMaritalStatus = null;
      selectedStore = null;
      selectedPayment = null;
      selectedMobileBank = null;
      _selectedPaymentMethod = 'Cash';
      _referenceTEController.clear();
      _nameTEController.clear();
      _mobileTEController.clear();
      _ageTEController.clear();
      _addressTEController.clear();
      _medicineNameController.clear();
      _categoryController.clear();
      _stockController.clear();
      _sRateController.clear();
      _qtyController.clear();
      medicineEntryList.clear();
    });
    _patientFormKey.currentState?.reset();
    _medicineFormKey.currentState?.reset();
  }

  // ─────────────────────────────────────────────
  // PATIENT FORM FIELDS
  // ─────────────────────────────────────────────

  Widget _buildTextArea(int dropdownColumns, bool isPortrait) {
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
          validator: (value) =>
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
          validator: (value) =>
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
          validator: (value) {
            final phone = value?.trim() ?? '';
            final regExp = RegExp(r'^(?:\+88|88)?01[3-9]\d{8}$');
            if (phone.isEmpty || !regExp.hasMatch(phone)) {
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
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
        TextFormField(
          controller: _addressTEController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          validator: (value) =>
          (value?.trim().isEmpty ?? true) ? 'Enter your Address!' : null,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // MEDICINE ENTRY FORM
  // ─────────────────────────────────────────────

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
              const Text(
                "Medicine Entry",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent),
              ),
              const Divider(),
              TextFormField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Please enter medicine name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter stock' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'S.Rate',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Please enter selling rate'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Qty',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value?.isEmpty ?? true) ? 'Please enter quantity' : null,
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
                        'totalAmount':
                        double.parse(_sRateController.text) *
                            double.parse(_qtyController.text),
                      });
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

  // ─────────────────────────────────────────────
  // MEDICINE ENTRY LIST
  // ─────────────────────────────────────────────

  Widget _buildMedicineEntryList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medicine Entry List",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueAccent),
            ),
            const Divider(),
            if (medicineEntryList.isEmpty)
              const Text('No entries added yet.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicineEntryList.length,
                itemBuilder: (context, index) {
                  final medicine = medicineEntryList[index];
                  return ListTile(
                    title: Text(medicine['medicineName']),
                    subtitle: Text(
                      'Category: ${medicine['category']}, '
                          'Stock: ${medicine['stock']}, '
                          'S. Rate: ${medicine['sRate']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total: ${(medicine['totalAmount'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        // ── Delete entry ──
                        IconButton(
                          icon:
                          const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () =>
                              setState(() => medicineEntryList.removeAt(index)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            // ── Grand total row ──
            if (medicineEntryList.isNotEmpty) ...[
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Grand Total: ৳${_grandTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.blueAccent),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _grandTotal() =>
      medicineEntryList.fold(0.0, (sum, e) => sum + (e['totalAmount'] as double));

  // ─────────────────────────────────────────────
  // PAYMENT METHOD SECTION
  // ─────────────────────────────────────────────

  Widget _buildPaymentMethodSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Method",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueAccent),
            ),
            const Divider(),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                  selectedPayment = value;
                  selectedMobileBank = null;
                  _referenceTEController.clear();
                });
              },
              validator: (value) =>
              value == null ? 'Please select payment method' : null,
              items: ['Cash', 'Card', 'Mobile Banking']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            if (_selectedPaymentMethod == 'Mobile Banking') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedMobileBank,
                decoration: const InputDecoration(
                  labelText: 'Mobile Banking Service',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) => setState(() => selectedMobileBank = value),
                validator: (value) => value == null
                    ? 'Please select a mobile banking service'
                    : null,
                items: ['Bkash', 'Nagad', 'Rocket']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                  if (_selectedPaymentMethod == 'Mobile Banking' &&
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
}

// ═════════════════════════════════════════════════════════════════════════════
// INVOICE DATA MODEL
// ═════════════════════════════════════════════════════════════════════════════

class InvoiceLineItem {
  final String name;
  final String category;
  final double price;
  final int quantity;
  final DateTime date;

  InvoiceLineItem({
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.date,
  });

  double get total => price * quantity;
}

class InvoiceData {
  final String invoiceNumber;
  final DateTime issueDate;
  final DateTime dueDate;

  final String fromName;
  final String fromAddress;
  final String fromCity;
  final String fromPhone;

  final String toName;
  final String toAddress;
  final String toCity;

  final List<InvoiceLineItem> items;
  final double taxRate;
  final String paymentInfo;

  InvoiceData({
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.fromName,
    required this.fromAddress,
    required this.fromCity,
    required this.fromPhone,
    required this.toName,
    required this.toAddress,
    required this.toCity,
    required this.items,
    this.taxRate = 0.0,
    this.paymentInfo = '',
  });

  double get subtotal => items.fold(0, (s, e) => s + e.total);
  double get tax => subtotal * taxRate;
  double get totalDue => subtotal + tax;
}

// ═════════════════════════════════════════════════════════════════════════════
// PDF GENERATOR
// ═════════════════════════════════════════════════════════════════════════════

class InvoicePdfGenerator {
  // Palette
  static const _dark = PdfColor.fromInt(0xFF111111);
  static const _muted = PdfColor.fromInt(0xFF888888);
  static const _lightGrey = PdfColor.fromInt(0xFFF5F5F5);
  static const _border = PdfColor.fromInt(0xFFDDDDDD);

  static Future<pw.Document> generate(InvoiceData data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final bold = await PdfGoogleFonts.robotoBold();

    final dateFmt = DateFormat('MMM dd, yyyy');
    final moneyFmt = NumberFormat('#,##0.00');

    String money(double v) => 'BDT ${moneyFmt.format(v)}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ── HEADER ──────────────────────────────────────────────────────
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('INVOICE',
                        style: pw.TextStyle(
                            font: bold,
                            fontSize: 28,
                            letterSpacing: 1.5,
                            color: _dark)),
                    pw.SizedBox(height: 4),
                    pw.Text('#${data.invoiceNumber}',
                        style: pw.TextStyle(
                            font: font, fontSize: 11, color: _muted)),
                  ],
                ),
                pw.Container(
                  width: 120,
                  height: 48,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _border),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text('Appnix IT',
                      style: pw.TextStyle(
                          font: bold, fontSize: 10, color: _muted)),
                ),
              ],
            ),

            pw.SizedBox(height: 20),
            pw.Divider(color: _border, thickness: 1),
            pw.SizedBox(height: 14),

            // ── BILL FROM / BILL TO / DATES ──────────────────────────────
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Bill From
                pw.Expanded(
                  child: _addressBlock(
                    label: 'BILL FROM',
                    name: data.fromName,
                    lines: [data.fromAddress, data.fromCity, data.fromPhone],
                    font: font,
                    bold: bold,
                  ),
                ),
                pw.SizedBox(width: 16),
                // Bill To
                pw.Expanded(
                  child: _addressBlock(
                    label: 'BILL TO',
                    name: data.toName,
                    lines: [data.toAddress, data.toCity],
                    font: font,
                    bold: bold,
                  ),
                ),
                pw.SizedBox(width: 16),
                // Dates
                pw.SizedBox(
                  width: 130,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _dateBlock('ISSUE DATE', dateFmt.format(data.issueDate),
                          font, bold),
                      pw.SizedBox(height: 10),
                      /*_dateBlock(
                          'DUE DATE', dateFmt.format(data.dueDate), font, bold),*/
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            // ── LINE ITEMS TABLE ─────────────────────────────────────────
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1.6), // Date
                1: const pw.FlexColumnWidth(3.2), // Description
                2: const pw.FlexColumnWidth(1.6), // Price
                3: const pw.FlexColumnWidth(0.8), // QTY
                4: const pw.FlexColumnWidth(1.6), // Total
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration:
                  const pw.BoxDecoration(color: _lightGrey),
                  children: [
                    _th('Date', bold),
                    _th('Description', bold),
                    _th('Price', bold),
                    _th('QTY', bold),
                    _th('Total', bold, right: true),
                  ],
                ),
                // Data rows
                ...data.items.asMap().entries.map((entry) {
                  final item = entry.value;
                  final isEven = entry.key.isEven;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color:
                      isEven ? PdfColors.white : const PdfColor.fromInt(0xFFFAFAFA),
                      border: const pw.Border(
                        bottom: pw.BorderSide(color: _border, width: 0.5),
                      ),
                    ),
                    children: [
                      _td(dateFmt.format(item.date), font),
                      _td('${item.name} (${item.category})', font),
                      _td(money(item.price), font),
                      _td('${item.quantity}', font),
                      _td(money(item.total), font, right: true),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 16),

            // ── SUBTOTAL / TAX / TOTAL ───────────────────────────────────
            pw.Row(
              children: [
                pw.Spacer(),
                pw.Container(
                  width: 230,
                  child: pw.Column(
                    children: [
                      _summaryRow('Subtotal', money(data.subtotal), font, bold),
                      pw.Divider(color: _border, thickness: 0.5),
                      _summaryRow(
                          'Tax (${(data.taxRate * 100).toStringAsFixed(0)}%)',
                          money(data.tax),
                          font,
                          bold),
                      pw.Divider(color: _border, thickness: 1),
                      _summaryRow(
                          'Total Bill', money(data.totalDue), bold, bold,
                          isTotal: true),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 28),

            // ── PAYMENT INFO ─────────────────────────────────────────────
            if (data.paymentInfo.isNotEmpty) ...[
              pw.Text('Payment Information:',
                  style:
                  pw.TextStyle(font: bold, fontSize: 10, color: _dark)),
              pw.SizedBox(height: 5),
              pw.Text(data.paymentInfo,
                  style:
                  pw.TextStyle(font: font, fontSize: 9, color: _muted)),
              pw.SizedBox(height: 20),
            ],

            pw.Spacer(),

            // ── FOOTER ───────────────────────────────────────────────────
            pw.Divider(color: _border, thickness: 1),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Thank you for your business!',
                style: pw.TextStyle(font: bold, fontSize: 11, color: _muted),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  // ── Widget helpers ──────────────────────────────────────────────────────

  static pw.Widget _addressBlock({
    required String label,
    required String name,
    required List<String> lines,
    required pw.Font font,
    required pw.Font bold,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: bold, fontSize: 8, color: _muted, letterSpacing: 1)),
        pw.SizedBox(height: 4),
        pw.Text(name,
            style: pw.TextStyle(font: bold, fontSize: 12, color: _dark)),
        pw.SizedBox(height: 2),
        ...lines
            .where((l) => l.isNotEmpty)
            .map((l) => pw.Text(l,
            style: pw.TextStyle(font: font, fontSize: 10, color: _muted))),
      ],
    );
  }

  static pw.Widget _dateBlock(
      String label, String value, pw.Font font, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: bold, fontSize: 8, color: _muted, letterSpacing: 1)),
        pw.SizedBox(height: 2),
        pw.Text(value,
            style: pw.TextStyle(font: bold, fontSize: 11, color: _dark)),
      ],
    );
  }

  static pw.Widget _th(String text, pw.Font bold, {bool right = false}) =>
      pw.Padding(
        padding:
        const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: pw.Text(text,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(font: bold, fontSize: 10, color: _dark)),
      );

  static pw.Widget _td(String text, pw.Font font, {bool right = false}) =>
      pw.Padding(
        padding:
        const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 6),
        child: pw.Text(text,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(font: font, fontSize: 10, color: _dark)),
      );

  static pw.Widget _summaryRow(
      String label,
      String value,
      pw.Font labelFont,
      pw.Font valueFont, {
        bool isTotal = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  font: labelFont,
                  fontSize: isTotal ? 12 : 10,
                  color: isTotal ? _dark : _muted)),
          pw.Text(value,
              style: pw.TextStyle(
                  font: valueFont, fontSize: isTotal ? 13 : 10, color: _dark)),
        ],
      ),
    );
  }
}