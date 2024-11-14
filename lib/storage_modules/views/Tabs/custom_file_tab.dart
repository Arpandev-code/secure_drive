import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:secure_drive/storage_modules/controllers/storage_controller.dart';

import '../widgets/recent_file.dart';
import '../widgets/recent_folder.dart';

class CustomFileTab extends StatelessWidget {
  CustomFileTab({super.key});
  final storageController = Get.put(StorageController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            RecentFile(),
            // const SizedBox(height: 5),
            RecentFolder(),
          ],
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2 - 20,
          child: InkWell(
            onTap: () {
              bottomSheet(
                  context: context,
                  onTap: () {
                    storageController.pickFileAndUpload("");
                  });
            },
            child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20)),
          ),
        ),
      ],
    );
  }

  Future<dynamic> bottomSheet({
    required BuildContext context,
    required Function onTap,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Container(
          alignment: Alignment.center,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  showCustomDialogBox(
                      context: context,
                      foldercontroller: storageController.folderController,
                      ontap: () {
                        storageController.createFolder(
                            storageController.folderController.text.trim() ??
                                "Untitled Folder");
                        Get.back();
                      });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      EvaIcons.folderAdd,
                      color: Colors.grey,
                      size: 45,
                    ),
                    Text("Add Folder")
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onTap();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      EvaIcons.upload,
                      color: Colors.grey,
                      size: 45,
                    ),
                    Text("Upload")
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future showCustomDialogBox({
    required BuildContext context,
    required Function ontap,
    required TextEditingController foldercontroller,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
          title: const Text("New Folder"),
          content: TextField(
            controller: foldercontroller,
            autofocus: true,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              hintText: "Untitled Folder",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ontap();
              },
              child: const Text(
                "Create",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ],
        );
      },
    );
  }
}
