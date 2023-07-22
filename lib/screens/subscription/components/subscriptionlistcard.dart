import 'package:flutter/material.dart';
import 'package:oso/screens/categoryview/categorycardList.dart';
import 'package:oso/screens/subscription/subscriptionMain.dart';

import '../../../constant/textstyles.dart';
import '../../../supporter/sizesupporter.dart';

class subscriptionlistCard extends StatefulWidget {
  var data;
  ValueNotifier notifier;
  subscriptionlistCard({super.key, required this.data, required this.notifier});

  @override
  State<subscriptionlistCard> createState() =>
      _subscriptionlistCardState(data: data);
}

class _subscriptionlistCardState extends State<subscriptionlistCard> {
  var data;
  _subscriptionlistCardState({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => subscriptionMain(
                  data: data,
                  notifier: widget.notifier,
                )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: double.infinity,
        height: 157,
        child: Stack(
          children: [
            Positioned(
                top: 6,
                right: 10,
                child: Container(
                  width: 160,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: (data["status"] == "active")
                          ? Color(0xffDFE9FD)
                          : Color(0xffFDDFDF)),
                )),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  "assets/images/subscriptionCard.png",
                  fit: BoxFit.fill,
                )),
            Positioned(
                top: 20,
                left: 20,
                child: Text(
                  "#${data["id"]}",
                  style: tx600(14, color: Colors.black),
                )),
            Positioned(
                top: 10,
                right: 10,
                child: Container(
                  alignment: Alignment.center,
                  width: 77,
                  child: Text(
                    (data["status"] == "active") ? "Active" : "Cancel",
                    style: tx600(10,
                        color: (data["status"] == "active")
                            ? Colors.blue
                            : Color(0xffEC6345)),
                  ),
                )),
            Positioned(
                top: 50,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      "Subscription Type :  ",
                      style: tx600(12, color: Colors.grey.withOpacity(.7)),
                    ),
                    Text(
                      (data["items"][0]["meta_data"] != null)
                          ? "${data["items"][0]["meta_data"]["payment_frequency"]["name"]}"
                          : "unknown",
                      style: tx600(12, color: Colors.black),
                    )
                  ],
                )),
            Positioned(
                top: 80,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      "Total ",
                      style: tx600(12, color: Colors.grey.withOpacity(.7)),
                    ),
                    width(84.5),
                    Text(
                      ":  \$ ${data["total"]}",
                      style: tx600(12, color: Colors.black),
                    )
                  ],
                )),
            Positioned(
                top: 110,
                left: 20,
                child: Row(
                  children: [
                    Text(
                      "Order Date",
                      style: tx600(12, color: Colors.grey.withOpacity(.7)),
                    ),
                    width(48),
                    Text(
                      ":  ${data["created_at"].toString().split("T")[0]}",
                      style: tx600(12, color: Colors.black),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
