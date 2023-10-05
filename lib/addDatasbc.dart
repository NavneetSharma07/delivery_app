import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreSubCategories {
  Future<String> uploadimage(String childname, Uint8List file) async {
    Reference ref = _storage.ref().child(childname);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }

  Future<String> saveData({
    required String name,
    required String cateid,
    required Uint8List file,
  }) async {
    String resp = "Some Error";
    try {
      String imageUrl = await uploadimage("Image Name", file);
      await _firestore
          .collection("Sub-Categories")
          .add({'name': name, 'imageLink': imageUrl, 'parent_id': cateid});
      return resp = "Success";
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
