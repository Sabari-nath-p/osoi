import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/productDetails/productMain.dart';

import '../../../supporter/sizesupporter.dart';

class PopularCard extends StatelessWidget {
  var pdata;
  ValueNotifier notifier;
  PopularCard({super.key, required this.pdata, required this.notifier});

  late BuildContext Context;
  @override
  Widget build(BuildContext context) {
    Context = context;
    double saveAmount = 0;
    int savepercentage = 0;
    String name = "";
    double salePrice = 0;
    double price = 0;
    var priceVaritation = "";
    String imageLink = noimage;
    String unit = "";

    name = pdata["name"];
    price =
        (pdata["price"] != null) ? double.parse(pdata["price"].toString()) : 0;

    salePrice = (pdata["sale_price"] != null)
        ? double.parse(pdata["sale_price"].toString())
        : price;
    unit = pdata["unit"];

    imageLink =
        (!pdata["image"].isEmpty) ? pdata["image"]["thumbnail"] : noimage;
    if (price != 0) {
      saveAmount = price - salePrice;
      double temp = ((salePrice * 100) / price);
      temp = temp - temp % 1;
      savepercentage = 100 - temp.toInt();
    }

    if (price == 0) {
      priceVaritation = "${pdata["max_price"]} - \$${pdata["min_price"]}";
    }
    return InkWell(
      onTap: () {
        notifier.value = 1220;

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                productMain(slug: pdata["slug"], notify: notifier)));
      },
      child: Container(
        margin: EdgeInsets.only(
            top: density(5),
            left: density(5),
            right: density(5),
            bottom: density(5)),
        height: density(200),
        width: density(180),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black12, //color of shadow
            spreadRadius: .03, //spread radius
            blurRadius: 7, // blur radius
          )
        ], borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Stack(
          children: [
            Positioned(
                left: 5,
                right: 5,
                top: 5,
                bottom: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageLink,
                      fit: BoxFit.cover,
                    ))),
            Positioned(
                height: 60,
                left: 2,
                right: 2,
                bottom: 5,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(density(5)),
                      Expanded(
                        child: Text(
                          "${pdata["name"]}",
                          softWrap: true,
                          style: tx500(16, color: Colors.black87),
                        ),
                      ),
                      height(density(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (salePrice != 0)
                                ? '\$$salePrice'
                                : '\$$priceVaritation',
                            softWrap: true,
                            style: tx500(15, color: Colors.black87),
                          ),
                          width(5),
                          if (salePrice != price)
                            Expanded(
                              flex: 2,
                              child: Text(
                                "\$${price}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                          if (savepercentage != 0)
                            Text(
                              "${savepercentage}% off",
                              style: tx500(11),
                            ),
                          width(30)
                        ],
                      ),
                      height(density(5)),
                    ],
                  ),
                )),
            /*  if (false)
              Positioned(
                  top: density(167),
                  left: density(8),
                  bottom: density(8),
                  child: Row(
                    children: [
                      Text(
                        (salePrice != 0) ? '\$$salePrice' : '\$$priceVaritation',
                        softWrap: true,
                        style: TextStyle(
                            fontSize: density(14),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat"),
                      ),
                      width(5),
                      if (salePrice != price)
                        Text(
                          "\$${price}",
                          style: TextStyle(
                              fontSize: density(12),
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat"),
                        )
                    ],
                  )),*/
          ],
        ),
      ),
    );
  }

  double density(double d) {
    double width = MediaQuery.of(Context).size.width;
    double value = d * (width / 390);
    return value;
  }
}
