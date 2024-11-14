import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_drive/auth_modules/utils/service_utill.dart';
import 'package:secure_drive/storage_modules/models/folder_model.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

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
      } else if (fileType == "video") {
        MediaInfo? info = await VideoCompress.compressVideo(file.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: true);
        debugPrint(
            "video compresssed >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${info!.path}");
        return File(info.path!);
      } else {
        return file;
      }
    } catch (e) {
      debugPrint("Error in compressing file: $e");
    }
  }

  //!------------------------------------------File Upload inside folder dynmically-----------------------------------------------

  void pickFileAndUpload(String foldername) async {
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
          String filteredFileType = fileType.substring(startIndex, endIndex);
          debugPrint(
              "File type:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $filteredFileType");
          String fileName = file.path.split('/').last;

          String extension = fileName.substring(fileName.indexOf(".") + 1);
          debugPrint(
              "File extension:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $extension");

          debugPrint(
              "File name:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $fileName");
          XFile compressedXFile = await compressFile(filteredFileType, file)!;

          debugPrint(
              "Compressed file path:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${compressedXFile.path}");

          File CompressedFile = File(compressedXFile.path);

          //!getting length of the file collection
          int length = await ServiceUtil.users
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("files")
              .get()
              .then((value) => value.docs.length);
          //!upload task to Firebase Storage
          UploadTask uploadtask = FirebaseStorage.instance
              .ref()
              .child('files')
              .child('Files $length')
              .putFile(CompressedFile);
          TaskSnapshot snapshot = await uploadtask.whenComplete(() {});
          String fileUrl = await snapshot.ref.getDownloadURL();
          debugPrint(
              "File Url:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $fileUrl");
          //! Saving Data in firebase document
          ServiceUtil.users
              .doc(_auth.currentUser!.uid)
              .collection("files")
              .add({
            "fileName": fileName,
            "fileUrl": fileUrl,
            "fileType": filteredFileType,
            "fileExtension": extension,
            "folder": foldername,
            "size":
                (CompressedFile.readAsBytesSync().lengthInBytes / 1024).round(),
            "dateUploaded": DateTime.now(),
          });
        }
        if (foldername == "") {
          Get.back();
        }
      } else {
        debugPrint("File is null");
      }
    } catch (e) {
      debugPrint("Error in picking file: $e");
    }
  }
}
