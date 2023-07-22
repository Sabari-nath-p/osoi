import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:http/http.dart' as http;
import 'package:oso/constant/url.dart';
import 'package:oso/customfunction.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/textstyles.dart';
import '../../../supporter/sizesupporter.dart';

class subscriptionUpdateCard extends StatefulWidget {
  var pdata;
  String subscriptionId;
  ValueNotifier notifier;
  int totalCount;

  subscriptionUpdateCard(
      {super.key,
      required this.pdata,
      required this.subscriptionId,
      required this.totalCount,
      required this.notifier});

  @override
  State<subscriptionUpdateCard> createState() =>
      _subscriptionUpdateCardState(pdata: pdata);
}

class _subscriptionUpdateCardState extends State<subscriptionUpdateCard> {
  var pdata;
  _subscriptionUpdateCardState({required this.pdata});

  int qty = 0;
  double price = 0;
  int cqty = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("total count = ");
    print(widget.totalCount);
    qty = double.parse(pdata["order_quantity"].toString()).round();
    cqty = double.parse(pdata["order_quantity"].toString()).round();
    price = double.parse(pdata["unit_price"]);
    price = ToFixed(price);
  }

  @override
  Widget build(BuildContext context) {
    price = ToFixed(price);
    return Container(
      constraints: BoxConstraints(maxHeight: 130, minHeight: 95),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Colors.black26.withOpacity(.1)),
              bottom: BorderSide(
                  color: Colors.black12.withOpacity(
                .1,
              )))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (qty != cqty) height(10),
          Row(
            children: [
              width(16),
              SizedBox(
                height: 60,
                width: 60,
                child: Image.network(pdata["product"]["image"]["thumbnail"]),
              ),
              width(5),
              Expanded(child: Text(pdata["product"]["name"])),
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
                            if (qty > 1) qty--;
                          });
                        },
                        child: Icon(Icons.remove)),
                    width(5),
                    Text(
                      qty.toString(),
                      style: tx700(16),
                    ),
                    width(5),
                    InkWell(
                        onTap: () {
                          setState(() {
                            qty++;
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
                    "\$ ${ToFixed(price * qty)}",
                    style: tx600(15, color: Colors.black),
                  )
                ],
              ),
              width(2),
              if (widget.totalCount > 1)
                InkWell(
                  onTap: () {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        onCancelBtnTap: () {
                          Navigator.of(context).pop();
                        },
                        onConfirmBtnTap: () async {
                          Navigator.of(context).pop();
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          String token = pref.getString("TOKEN").toString();
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
                          final response = await http.post(
                              Uri.parse(
                                  "$baseurl/api/recurring-order/delete-product"),
                              headers: ({
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $token',
                              }),
                              body: ({
                                "subscription_id":
                                    widget.subscriptionId.toString(),
                                "subscription_item_id":
                                    pdata["subscription_item_id"].toString(),
                                "product_id": pdata["product_id"].toString(),
                              }));
                          print(response.body);
                          print(response.statusCode);
                          if (response.statusCode == 200) {
                            widget.notifier.value++;
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            print(response.body);
                          }
                        },
                        text: "Remove item from subscription");
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.black45,
                  ),
                ),
              width(5)
            ],
          ),
          if (qty != cqty)
            InkWell(
              onTap: () async {
                print("working");
                SharedPreferences pref = await SharedPreferences.getInstance();
                String token = pref.getString("TOKEN").toString();
                showDialog(
                    context: context,
                    builder: (context) => Container(
                          alignment: Alignment.center,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: appprimarycolor,
                            size: 40,
                          ),
                        ));
                final response = await http.post(
                    Uri.parse(
                        "$baseurl/api/recurring-order/update-product-quantity"),
                    headers: ({
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $token',
                    }),
                    body: ({
                      "subscription_id": widget.subscriptionId.toString(),
                      "subscription_item_id":
                          pdata["subscription_item_id"].toString(),
                      "product_id": pdata["product_id"].toString(),
                      "quantity": qty.toString()
                    }));
                print(response.body);
                print(response.statusCode);
                if (response.statusCode == 200) {
                  widget.notifier.value++;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  print(response.body);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: appprimarycolor),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  " Update ",
                  style: tx500(12, color: Colors.white),
                ),
              ),
            ),
          if (qty != cqty) height(10)
        ],
      ),
    );
  }
}
