import 'package:flutter/material.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:searchfield/searchfield.dart';
import '../../../constant/colors.dart';
import '../../../constant/textstyles.dart';
import '../../../supporter/sizesupporter.dart';

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
                                            padding: EdgeInsets.only(left: 10),
                                            child:
                                                Text(e.replaceAll("null", ""))),
                                      ),
                                    )
                                    .toList(),
                                searchStyle: tx500(15, color: appprimarycolor),
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
                          Navigator.pop(context);
                          notifier.value++;
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
