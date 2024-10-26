import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/tabbar_navigation_controller.dart';

class Header extends StatelessWidget {
  Header({super.key});
  final tabController = Get.put(TabbarNavigationController());
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            "Secure Drive",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(-10, 10),
                      blurRadius: 20),
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(-10, 10),
                      blurRadius: 20),
                ]),
            child: Obx(() => Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () => tabController.changeTab("Storage"),
                      child: tabcell(
                          context: context,
                          text: "Storage",
                          isSelected: tabController.tab.value == "Storage"),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => tabController.changeTab("Files"),
                      child: tabcell(
                          context: context,
                          text: "Files",
                          isSelected: tabController.tab.value == "Files"),
                    )),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget tabcell(
      {required BuildContext context,
      required String text,
      required bool isSelected}) {
    {
      return isSelected
          ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45 - 10,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(10, 10),
                          blurRadius: 20),
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(-10, 10),
                          blurRadius: 20),
                    ]),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(
              // width: MediaQuery.of(context).size.width * 0.45 - 10,
              height: 60,
              child: Center(
                child: Text(text,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            );
    }
  }
}
