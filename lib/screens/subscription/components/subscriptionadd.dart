import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/Converter/addsubscription.dart';
import 'package:oso/Converter/verify.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/supporter/sizesupporter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class addsubscriptionupdate extends StatefulWidget {
  String id;
  String subId;
  String shippingId;
  String paymentFrequency;
  ValueNotifier notifier;
  addsubscriptionupdate(
      {super.key,
      required this.id,
      required this.paymentFrequency,
      required this.shippingId,
      required this.subId,
      required this.notifier});

  @override
  State<addsubscriptionupdate> createState() => _addsubscriptionupdateState();
}

class _addsubscriptionupdateState extends State<addsubscriptionupdate> {
  List searchProducts = [];
  List<Products> newProductList = [];
  TextEditingController textcontroller = TextEditingController();
  searchProduct(String searchText) async {
//https://api.osoi.alpha.logidots.com/
    final Respones = await http.get(Uri.parse(
        "$baseurl/products?searchJoin=and&with=type%3Bauthor&limit=30&language=en&search=name:$searchText%3Bshop_id:${widget.id}%3Bdelivery_types.name:shipping%3Bstatus:publish"));
    print(Respones.body);
    if (Respones.statusCode == 200) {
      var js = json.decode(Respones.body);
      setState(() {
        for (var data in js["data"]) searchProducts.add(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "   Add Product",
            style: tx600(16, color: Colors.black),
          ),
          height(20),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey)),
            child: Row(
              children: [
                width(20),
                Icon(Icons.search),
                width(5),
                Expanded(
                  child: TextField(
                    controller: textcontroller,
                    style: tx600(16, color: Colors.black),
                    onChanged: (value) {
                      if (value != "") {
                        setState(() {
                          searchProducts.clear();
                        });
                        searchProduct(value);
                      } else
                        print("empty");
                    },
                    decoration: InputDecoration(
                        isCollapsed: true,
                        isDense: true,
                        hintText: "Search Product",
                        hintStyle: tx500(16, color: Colors.black),
                        border: InputBorder.none),
                  ),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        textcontroller.text = "";
                      });
                    },
                    child: Icon(Icons.close)),
                width(10)
              ],
            ),
          ),
          if (textcontroller.text.isNotEmpty)
            Container(
              height: 200,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var pdata in searchProducts) productList(pdata)
                  ],
                ),
              ),
            ),
          height(20),
          for (var pdata in newProductList) plistCard(pdata),
          if (newProductList.isNotEmpty)
            InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => Container(
                          alignment: Alignment.center,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: appprimarycolor,
                            size: 40,
                          ),
                        ));
                List prd = [];
                SharedPreferences pref = await SharedPreferences.getInstance();
                String token = pref.getString("TOKEN").toString();
                AddSubscriptionModel model = AddSubscriptionModel();
                model.products = newProductList;
                model.subscriptionId = widget.subId;
                // print(prd);
                print(model.toJson());
                final Response = await http.post(
                    Uri.parse("$baseurl/api/recurring-order/add-product"),
                    body: json.encode(
                      model.toJson(),
                    ),
                    headers: ({
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $token',
                      'content-type': 'application/json; charset=utf-8',
                    }));

                print(Response.body);
                if (Response.statusCode == 200) {
                  widget.notifier.value++;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: appprimarycolor),
                  child: Text(
                    "Add Product",
                    style: tx500(15, color: Colors.white),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  productList(var pdata) {
    return InkWell(
      onTap: () {
        Products prd = Products(
            productId: pdata["id"],
            orderQuantity: 1,
            paymentFrequency: int.parse(widget.shippingId),
            name: pdata["name"],
            deliveryType: widget.paymentFrequency,
            imgurl: (pdata["image"].isEmpty)
                ? noimage
                : pdata["image"]["thumbnail"],
            unitPrice: pdata["price"],
            subtotal: pdata["price"]);
        setState(() {
          newProductList.add(prd);
          textcontroller.text = "";
        });
      },
      child: Row(
        children: [
          width(16),
          SizedBox(
            height: 60,
            width: 60,
            child: Image.network((pdata["image"].isEmpty)
                ? noimage
                : pdata["image"]["thumbnail"]),
          ),
          width(5),
          Expanded(child: Text(pdata["name"])),
          width(5),
          width(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$ ${pdata["price"]}",
                style: tx600(15, color: Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }

  plistCard(Products pdata) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: [
          width(16),
          SizedBox(
            height: 60,
            width: 60,
            child: Image.network(pdata.imgurl!),
          ),
          width(5),
          Expanded(child: Text(pdata.name!)),
          width(5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black45)),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        if (pdata.orderQuantity! > 1)
                          pdata.orderQuantity = pdata.orderQuantity! - 1;
                        else {
                          newProductList.remove(pdata);
                        }
                      });
                    },
                    child: Icon(Icons.remove)),
                width(5),
                Text(
                  pdata.orderQuantity.toString(),
                  style: tx700(16),
                ),
                width(5),
                InkWell(
                    onTap: () {
                      setState(() {
                        pdata.orderQuantity = pdata.orderQuantity! + 1;
                      });
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ),
          width(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$ ${pdata.unitPrice! * pdata.orderQuantity!}",
                style: tx600(15, color: Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }
}
