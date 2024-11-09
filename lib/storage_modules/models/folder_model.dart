import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel {
  late String id;
  late String name;
  late DateTime dateCreated;
  late int items;

  FolderModel(this.id, this.name, this.dateCreated, this.items);

  FolderModel.fromDocumentSnapshot(QueryDocumentSnapshot docs) {
    id = docs.id;
    name = docs['name'];
    dateCreated = docs['time'].toDate();
    // items = docs['items'];
  }
}
