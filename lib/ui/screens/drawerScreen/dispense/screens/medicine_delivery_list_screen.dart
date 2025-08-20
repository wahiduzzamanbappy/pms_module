import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:pms_module/ui/widgets/pms_app_bar.dart';

class MedicineDeliveryListScreen extends StatefulWidget {
  const MedicineDeliveryListScreen({super.key});

  static const String name = '/delivery-list';

  @override
  State<MedicineDeliveryListScreen> createState() =>
      _MedicineDeliveryListScreenState();
}

class _MedicineDeliveryListScreenState
    extends State<MedicineDeliveryListScreen> {
  final TextEditingController _prescriptionIDTEController =
      TextEditingController();
  final TextEditingController _patientIDTEController = TextEditingController();
  final TextEditingController _patientNameTEController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PMSAppBar(textTheme: textTheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _dateWidget(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: _prescriptionIDTEController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: 'Prescription ID',
                            border: OutlineInputBorder(),
                            labelText: 'Prescription ID'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: _patientIDTEController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: 'Patient ID',
                            border: OutlineInputBorder(),
                            labelText: 'Patient ID'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: _patientNameTEController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: 'Patient Name',
                            border: OutlineInputBorder(),
                            labelText: 'Patient Name'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: () {}, child: Text('Search')),
                  SizedBox(width: 14),
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Colors.deepOrange,
                      )),
                      onPressed: () {},
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(width: 14),
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                        (states) => Colors.deepPurple,
                      )),
                      onPressed: () {},
                      child: Text(
                        'Print',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 395,
                height: 40,
                color: Colors.blueGrey,
                child: Center(
                  child: const Text('Medicine Delivery List',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('SL')),
                  DataColumn(label: Text('Patient Name')),
                  DataColumn(label: Text('Pres. ID')),
                  DataColumn(label: Text('Delivery Date')),
                  DataColumn(label: Text('Item Type')),
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Prescribed Qty')),
                  DataColumn(label: Text('Delivered Qty')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('1')),
                    DataCell(Text('Mr. X')),
                    DataCell(Text('P2507270001')),
                    DataCell(Text('07/27/2025')),
                    DataCell(Text('Tab')),
                    DataCell(Text('Napa 500mg')),
                    DataCell(Text('20')),
                    DataCell(Text('15')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('2')),
                    DataCell(Text('Mr. X')),
                    DataCell(Text('P2507270001')),
                    DataCell(Text('07/27/2025')),
                    DataCell(Text('Cap')),
                    DataCell(Text('Esotid 20mg')),
                    DataCell(Text('10')),
                    DataCell(Text('10')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('3')),
                    DataCell(Text('Mr. X')),
                    DataCell(Text('P2507270001')),
                    DataCell(Text('07/27/2025')),
                    DataCell(Text('Drop')),
                    DataCell(Text('Drylief E/D')),
                    DataCell(Text('1')),
                    DataCell(Text('1')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dateWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: DateFormatField(
                type: DateFormatType.type4,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(),
                  labelText: "To Date",
                ),
                onComplete: (date) {},
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 50,
              child: DateFormatField(
                type: DateFormatType.type4,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: "From Date",
                ),
                onComplete: (date) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
