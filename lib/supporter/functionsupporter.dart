import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/supporter/sizesupporter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/url.dart';
import '../datamodel/adressData.dart';
import '../datamodel/userData.dart';
import '../test/myAddress.dart';
import 'package:http/http.dart' as http;

noData(String Message) {
  return Stack(
    children: [
      Container(
          height: 600,
          width: 300,
          alignment: Alignment.center,
          child: Image.network(
            "http://shop.osoi.alpha.logidots.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fno-product2.9db93fa9.png&w=640&q=75",
          )),
      Positioned(
        top: 390,
        left: 30,
        right: 30,
        child: Text(
          Message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "Monsterrat",
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600),
        ),
      )
    ],
  );
}

FetchUserData(String token, ValueNotifier notify) async {
  Box user = await Hive.openBox("user");

  final response = await http.get(Uri.parse("$baseurl/me"),
      headers: ({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }));

  if (response.statusCode == 200) {
    var js = json.decode(response.body);
    List<addressData> adata = [];
    for (var address in js["address"]) {
      addressData ad = addressData(
          address: (address["address"]["street_address"] != null)
              ? address["address"]["street_address"]
              : "test address",
          city: address["address"]["city"],
          country: address["address"]["country"],
          details: "nil",
          state: address["address"]["state"],
          zip: address["address"]["zip"],
          title: address["title"],
          id: address["id"]);
      adata.add(ad);
    }
    newAdata = adata;
    String profileUrl =
        "https://www.oseyo.co.uk/wp-content/uploads/2020/05/empty-profile-picture-png-2.png";

    if (js["profile"]["avatar"] != null)
      profileUrl = js["profile"]["avatar"]["thumbnail"];
    userData ud = user.get(1);
    userData udata = new userData(
        name: js["name"],
        email: js["email"],
        id: js['id'],
        phone: ud.phone,
        address: adata,
        profileUrl: profileUrl,
        availablePoint: js["wallet"]["available_points"]);

    user.put(1, udata);
    user.close();
    notify.value++;
  }
}

TextEditingController title = TextEditingController();
TextEditingController country = TextEditingController();
TextEditingController state = TextEditingController();
TextEditingController city = TextEditingController();
TextEditingController zip = TextEditingController();
TextEditingController address = TextEditingController();
setAdress(
  BuildContext context,
  ValueNotifier addressNotify,
) async {
  title.text = "";
  country.text = "India";
  state.text = "Kerala";
  city.text = "";
  zip.text = "";
  address.text = "";
  Box user = await Hive.openBox("user");
  userData udata = user.get(1);

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: 390,
              height: 470,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(10),
                    Row(children: [
                      SizedBox(
                          height: 50,
                          width: 40,
                          child: Image.asset("assets/image/mapIcon.JPG")),
                      width(8),
                      Text(
                        "Shipping Address",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                    Text("  Enter delivery address",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            fontWeight: FontWeight.w400)),
                    height(12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black26.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: title,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Title"),
                      ),
                    ),
                    height(12),
                    Row(
                      children: [
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: country,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Country"),
                          ),
                        ),
                        width(20),
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: state,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "State"),
                          ),
                        ),
                      ],
                    ),
                    height(12),
                    Row(
                      children: [
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: city,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "City"),
                          ),
                        ),
                        width(20),
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: zip,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Zip"),
                          ),
                        ),
                      ],
                    ),
                    height(12),
                    Container(
                      height: 115,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black26.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: address,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Street Address"),
                      ),
                    ),
                    height(25),
                    InkWell(
                      onTap: () async {
                        if (title.text.trim() != "" &&
                            country.text.trim() != "" &&
                            state.text.trim() != "" &&
                            city.text.trim() != "" &&
                            zip.text.trim() != "" &&
                            address.text.trim() != "") {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();

                          String token =
                              preferences.getString("TOKEN").toString();
                          final Response = await http.put(
                              Uri.parse("$baseurl/users/${udata.id}"),
                              headers: ({
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $token'
                              }),
                              body: json.encode({
                                "address": [
                                  {
                                    "title": title.text.trim(),
                                    "type": "Shipping",
                                    "default": true,
                                    "address": {
                                      "country": country.text.trim(),
                                      "state": state.text.trim(),
                                      "zip": zip.text.trim(),
                                      "city": city.text.trim(),
                                      "street_address": address.text.trim()
                                    }
                                  }
                                ]
                              }));

                          if (Response.statusCode == 200) {
                            Navigator.of(context).pop();
                            FetchUserData(token, addressNotify);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please fill all data to continue");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: appprimarycolor,
                            borderRadius: BorderRadius.circular(70)),
                        child: Text("Set Location",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: "Montserrat")),
                      ),
                    ),
                    height(25)
                  ],
                ),
              ),
            ),
          ));
}

