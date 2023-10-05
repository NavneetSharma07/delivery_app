import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zango/addcategories.dart';
import 'package:zango/addsubcategories.dart';
import 'package:zango/items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController carouselController = CarouselController();

  List imagelist = [
    {"id": 1, "image_path": 'assets/vegitablebanner.png'},
    {"id": 2, "image_path": 'assets/fruitsbanner.png'},
    {"id": 3, "image_path": 'assets/toysbanner.png'},
  ];
  int currentindex = 0;
  var firestoreDB =
      FirebaseFirestore.instance.collection("Categories").snapshots();
  var fireasedsb = FirebaseFirestore.instance.collection("Sub-Categories");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Categories")),
        actions: [
          PopupMenuButton(onSelected: (value) {
            setState(() {});
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: 1,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Categories()));
                      },
                      child: Text("Categories"))),
              PopupMenuItem(
                  value: 2,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubCategories()));
                      },
                      child: Text("Sub-Categories"))),
            ];
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: "Search",
              ),
            ),
            Stack(
              children: [
                GestureDetector(
                  child: CarouselSlider(
                      items: imagelist
                          .map(
                            (item) => Image.asset(
                              item['image_path'],
                              fit: BoxFit.cover,
                              width: 300,
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                          scrollPhysics: BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentindex = index;
                            });
                          })),
                ),
                Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imagelist.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: currentindex == entry.key ? 17 : 7,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentindex == entry.key
                                    ? Colors.red
                                    : Colors.teal),
                          ),
                        );
                      }).toList(),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                child: Text(
                  "All Categories",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            StreamBuilder(
                stream: firestoreDB,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data!.docs.length == 0
                      ? Center(child: Text("Categories are not available"))
                      : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, int index) {
                            return InkWell(
                              onTap: () async {
                                print(snapshot.data!.docs[index].id.toString());
                                var list = await fireasedsb
                                    .where("parent_id",
                                        isEqualTo: snapshot.data!.docs[index].id
                                            .toString())
                                    .get();
                                print(list.docs[0].id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Items(
                                            list: list,
                                          )),
                                );
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xffbf7edf8),
                                    ),
                                    width: 160,
                                    height: 103,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            "${snapshot.data?.docs[index]['name']}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffb360b4a)),
                                          ),
                                        ),
                                        Image.network(
                                          snapshot.data?.docs[index]
                                              ['imageLink'],
                                          width: 100,
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          });
                })
          ],
        ),
      ),
    );
  }
}
