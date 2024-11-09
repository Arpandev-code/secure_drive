import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_drive/auth_modules/utils/service_utill.dart';
import 'package:secure_drive/storage_modules/models/folder_model.dart';
import 'package:uuid/uuid.dart';

class StorageController extends GetxController {
  TextEditingController folderController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<FolderModel> folders = <FolderModel>[].obs;
  @override
  void onInit() {
    displayFolder();
    super.onInit();
  }

  //!------------------------------------------New Folder Creation-----------------------------------------------
  void createFolder(String folderName) {
    try {
      ServiceUtil.users.doc(_auth.currentUser!.uid).collection("folders").add({
        "name": folderName == "" ? "Untitled Folder" : folderName,
        "time": DateTime.now(),
      });
    } catch (e) {
      debugPrint("New Folder Creation Error: $e");
    }
  }

  //!------------------------------------------Display folder dynmically-----------------------------------------------
  void displayFolder() {
    try {
      debugPrint(
          "Fetching folders>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      ServiceUtil.users
          .doc(_auth.currentUser!.uid)
          .collection("folders")
          .orderBy("time", descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<FolderModel> folders = [];
        query.docs.forEach((element) {
          folders.add(FolderModel.fromDocumentSnapshot(element));
        });
        return folders;
      }).listen((folders) {
        this.folders.value = folders;
      });
    } catch (e) {
      debugPrint("Error in fetching folders: $e");
    }
  }

  //!------------------------------------------Delete folder dynmically-----------------------------------------------
  void deleteFolder(String id) {
    try {
      ServiceUtil.users
          .doc(_auth.currentUser!.uid)
          .collection("folders")
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint("Error in deleting folder: $e");
    }
  }
//!------------------------------------------Compress file-----------------------------------------------

  compressFile(String fileType, XFile file) async {
    Uuid uuid = const Uuid();
    try {
      if (fileType == "image") {
        final directory = await getTemporaryDirectory();
        final targetPath = "${directory.path}/${uuid.v4().substring(0, 8)}.jpg";
        debugPrint("Target path: $targetPath");
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          quality: 75,
        );
        return compressedFile;
      }
    } catch (e) {
      debugPrint("Error in compressing file: $e");
    }
  }

  //!------------------------------------------File Upload inside folder dynmically-----------------------------------------------

  void pickFileAndUpload(String id) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        // List<XFile> files = result.paths.map((path) => File(path!)).toList();
        List<XFile> xFiles = result.xFiles;
        // debugPrint(files.toString());
        // uploadfileInsideFolders(id, files[0]);
        for (XFile file in xFiles) {
          String? fileType = lookupMimeType(file.path);
          debugPrint(
              "Direct File type with Extension:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $fileType");
          int startIndex = 0;
          String endString = "/";
          int endIndex = fileType!.indexOf(endString);
          String fileExtension = fileType.substring(startIndex, endIndex);
          debugPrint(
              "File type:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $fileExtension");
          String fileName = file.path.split('/').last;
          debugPrint(
              "File name:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $fileName");
          XFile compressedFile = await compressFile(fileExtension, file)!;
          debugPrint(
              "Compressed file path:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${compressedFile.path}");
          // uploadfileInsideFolders(id, compressedFile);
        }
      }
    } catch (e) {
      debugPrint("Error in picking file: $e");
    }
  }

  void uploadfileInsideFolders(String id, File files) {
    try {
      ServiceUtil.users
          .doc(_auth.currentUser!.uid)
          .collection("folders")
          .doc(id)
          .collection("files")
          .add({
        "name": folderController.text,
        "time": DateTime.now(),
        "files": files
      });
    } catch (e) {
      debugPrint("Error in uploading file: $e");
    }
  }
}
