import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms_module/controller_binder.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ControllerBinder());
  runApp(const PharmacyApp());
}


