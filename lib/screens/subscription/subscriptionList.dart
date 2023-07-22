import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/subscription/components/subscriptionlistcard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/colors.dart';
import '../../constant/textstyles.dart';
import '../../supporter/sizesupporter.dart';

class subscriptionList extends StatefulWidget {
  const subscriptionList({super.key});

  @override
  State<subscriptionList> createState() => _subscriptionListState();
}

class _subscriptionListState extends State<subscriptionList> {
  List recurringList = [];
  String token = ""; // "Bearer 461|OHuSsNWN1UnQspN3gp21TUzkbOXw3BvAxUy60qUN";
  ValueNotifier notifier = ValueNotifier(10);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadrecurringoption();
    loadupdater();
  }

  loadupdater() {
    notifier.addListener(() {
      recurringList.clear();
      loadrecurringoption();
    });
  }

  loadrecurringoption() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("TOKEN").toString();
    final response = await http.get(Uri.parse("$baseurl/api/recurring-order"),
        headers: ({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.body);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      for (var data in result["data"]) {
        setState(() {
          recurringList.add(data);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Color.fromARGB(255, 228, 228, 228).withOpacity(.3),
            child: Column(children: [
              Container(
                color: appprimarycolor,
                height: 125,
                padding: EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    width(20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white38,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    width(10),
                    Text(
                      "My Subscription",
                      style: tx600(18, color: Colors.white),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var data in recurringList)
                        subscriptionlistCard(
                          data: data,
                          notifier: notifier,
                        ),
                      height(20)
                    ],
                  ),
                ),
              )
            ])));
  }
}
