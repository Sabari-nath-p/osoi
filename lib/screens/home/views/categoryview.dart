import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../constant/textstyles.dart';
import '../../../constant/url.dart';
import '../../../supporter/sizesupporter.dart';
import '../components/categoryCard.dart';
import 'package:http/http.dart' as http;

class categoryview extends StatefulWidget {
  String zipCode;
  categoryview({super.key, required this.zipCode});

  @override
  State<categoryview> createState() => _categoryviewState();
}

class _categoryviewState extends State<categoryview> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCategoryData();
  }

  List CatList = [];

  loadCategoryData() async {
    final Response = await http.get(
      Uri.parse(
          "${baseurl}/categories?limit=1000&language=en&parent=null&location=${widget.zipCode}"),
    );

    if (Response.statusCode == 200) {
      setState(() {
        var catData = json.decode(Response.body);
        for (var data in catData["data"]) {
          CatList.add(data);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: density(390),

      //  color: Color.fromARGB(175, 255, 255, 255),
      padding: EdgeInsets.only(
          left: density(16),
          right: density(10),
          top: density(8),
          bottom: density(21)),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            child: Row(children: [
              SizedBox(
                width: 16,
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  "assets/images/logo.JPG",
                  fit: BoxFit.cover,
                ),
              ),
              width(5),
              SizedBox(
                width: 110,
                height: 50,
                child: Image.asset(
                  "assets/images/namelogo.JPG",
                ),
              ),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              " Categories ",
              textAlign: TextAlign.start,
              style: tx600(21, color: Colors.black87),
            ),
          ),
          height(density(5)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            alignment: Alignment.center,
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                for (var data in CatList)
                  CategoryCard(
                    catData: data,
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  double density(
    double d,
  ) {
    double width = MediaQuery.of(context).size.width;
    double value = d * (width / 390);
    return value;
  }
}
