import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/home/components/categoryCard.dart';
import 'package:http/http.dart' as http;
import '../../../supporter/sizesupporter.dart';

class categoryList extends StatefulWidget {
  String zipCode;
  categoryList({super.key, required this.zipCode});

  @override
  State<categoryList> createState() => _categoryListState();
}

class _categoryListState extends State<categoryList> {
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
      decoration: BoxDecoration(boxShadow: []),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " Categories",
            textAlign: TextAlign.start,
            style: tx600(21, color: Colors.black87),
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
