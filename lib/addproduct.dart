import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zango/homescreen.dart';
import 'package:zango/items.dart';
import 'package:zango/utils.dart';

import 'additems.dart';

class Products extends StatefulWidget {
  QuerySnapshot<Map<String, dynamic>> list;

  Products({required this.list});
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var namecontroller = new TextEditingController();
  var _myFormKey = GlobalKey<FormState>();
  final databaseref = FirebaseDatabase.instance.reference();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _image;
  String _subcateid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Form(
        key: _myFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton(
                      hint: Text("Select - Product"),
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      items: widget.list.docs
                          .map((value) => DropdownMenuItem(
                              child: Text(value['name']), value: value))
                          .toList(),
                      onChanged: (v) {
                        _subcateid = v!.id.toString();
                      }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: namecontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter name";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://w7.pngwing.com/pngs/205/731/png-transparent-default-avatar-thumbnail.png'),
                                ),
                          Positioned(
                            child: IconButton(
                                onPressed: selectimage,
                                icon: Icon(Icons.add_a_photo)),
                            bottom: -10,
                            left: 80,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      _myFormKey.currentState!.validate();
                      {
                        if (namecontroller.text.isNotEmpty) {
                          saveSubCategories();

                          Fluttertoast.showToast(
                              msg: "Successfully Done",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 12);
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Items(list: widget.list)),
                          );
                        }
                      }
                      namecontroller.clear();
                      _image!.clear();
                    },
                    child: Text("Submit")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveSubCategories() async {
    String name = namecontroller.text;

    String resp = await Storeproduct()
        .saveData(name: name, file: _image!, subcateid: _subcateid);
  }

  void selectimage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
}
