import 'package:cosmetic_shop/core/routes/app_pages.dart';
import 'package:cosmetic_shop/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cosmetic Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const SplashScreen(),
      // home: const SignInScreen(),
      // home: const OtpScreen(),
      // home: const HomeScreen(),
      initialRoute: RouteView.home.name,
      getPages: AppRouting.route,
    );
  }
}
