import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms_module/ui/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.to(SignInScreen());
    /*if (AuthController().accessToken != null) {
      Get.to(DashboardScreen());
    } else {
      Get.to(SignInScreen());
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
          child: Text('AppLogo'),
        ),

    );
  }
}