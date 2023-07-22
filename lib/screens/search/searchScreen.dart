import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/datamodel/cartmodel.dart';
import 'package:oso/screens/home/components/popularCard.dart';
import 'package:oso/supporter/sizesupporter.dart';

import '../../constant/url.dart';
import '../../supporter/functionsupporter.dart';

class searchScreen extends StatefulWidget {
  ValueNotifier notify;
  String slug;
  searchScreen({super.key, required this.notify, required this.slug});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProduct(widget.slug);
    searchController.text = widget.slug;

    Slist.add(widget.slug);

    UpdateCart();
  }

  TextEditingController searchController = TextEditingController();
  String pageName = "";
  List Product = [];
  List Slist = [];
  UpdateCart() {
    widget.notify.addListener(() {});
  }

  int loading = 0;
  int count = 0;
  int total = 0;
  int save = 0;

  int currentClick = 0;
  String currentSlug = "";
  List filterOpt = [
    ["New Release", "orderBy=created_at&sortedBy=DESC"],
    ["Low to High Price", "orderBy=min_price&sortedBy=ASC"],
    ["High to Low Price", "orderBy=max_price&sortedBy=DESC"]
  ];

  loadfilter(int current) {
    setState(() {
      currentClick = current;
      Product.clear();
      print("working 1");
    });

    loadProduct(currentSlug);
  }

  loadProduct(String SLUG) async {
    currentSlug = SLUG;
    try {
      final response = await http.get(Uri.parse(
          "$baseurl/products?searchJoin=and&with=type%3Bauthor&${filterOpt[currentClick][1]}&searchFields=variations.slug:in&limit=30&language=en&search=name:$SLUG%3Bstatus:publish"));
      var js = json.decode(response.body);
      setState(() {
        Product.clear();
      });

      if (response.statusCode == 200) {
        if (js["data"] != null) {
          for (var v in js['data']) {
            try {
              setState(() {
                if (v['name'] != null) {
                  Product.add(PopularCard(pdata: v, notifier: widget.notify));
                }
              });
            } on Exception catch (_, e) {}
          }
          setState(() {
            Reloading = false;
            loading = 1;
          });
        }
      } else {
        setState(() {
          loading = 2;
        });
      }
    } catch (e) {
      setState(() {
        loading = 2;
      });
    }
  }

  bool Reloading = false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    String sqty; // convert quantity count to fromatted String model
    if (count < 10)
      sqty = "0$count";
    else
      sqty = count.toString();
    return Scaffold(
        body: (loading == 1)
            ? Container(
                width: w,
                height: h,
                color: Colors.white,
                //  color: primaryColor(),
                child: Stack(
                  children: [
                    Positioned(
                      width: w,
                      height: h,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: 24,
                            ),
                            width: 390,
                            height: 110,
                            color: appprimarycolor,
                            child: Row(
                              children: [
                                width(16),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                                width(10),
                                Expanded(
                                  child: Container(
                                    height: 46,
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: TextField(
                                      controller: searchController,
                                      onSubmitted: (value) {
                                        setState(() {
                                          Reloading = true;
                                          Product = [];
                                        });
                                        loadProduct(value);
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search),
                                          border: InputBorder.none,
                                          hintText: "Search for items in cart",
                                          hintStyle: TextStyle(
                                              color: offsetWhite(),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Montserrat')),
                                    ),
                                  ),
                                ),
                                width(10),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) => Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Container(
                                                width: 390,
                                                padding: EdgeInsets.only(
                                                    left: 25,
                                                    top: 18,
                                                    right: 25),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    .3)))),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Sort Products",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "Montserrat"),
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
                                                                index <
                                                                    filterOpt
                                                                        .length;
                                                                index++)
                                                              InkWell(
                                                                onTap: () {
                                                                  if (currentClick !=
                                                                      index) {
                                                                    setState(
                                                                        () {
                                                                      loadfilter(
                                                                          index);
                                                                    });

                                                                    // loadProduct(
                                                                    //  currentSlug);
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color: (currentClick == index)
                                                                                ? appprimarycolor
                                                                                : null,
                                                                            border:
                                                                                Border.all(color: (currentClick == index) ? appprimarycolor : Colors.black),
                                                                            borderRadius: BorderRadius.circular(30)),
                                                                        child: Text(
                                                                          filterOpt[index]
                                                                              [
                                                                              0],
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: (currentClick == index)
                                                                                ? Colors.white
                                                                                : Colors.black,
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
                                  child: Icon(
                                    Icons.filter_alt_rounded,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                                width(16)
                              ],
                            ),
                          ),
                          if (Product.isNotEmpty)
                            Expanded(
                                child: Container(
                              child: SingleChildScrollView(
                                child: Container(
                                  alignment: (Product.length == 1)
                                      ? Alignment.topLeft
                                      : null,
                                  margin: EdgeInsets.only(
                                      top: 20,
                                      left: (Product.length == 1) ? 25 : 0),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    runSpacing: 0,
                                    spacing: 0,
                                    children: [
                                      for (int i = 0; i < Product.length; i++)
                                        Product[i],
                                      if (count > 0) height(105)
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          if (Reloading && Product.isEmpty && loading == 1)
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.aspectRatio *
                                      800),
                              alignment: Alignment.center,
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: appprimarycolor, size: 40),
                            ),
                          if (Product.isEmpty && !Reloading)
                            noData("Sorry, No Product Found :( ")
                        ],
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                          bottom: 0,
                          width: 390,
                          height: 100,
                          child: Stack(
                            children: [
                              Container(
                                width: 390,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: .05,
                                          blurRadius: 9.2)
                                    ]),
                              ),
                              Positioned(
                                  top: 25,
                                  left: 28,
                                  bottom: 40,
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 40,
                                    color: appprimarycolor,
                                  )),
                              Positioned(
                                  top: 26,
                                  left: 76,
                                  child: Text(
                                    "$sqty items",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat"),
                                  )),
                              Positioned(
                                  top: 26,
                                  left: 151,
                                  child: Text("$total",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: appprimarycolor,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat"))),
                            ],
                          ))
                  ],
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: appprimarycolor, size: 40),
              ));
  }
}
