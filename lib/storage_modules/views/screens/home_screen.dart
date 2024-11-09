import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_drive/storage_modules/views/Tabs/custom_file_tab.dart';
import 'package:secure_drive/storage_modules/views/Tabs/custom_storage_tab.dart';
import 'package:secure_drive/storage_modules/views/widgets/header.dart';

import '../../../auth_modules/controllers/auth_controllers.dart';
import '../../controllers/tabbar_navigation_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(25),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Obx(
              () =>
                  Get.find<TabbarNavigationController>().tab.value == "Storage"
                      ? CustomStorageTab()
                      : CustomFileTab(),
            ),
          ],
        ),
      ),
    );
  }
}
