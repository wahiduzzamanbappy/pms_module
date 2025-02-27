import 'package:flutter/material.dart';
import 'package:pms_module/ui/screens/home_screen.dart';
import 'package:pms_module/ui/screens/sign_in_screen.dart';
import 'package:pms_module/ui/screens/sign_up_screen.dart';
import 'package:pms_module/ui/screens/splash_screen.dart';
import 'package:pms_module/ui/utils/app_color.dart';

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      initialRoute: '/',
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          fillColor: Colors.white,
          hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            fixedSize: Size.fromWidth(double.maxFinite),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;
        if (settings.name == SplashScreen.name) {
          widget = const SplashScreen();
        } else if (settings.name == SignInScreen.name) {
          widget = const SignInScreen();
        } else if (settings.name == SignUpScreen.name) {
          widget = const SignUpScreen();
        }
        return MaterialPageRoute(builder: (ctx) => widget);
      },
    );
  }
}
