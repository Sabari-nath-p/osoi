import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/url.dart';
import 'package:searchfield/searchfield.dart';

import '../constant/colors.dart';
import '../supporter/functionsupporter.dart';
import '../supporter/sizesupporter.dart';
import 'orderCard.dart';

class orderScreen extends StatefulWidget {
  String token;
  orderScreen({super.key, required this.token});

  @override
  State<orderScreen> createState() => _orderScreenState();
}

class _orderScreenState extends State<orderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadOrder();
  }

  List filterOpt = [
    ["Delivered", "delivered"],
    ["Refund", ""],
    ["Return", ""],
    ["Processing", "order-processing"],
    ["Out for Delivery", "out-for-delivery"],
    ["Dispatched", "order-dispatched"]
  ];
  int SelectedOpt = -1;
  List trackingid = [];
  ValueNotifier notifier = ValueNotifier(int);

  startListen() {
    notifier.addListener(() {
      orders.clear();
      loadOrder();
    });
  }

  int loading = 0;
  loadOrder() async {
    final Response = await http.get(Uri.parse("$baseurl/orders?with=refund"),
        headers: ({
          'Accept': 'application/json',
          'Authorization': "Bearer ${widget.token}"
        }));

    if (Response.statusCode == 200) {
      var data = json.decode(Response.body);

      setState(() {
        for (var od in data["data"]) {
          orders.add(od);
          trackingid.add(od["tracking_number"].toString());
        }
        loading = 1;
        fixList = new List.from(orders);
        filteringList = new List.from(orders);
      });
    }
  }

  List fixList = [];
  List orders = [];
  List filteringList = [];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: (loading == 1)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        height: 114,
                        width: double.infinity,
                        color: appprimarycolor,
                        child: Row(
                          children: [
                            width(17),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.withOpacity(.2),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            width(17),
                            Text(
                              "My Orders",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                height(20),
                                Row(
                                  children: [
                                    Container(
                                      width: 290,
                                      height: 50,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          width(10),
                                          Icon(
                                            Icons.search_sharp,
                                            color: Colors.grey,
                                          ),
                                          width(5),
                                          Expanded(
                                              child: Container(
                                            height: 50,
                                            margin: EdgeInsets.only(right: 20),
                                            alignment: Alignment.center,
                                            child: SearchField(
                                              controller: searchController,
                                              hint: "Tracking Number",
                                              inputType: TextInputType.number,
                                              suggestions: trackingid
                                                  .map(
                                                    (e) => SearchFieldListItem(
                                                      e,
                                                      item: e,
                                                    ),
                                                  )
                                                  .toList(),
                                              searchInputDecoration:
                                                  InputDecoration(
                                                      border: InputBorder.none),
                                              suggestionState:
                                                  Suggestion.hidden,
                                              maxSuggestionsInViewPort: 2,
                                              onSubmit: (p0) {
                                                orders.clear();
                                                if (p0 != "") {
                                                  for (int i = 0;
                                                      i < fixList.length;
                                                      i++) {
                                                    if (p0 ==
                                                        fixList[i][
                                                                "tracking_number"]
                                                            .toString()) {
                                                      orders.add(fixList[i]);
                                                    }
                                                  }
                                                } else {
                                                  orders =
                                                      new List.from(fixList);
                                                }
                                              },
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        filterOption();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Icon(
                                          Icons.line_axis,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    width(8)
                                  ],
                                ),
                                height(10),
                                if (orders.isNotEmpty && loading == 1)
                                  for (int i = 0; i < orders.length; i++)
                                    orderCard(
                                      data: orders[i],
                                      notifier: notifier,
                                    ),
                                if (orders.isEmpty && loading == 1)
                                  noData(
                                      "Sorry, you didn't purchased any downloadable products yet."),
                                height(10),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: appprimarycolor, size: 40),
                )),
    );
  }

  filterOption() {
    int currentClick = SelectedOpt;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return InkWell(
              onTap: () {
                setState;
              },
              child: Container(
                height: 270,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Container(
                      width: 390,
                      padding: EdgeInsets.only(left: 25, top: 18, right: 25),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(.3)))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Filter",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat"),
                          ),
                          height(7),
                          Text(
                            "Order Status",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
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
                                        setState(() {
                                          if (currentClick == index)
                                            currentClick = -1;
                                          else
                                            currentClick = index;
                                        });
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: (currentClick == index)
                                                      ? appprimarycolor
                                                      : Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(
                                            filterOpt[index][0],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: (currentClick == index)
                                                  ? appprimarycolor
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (() {
                            Navigator.pop(context);
                          }),
                          child: Container(
                            width: 180,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(
                              () {
                                SelectedOpt = currentClick;
                                loadFilter();
                              },
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 140,
                            height: 42,
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: appprimarycolor,
                                borderRadius: BorderRadius.circular(40)),
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }));
        });
  }

  loadFilter() {
    fixList = [];
    setState(() {
      if (SelectedOpt > -1) {
        for (int i = 0; i < filteringList.length; i++) {
          if (filterOpt[SelectedOpt][1] == filteringList[i]["status"]["slug"]) {
            fixList.add(filteringList[i]);
          }

          if (SelectedOpt == 1 &&
              filteringList[i]["refund"].toString() != "null") {
            fixList.add(filteringList[i]);
          }
          if (filteringList[i]["refund"].toString() != "null") {
            if (SelectedOpt == 2 &&
                filteringList[i]["refund"]["status"] == "approved") {
              fixList.add(filteringList[i]);
            }
          }
        }
        orders = new List.from(fixList);
      } else {
        fixList = new List.from(filteringList);
        orders = new List.from(fixList);
      }
    });
  }
}
