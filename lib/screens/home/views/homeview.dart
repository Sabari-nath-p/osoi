import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:oso/screens/categoryview/categorycardList.dart';
import 'package:oso/screens/home/components/categorBox.dart';
import 'package:oso/screens/home/components/popularbox.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/screens/productDetails/productMain.dart';
import 'package:oso/supporter/sizesupporter.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:searchfield/searchfield.dart';
import '../../../constant/colors.dart';
import '../../../constant/textstyles.dart';
import '../../../constant/url.dart';
import '../../search/searchScreen.dart';
import '../homemain.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  String selectedZip;
  ValueNotifier notifier;
  List<String> zipName;
  HomeView(
      {super.key,
      required this.selectedZip,
      required this.notifier,
      required this.zipName});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List promoImage = [];

  configData() async {
    final Response =
        await http.get(Uri.parse("$baseurl/types/osoi?language=en"),
            headers: ({
              "access-control-allow-origin": "*",
              "cache-control": "no-cache",
              "content-encoding": "gzip",
              "content-type": "application/json",
            }));

    if (Response.statusCode == 200) {
      var result = json.decode(Response.body);
      for (var data in result["banners"]) {
        setState(() {
          promoImage.add(Image.network(
            data["image"]["original"],
            fit: BoxFit.cover,
          ));
        });
      }
    }
  }

  locationSelector(
    BuildContext context,
    List<String> zipcode,
    TextEditingController selectedString,
    ValueNotifier notifier,
  ) {
    List<SearchFieldListItem> Searchitem = [
      SearchFieldListItem("Name", child: Text("name"))
    ];
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 300,
                    height: 400,
                    margin: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 2),
                              color: Colors.grey.withOpacity(.7))
                        ]),
                    child: Column(
                      children: [
                        SizedBox(
                            width: 100,
                            child: Image.asset(
                              "assets/images/splash_icon.png",
                            )),
                        height(18),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 41),
                          child: Text(
                            "Welcome to Our Street of India",
                            style: tx700(14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        height(10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Please provide your delivery location to see product at nearby store",
                            style: tx500(
                              11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        height(10),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1, .9),
                                    color: Colors.grey.withOpacity(.4),
                                    blurRadius: .7,
                                    spreadRadius: .2),
                              ]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              width(5),
                              Expanded(
                                child: SearchField(
                                  controller: selectedString,
                                  suggestions: zipcode
                                      .map(
                                        (e) => SearchFieldListItem(
                                          e,
                                          item: e,
                                          // Use child to show Custom Widgets in the suggestions
                                          // defaults to Text widget
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(e)),
                                        ),
                                      )
                                      .toList(),
                                  searchStyle:
                                      tx500(15, color: appprimarycolor),
                                  searchInputDecoration: InputDecoration(
                                      hintText: "Select you location",
                                      border: InputBorder.none,
                                      isDense: true),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: appprimarycolor,
                                size: 28,
                              ),
                              width(5)
                            ],
                          ),
                        ),
                        height(20),
                        Text(
                          "Set Location Automatically",
                          style:
                              tx600(12, color: appprimarycolor.withOpacity(.8)),
                        ),
                        height(10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              locCOntroller.text = selectedString.text;
                              Navigator.pop(context);
                              notifier.value++;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: appprimarycolor),
                            child: Text(
                              "Set Location",
                              style: tx600(14.5, color: appcolorBackground),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  startLister() {
    widget.notifier.addListener(() {
      setState(() {});
    });
  }

  List suggestion = [];
  TextEditingController searchTextController = TextEditingController();
  loadsuggestion(List list) {
    setState(() {
      suggestion = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configData();
    startLister();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: w,
              height: h - 64,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    width: w,
                    height: h - 64,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                "assets/images/logo.JPG",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              height: 30,
                              child: Image.asset(
                                "assets/images/namelogo.JPG",
                              ),
                            ),
                            Expanded(child: Container()),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  locationSelector(context, widget.zipName,
                                      SelectedZip, widget.notifier);
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white.withOpacity(.9),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, .9),
                                          color: Colors.grey.withOpacity(.4),
                                          blurRadius: .7,
                                          spreadRadius: .2),
                                    ]),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    width(10),
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: appprimarycolor,
                                    ),
                                    Text("${SelectedZip.text.split(" ")[0]}"),
                                    width(30),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            width(20)
                          ],
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        Container(
                          width: 358,
                          height: 48,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: Color(0XFFEEECEC),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.7,
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 20.7,
                              ),
                              height(20),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  child: TypeAheadField(
                                    minCharsForSuggestions: 2,
                                    textFieldConfiguration: TextFieldConfiguration(
                                        controller: searchTextController,
                                        decoration: InputDecoration(
                                            hintText:
                                                "Search (type atleast 2 letter)",
                                            border: InputBorder.none,
                                            isDense: true,
                                            isCollapsed: true)),
                                    suggestionsCallback: (pattern) async {
                                      List<searchProduct> prd = [];

                                      final Response = await http.get(
                                          Uri.parse(
                                              "$baseurl/products?searchJoin=and&with=type%3Bauthor&limit=5&language=en&search=name:$pattern%3Bshop.service_locations.zip_code:${SelectedZip.text.split(" ")[0]}%3Bstatus:publish"),
                                          headers: ({
                                            "access-control-allow-origin": "*",
                                            "cache-control": "no-cache",
                                            "content-encoding": "gzip",
                                            "content-type": "application/json",
                                          }));
                                      if (Response.statusCode == 200) {
                                        var js = json.decode(Response.body);
                                        for (var ds in js["data"]) {
                                          prd.add(searchProduct.fromJson(ds));
                                        }

                                        print(prd);
                                      }
                                      loadsuggestion(prd);
                                      return prd;
                                    },
                                    itemBuilder: (context, itemData) =>
                                        Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          productMain(
                                                              slug: itemData
                                                                  .slug
                                                                  .toString(),
                                                              notify:
                                                                  notifier)));
                                            },
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.network(itemData
                                                      .imageurl
                                                      .toString()),
                                                ),
                                                width(10),
                                                Expanded(
                                                  child: Text(
                                                    itemData.name.toString(),
                                                    maxLines: null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (suggestion.indexOf(itemData) + 2 >
                                              suggestion.length)
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            searchScreen(
                                                              notify: notifier,
                                                              slug:
                                                                  searchTextController
                                                                      .text,
                                                            )));
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  "Show more",
                                                  style: tx600(16,
                                                      color: appprimarycolor),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    onSuggestionSelected: (selected) {},
                                  ),
                                ),
                              ),
                              width(10)
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: .3, left: 1, right: 1),
                          decoration: BoxDecoration(
                              color: Colors
                                  .white, //Color.fromARGB(241, 255, 255, 255),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (promoImage.length > 1)
                                  Container(
                                    height: 150,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 12,
                                        bottom: 7),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: ImageSlideshow(
                                          indicatorColor: appprimarycolor,
                                          isLoop: true,
                                          autoPlayInterval: 3000,
                                          children: [
                                            for (int i = 1;
                                                i < promoImage.length;
                                                i++)
                                              promoImage[i]
                                          ],
                                        )),
                                  ),
                                height(6),
                                if (widget.selectedZip != "")
                                  categoryList(
                                    zipCode: widget.selectedZip,
                                  ),
                                if (widget.selectedZip != "")
                                  PopularBox(
                                    zipCode: widget.selectedZip,
                                    notifier: widget.notifier,
                                  ),
                                //     notify: notify,
                                //    ),
                                height(6),
                                if (promoImage.length > 0)
                                  Container(
                                    width: 390,
                                    height: 195,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: promoImage[0],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class searchProduct {
  String? name;
  String? imageurl;
  String? slug;
  var data;
  searchProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json["slug"];
    imageurl =
        (json["image"].isNotEmpty) ? json["image"]["thumbnail"] : noimage;
  }
}
