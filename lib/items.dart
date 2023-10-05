import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zango/addproduct.dart';

class Items extends StatefulWidget {
  QuerySnapshot<Map<String, dynamic>> list;

  Items({required this.list});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List _productlists = [];
  int selectedIndex = 0;
  PageController _pageController = PageController();
  var fireasedproduct = FirebaseFirestore.instance.collection("Products");

  Future<void> _getdata() async {
    var list = await fireasedproduct
        .where("item_id", isEqualTo: widget.list.docs[0].id.toString())
        .get();
    print(list.docs.first["name"]);
    list.docs.forEach((element) {
      setState(() {
        _productlists.add({
          "name": element['name'].toString(),
          "imageLink": element['imageLink'].toString()
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Total items"),
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
                                builder: (context) => Products(
                                      list: widget.list,
                                    )));
                      },
                      child: Text("Add Products"))),
            ];
          }),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: ListView.builder(
                    itemCount: widget.list.docs.length,
                    itemBuilder: (context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedIndex = index;
                            _pageController.jumpToPage(index);
                            _productlists.clear();
                          });

                          print(widget.list.docs[index].id.toString());
                          var list = await fireasedproduct
                              .where("item_id",
                                  isEqualTo:
                                      widget.list.docs[index].id.toString())
                              .get();
                          print(list.docs.first["name"]);
                          list.docs.forEach((element) {
                            setState(() {
                              _productlists.add({
                                "name": element['name'].toString(),
                                "imageLink": element['imageLink'].toString()
                              });
                            });
                          });

                          print("testing ----" + _productlists.toString());
                        },
                        child: Container(
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 500,
                                ),
                                height: (selectedIndex == index) ? 20 : 0,
                                color: Colors.blue,
                              ),
                              Expanded(
                                child: Container(
                                  color: (selectedIndex == index)
                                      ? Color(0xffb9d26b1).withOpacity(0.2)
                                      : Colors.transparent,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(widget
                                              .list.docs[index]["imageLink"]),
                                          radius: 30,
                                        ),
                                      ),
                                      Text(widget.list.docs[index]["name"]),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 3,
              child: PageView(controller: _pageController, children: [
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 5.5 / 7.5),
                    itemCount: _productlists.length,
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(blurRadius: 1)],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomRight: Radius.circular(10)),
                                    color: Color(0xffb9b28b0)),
                                width: 45,
                                height: 15,
                                child: Center(
                                  child: Text("6% off",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 8, right: 8),
                                child: Container(
                                  width: 100,
                                  height: 70,
                                  child: Center(
                                      child: Image.network(
                                    _productlists[index]["imageLink"],
                                    fit: BoxFit.fill,
                                  )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 8),
                                child: SizedBox(
                                  height: 30,
                                  child: Text("${_productlists[index]["name"]}",
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                          color: Color(0xffbc06987),
                                          fontSize: 15),
                                    ),
                                  ),
                                  width: 50,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Color(0xffbc06987),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
