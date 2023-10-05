import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Storeproduct {
  Future<String> uploadimage(String childname, Uint8List file) async {
    Reference ref = _storage.ref().child(childname);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }

  Future<String> saveData({
    required String name,
    required String subcateid,
    required Uint8List file,
  }) async {
    String resp = "Some Error";
    try {
      String imageUrl = await uploadimage("Image Name", file);
      await _firestore
          .collection("Products")
          .add({'name': name, 'imageLink': imageUrl, 'item_id': subcateid});
      return resp = "Success";
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
