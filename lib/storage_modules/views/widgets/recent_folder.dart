import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/storage_controller.dart';

class RecentFolder extends StatelessWidget {
  RecentFolder({super.key});
  final storageController = Get.put(StorageController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: GetX<StorageController>(builder: (StorageController controller) {
          return GridView.builder(
              itemCount: controller.folders.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9),
              itemBuilder: (context, index) {
                return controller.folders.isEmpty
                    ? const Center(child: Text("No Folders Found"))
                    : Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(10, 10),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(-10, 10),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/images/folder.png",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  controller.folders[index].name,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "10 Items",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            )));
              });
        }),
      ),
    );
  }
}