editAddress(BuildContext context, ValueNotifier addressNotify,
    addressData adata) async {
  title.text = adata.title;
  country.text = adata.country;
  state.text = adata.state;
  city.text = adata.city;
  zip.text = adata.zip;
  address.text = adata.address;
  Box user = await Hive.openBox("user");
  userData udata = user.get(1);
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: double.infinity,
              height: 470,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(10),
                    Row(children: [
                      SizedBox(
                          height: 50,
                          width: 40,
                          child: Image.asset("assets/image/mapIcon.JPG")),
                      width(8),
                      Text(
                        "Shipping Address",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                    Text("  Enter delivery address",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 13,
                            fontWeight: FontWeight.w400)),
                    height(12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black26.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: title,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Title"),
                      ),
                    ),
                    height(12),
                    Row(
                      children: [
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: country,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Country"),
                          ),
                        ),
                        width(20),
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: state,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "State"),
                          ),
                        ),
                      ],
                    ),
                    height(12),
                    Row(
                      children: [
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: city,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "City"),
                          ),
                        ),
                        width(20),
                        Container(
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black26.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: zip,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Zip"),
                          ),
                        ),
                      ],
                    ),
                    height(12),
                    Container(
                      height: 115,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black26.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: address,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Street Address"),
                      ),
                    ),
                    height(25),
                    InkWell(
                      onTap: () async {
                        if (title.text.trim() != "" &&
                            country.text.trim() != "" &&
                            state.text.trim() != "" &&
                            city.text.trim() != "" &&
                            zip.text.trim() != "" &&
                            address.text.trim() != "") {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();

                          String token =
                              preferences.getString("TOKEN").toString();
                          final Response = await http.put(
                              Uri.parse(
                                  "https://api.ecom.alpha.logidots.com/users/${udata.id}"),
                              headers: ({
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $token'
                              }),
                              body: json.encode({
                                "id": udata.id,
                                "address": [
                                  {
                                    "id": adata.id,
                                    "title": title.text.trim(),
                                    "type": "Shipping",
                                    "default": true,
                                    "address": {
                                      "country": country.text.trim(),
                                      "state": state.text.trim(),
                                      "zip": zip.text.trim(),
                                      "city": city.text.trim(),
                                      "street_address": address.text.trim()
                                    }
                                  }
                                ]
                              }));

                          if (Response.statusCode == 200) {
                            Navigator.of(context).pop();
                            FetchUserData(token, addressNotify);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please fill all data to continue");
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: appprimarycolor,
                            borderRadius: BorderRadius.circular(70)),
                        child: Text("Update Location",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: "Montserrat")),
                      ),
                    ),
                    height(25)
                  ],
                ),
              ),
            ),
          ));
}

deleteAddress(BuildContext context, addressData adata,
    ValueNotifier addressNotifier) async {
  Box user = await Hive.openBox("user");
  userData udata = user.get(1);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString("TOKEN").toString();
  final Response = await http.delete(
    Uri.parse("https://api.ecom.alpha.logidots.com/address/${adata.id}"),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (Response.statusCode == 200) {
    FetchUserData(token, addressNotifier);
  }
}
