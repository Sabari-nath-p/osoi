import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/categoryview/categorycardList.dart';
import 'package:oso/screens/home/components/categorBox.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/supporter/sizesupporter.dart';

class categoryMain extends StatefulWidget {
  var pdata;
  categoryMain({super.key, required this.pdata});

  @override
  State<categoryMain> createState() => _categoryMainState(pdata: pdata);
}

class _categoryMainState extends State<categoryMain> {
  var pdata;
  _categoryMainState({required this.pdata});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProduct(pdata["slug"]);
    Loadsubcategory();
  }

  List subcatrgory = [];
  int SelectedSubCatergory = -1;

  int currentClick = 0;
 String currentSlug = "";
  List filterOpt = [
    ["New Release", "orderBy=created_at&sortedBy=DESC"],
    ["Low to High Price", "orderBy=min_price&sortedBy=ASC"],
    ["High to Low Price", "orderBy=max_price&sortedBy=DESC"]
  ];

  Loadsubcategory() async {
    final Response =
        await http.get(Uri.parse('$baseurl/categories/${pdata["id"]}'));
    print(Response.statusCode);
    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      setState(() {
        for (var item in js["children"]) {
          subcatrgory.add(item);
          print(item);
        }
      });
    }
  }

  List products = [];
 
  loadProduct(String slug) async {
    print("working 2");
    currentSlug = slug;
    final Response = await http.get(
        Uri.parse(
            "$baseurl/products?searchJoin=and&with=type%3Bauthor&limit=30&${filterOpt[currentClick][1]}&category=${slug}&category_id=${pdata["id"]}&language=en&search=categories.slug:${slug}%3Bshop.service_locations.zip_code:28166%3Bstatus:publish"),
        headers: {
          "access-control-allow-origin": "*",
          "content-encoding": "gzip",
          "content-type": "application/json"
        });

    if (Response.statusCode == 200) {
      var js = json.decode(Response.body);
      for (var item in js["data"]) {
        setState(() {
          products.add(item);
        });
      }
    }
  }

  loadfilter(int current) {
    setState(() {
      currentClick = current;
      products.clear();
      print("working 1");
    });

    loadProduct(currentSlug);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(20),
            Container(
              height: 60,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Positioned(
                      left: 20,
                      top: 8,
                      child: InkWell(
                          onTap: () {
                            print("working");
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                left: 8, top: 5, bottom: 5, right: 5),
                            margin: EdgeInsets.only(left: 3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                          ))),
                  Positioned(
                    left: 10,
                    right: 10,
                    child: Text(
                      "Catergories",
                      textAlign: TextAlign.center,
                      style: tx700(19, color: Colors.black),
                    ),
                  ),
                  Positioned(
                      left: 140,
                      right: 140,
                      top: 35,
                      child: Container(
                        height: 2,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black38,
                        ),
                      )),
                  Positioned(
                      right: 10,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      width: 390,
                                      padding: EdgeInsets.only(
                                          left: 25, top: 18, right: 25),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(.3)))),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Sort Products",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat"),
                                          ),
                                          height(22),
                                          SizedBox(
                                              width: 390,
                                              height: 90,
                                              child: Wrap(
                                                spacing: 8,
                                                runSpacing: 15,
                                                children: [
                                                  for (int index = 0;
                                                      index < filterOpt.length;
                                                      index++)
                                                    InkWell(
                                                      onTap: () {
                                                        if (currentClick !=
                                                            index) {
                                                          setState(() {
                                                            loadfilter(index);
                                                          });

                                                          // loadProduct(
                                                          //  currentSlug);
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: (currentClick ==
                                                                      index)
                                                                  ? appprimarycolor
                                                                  : null,
                                                              border: Border.all(
                                                                  color: (currentClick ==
                                                                          index)
                                                                      ? appprimarycolor
                                                                      : Colors
                                                                          .black),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                          child: Text(
                                                            filterOpt[index][0],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  (currentClick ==
                                                                          index)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                            ),
                                                          )),
                                                    ),
                                                ],
                                              )),
                                          Container(
                                            width: 390,
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.filter_alt_rounded,
                              color: Colors.black.withOpacity(.9),
                            )),
                      ))
                ],
              ),
            ),
            if (subcatrgory.length > 0) height(10),
            if (subcatrgory.length > 0)
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      width(20),
                      if (false)
                        InkWell(
                            onTap: () {
                              setState(() {
                                products.clear();
                                SelectedSubCatergory = -1;
                                loadProduct(
                                  pdata["slug"],
                                );
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: (SelectedSubCatergory == -1)
                                        ? Border.all(color: appprimarycolor)
                                        : null),
                                child:
                                    subCatergory(subcatrgory[1], test: true))),
                      for (int i = 0; i < subcatrgory.length; i++)
                        InkWell(
                            onTap: () {
                              setState(() {
                                products.clear();
                                SelectedSubCatergory = i;
                                loadProduct(subcatrgory[i]["slug"]);
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: (SelectedSubCatergory == i)
                                        ? Border.all(
                                            color: appprimarycolor, width: 1.5)
                                        : null),
                                child: subCatergory(
                                  subcatrgory[i],
                                ))),
                      width(20),
                    ],
                  ),
                ),
              ),
            height(10),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(children: [
                  for (var pd in products)
                    catergoryCard(
                      pdata: pd,
                      category: (SelectedSubCatergory == -1)
                          ? pdata["name"]
                          : subcatrgory[SelectedSubCatergory]["name"]
                              .toString()
                              .split(":")[0],
                    )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget subCatergory(var pm, {bool test = false}) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      width: 90,
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                (pm["image"].isNotEmpty && !test)
                    ? pm['image']["thumbnail"]
                    : noimage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
