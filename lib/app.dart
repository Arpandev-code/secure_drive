import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_drive/auth_modules/views/login_screen.dart';

import 'auth_modules/controllers/auth_controllers.dart';
import 'storage_modules/views/screens/home_screen.dart';

class DecisionPage extends StatelessWidget {
  DecisionPage({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(builder: (controller) {
      if (controller.isSignedIn.value) {
        return const HomeScreen();
      } else {
        return LoginScreen();
      }
    });
  }
}
