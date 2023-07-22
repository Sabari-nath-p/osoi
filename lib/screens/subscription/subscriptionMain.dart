import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/categoryview/categorycardList.dart';
import 'package:oso/screens/subscription/components/updatesubscription.dart';
import 'package:oso/supporter/sizesupporter.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/subscriptionadd.dart';

class subscriptionMain extends StatefulWidget {
  var data;
  ValueNotifier notifier;
  subscriptionMain({super.key, required this.data, required this.notifier});

  @override
  State<subscriptionMain> createState() => _subscriptionMainState(data: data);
}

class _subscriptionMainState extends State<subscriptionMain> {
  var data;
  _subscriptionMainState({required this.data});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSubscription();
    loadnotifyer();
  }

  loadnotifyer() {
    widget.notifier.addListener(() {
      print("working");
      loadSubscription();
    });
  }

  loadSubscription() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("TOKEN").toString();
    final Response = await http.get(
        Uri.parse(
            "$baseurl/api/recurring-order?search=subscription_id:${data["subscription_id"]}"),
        headers: ({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (Response.statusCode == 200) ;
    var ds = json.decode(Response.body);
    print(ds);
    setState(() {
      data = ds["data"][0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 228, 228, 228).withOpacity(.3),
        child: Column(
          children: [
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
                children: [
                  Container(
                    height: 67,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(.4)))),
                    child: Row(
                      children: [
                        width(20),
                        Text(
                          "Subscription ID  :",
                          style: tx500(13, color: Colors.grey.withOpacity(1)),
                        ),
                        width(10),
                        Expanded(
                          child: SizedBox(
                            height: 25,
                            child: Text(
                              data["subscription_id"],
                              style: tx700(13, color: Colors.black),
                              softWrap: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (data["status"] == "active")
                    Container(
                      height: 76,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: "Are you sure ?",
                                  text: "want to cancel Subscription",
                                  onConfirmBtnTap: () async {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (context) => Container(
                                              alignment: Alignment.center,
                                              child: LoadingAnimationWidget
                                                  .staggeredDotsWave(
                                                color: appprimarycolor,
                                                size: 40,
                                              ),
                                            ));
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    String token =
                                        pref.getString("TOKEN").toString();
                                    final response = await http.post(
                                        Uri.parse(
                                            "$baseurl/api/cancel-subscription"),
                                        body: ({
                                          "subscription_id":
                                              "${data["subscription_id"].toString()}"
                                        }),
                                        headers: ({
                                          'Accept': 'application/json',
                                          'Authorization': 'Bearer $token',
                                        }));
                                    print(response.body);
                                    print(response.statusCode);
                                    if (response.statusCode == 200) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      widget.notifier.value++;
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text:
                                              "Your Subscription has been Canceled");
                                    }
                                  });
                            },
                            child: Text(
                              "Cancel ",
                              style: tx500(17, color: Colors.redAccent),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              updateProduct();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: appprimarycolor),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                "Update Product",
                                style: tx500(15, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  height(8),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shipping Address",
                          style: tx600(16, color: Colors.black),
                        ),
                        height(5),
                        Text(
                          "${data["shipping_address"]["street_address"]} ${data["shipping_address"]["city"]} ${data["shipping_address"]["state"]} ,${data["shipping_address"]["zip"]} ,${data["shipping_address"]["country"]} ",
                          style: tx500(13, color: Colors.black),
                        ),
                        height(15),
                        Text(
                          "Billing Address",
                          style: tx600(16, color: Colors.black),
                        ),
                        height(5),
                        Text(
                          "${data["billing_address"]["street_address"]} ${data["billing_address"]["city"]} ${data["billing_address"]["state"]} ,${data["billing_address"]["zip"]} ,${data["billing_address"]["country"]} ",
                          style: tx500(13, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  height(8),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Details",
                          style: tx600(16, color: Colors.black),
                        ),
                        height(5),
                        paymentBox("Item Total", "\$${data["amount"]}"),
                        paymentBox("Partment Delivery Charge",
                            "\$${data["delivery_fee"]}"),
                        paymentBox("Discount", "\$${data["discount"]}"),
                        Container(
                          width: 390,
                          height: 35,
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          padding: EdgeInsets.only(left: 0, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                ),
                              )),
                              Text(
                                "\$${data["paid_total"]}",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  height(8),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "    Order Items",
                          style: tx600(16, color: Colors.black),
                        ),
                        height(10),
                        if (data["items"] != null)
                          for (var pdata in data["items"]) orderItems(pdata),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  paymentBox(String data1, String data2) {
    return Container(
      width: 390,
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 1),
      padding: EdgeInsets.only(left: 0, right: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            data1,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
            ),
          )),
          Text(
            data2,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
            ),
          )
        ],
      ),
    );
  }

  orderItems(var pdata) {
    num aprice = 0;

    if (pdata["product"]["price"] != null)
      // num aprice = int.parse(pdata["pivot"]["order_quantity"]) * pdata["price"];
      return Container(
        width: density(390),
        height: density(102),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
        child: Row(
          children: [
            width(density(20)),
            SizedBox(
                width: density(70),
                height: density(70),
                child: Image.network(pdata["product"]["image"]["thumbnail"])),
            width(density(8)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(density(20)),
                Expanded(
                  flex: 1,
                  child: Text(
                    pdata["product"]["name"],
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    pdata["product"]["unit"],
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                height(density(20)),
              ],
            )),
            Container(
              width: 39,
              height: 39,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: appprimarycolor)),
              child: Text(
                double.parse(pdata["order_quantity"].toString())
                    .round()
                    .toString(),
                softWrap: true,
                style: TextStyle(
                  color: appprimarycolor,
                  fontFamily: "Montserrat",
                  fontSize: density(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            width(density(20)),
            SizedBox(
              width: density(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${pdata["subtotal"].toString()}",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(17),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  /*     Text(
                  "\$$aprice",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(12),
                      color: appprimarycolor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough),
                )*/
                ],
              ),
            ),
            width(density(10)),
          ],
        ),
      );
  }

  updateProduct() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                //  height: 400,
                constraints: BoxConstraints(maxHeight: 800, minHeight: 400),
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Color(0xffF8F8F8),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(20),
                      Text("      Products",
                          style: tx600(18, color: Colors.black)),
                      height(20),
                      for (var pdata in data["items"])
                        subscriptionUpdateCard(
                          pdata: pdata,
                          totalCount: data["items"].length,
                          subscriptionId: data["subscription_id"],
                          notifier: widget.notifier,
                        ),
                      addsubscriptionupdate(
                        id: data["items"][0]["product"]["shop_id"].toString(),
                        subId: data["subscription_id"],
                        notifier: widget.notifier,
                        paymentFrequency:
                            data["items"][0]["delivery_type"].toString(),
                        shippingId:
                            data["items"][0]["payment_frequency"].toString(),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  double density(double d) {
    double width = MediaQuery.of(context).size.width;
    double value = d * (width / 390);
    return value;
  }
}
