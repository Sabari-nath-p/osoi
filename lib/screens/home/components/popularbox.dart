import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oso/Converter/verify.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/home/components/popularCard.dart';
import 'package:http/http.dart' as http;
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/screens/productDetails/productMain.dart';
import 'package:oso/supporter/functionsupporter.dart';
import '../../../supporter/sizesupporter.dart';
import '../../categoryview/categorycardList.dart';

class PopularBox extends StatefulWidget {
  String zipCode;
  ValueNotifier notifier;
  PopularBox({super.key, required this.zipCode, required this.notifier});

  @override
  State<PopularBox> createState() => _PopularBoxState();
}

List flashList = [];

class _PopularBoxState extends State<PopularBox> {
  @override
  void initState() {
    // TODO: implement initState

    loadPopularProduct(widget.zipCode);
    startListerner();
  }

  startListerner() {
    print("working popular product");
    setState(() {
      flashList.clear();
      loadPopularProduct(locCOntroller.text.split(" ")[0]);
    });
    widget.notifier.addListener(() {
      print("propular product updated");
      print("this");
      setState(() {
        flashList.clear();
        print(locCOntroller.text);
        loadPopularProduct(locCOntroller.text.split(" ")[0]);
      });
    });
  }

  loadPopularProduct(String loc) async {
    final Response = await http.get(Uri.parse(
        "${baseurl}/products?searchJoin=and&with=type%3Bauthor&limit=30&language=en&search=shop.service_locations.zip_code:$loc%3Bstatus:publish"));
    flashList.clear();
    if (Response.statusCode == 200) {
      var ppData = json.decode(Response.body);
      setState(() {
        for (var data in ppData["data"]) flashList.add(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: density(390),
      height: density(320),
      padding: EdgeInsets.only(
          left: density(13),
          right: density(13),
          top: density(8),
          bottom: density(18)),
      //  color: Color.fromARGB(175, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " Popular Products",
            style: tx600(21, color: Colors.black87),
          ),
          height(density(11)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                width(density(8)),
                //   if (flashList.length > 0)
                for (var pdata in flashList)
                  catergoryCard(
                    pdata: pdata,
                    // notifier: widget.notifier,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  double density(double d) {
    double width = MediaQuery.of(context).size.width;
    double value = d * (width / 390);
    return value;
  }
}
