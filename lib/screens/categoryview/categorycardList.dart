import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/productDetails/productMain.dart';

import '../../constant/colors.dart';
import '../../supporter/sizesupporter.dart';

class catergoryCard extends StatefulWidget {
  var pdata;
  String category;
  catergoryCard(
      {super.key, required this.pdata, this.category = "Certified Organic"});

  @override
  State<catergoryCard> createState() => _catergoryCardState(pdata: pdata);
}

ValueNotifier notifier = ValueNotifier(10);

class _catergoryCardState extends State<catergoryCard> {
  var pdata;
  _catergoryCardState({required this.pdata});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                productMain(slug: pdata["slug"], notify: notifier)));
      },
      child: Container(
        width: density(170),
        height: density(230),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          //   fit: StackFit.loose,
          children: [
            Container(
                alignment: Alignment.center,
                width: density(170),
                height: density(150),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    (pdata["image"].isNotEmpty)
                        ? pdata['image']["thumbnail"]
                        : noimage,
                    fit: BoxFit.cover,
                    width: 170,
                    height: 150,
                  ),
                )),
            height(5),
            Text(
              widget.category,
              softWrap: true,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: density(10),
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Text(
                pdata["name"],
                softWrap: true,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: density(14.5),
                  color: Colors.black.withOpacity(.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                if (false)
                  Expanded(
                    child: RatingBar.builder(
                      itemSize: 12,
                      initialRating:
                          double.parse(pdata["ratings"].toString()).toDouble(),
                      minRating: 1,
                      tapOnlyMode: false,
                      ignoreGestures: true,
                      glow: false,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: appprimarycolor,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                if (pdata["sale_price"] != null)
                  Text(
                    "\$${pdata["sale_price"]}  ",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(18),
                      color: appprimarycolor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (pdata["sale_price"] == null)
                  Text(
                    "\$${pdata["price"]}  ",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(15),
                      color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (pdata["sale_price"] != null && false)
                  if (pdata["sale_price"] < pdata["price"].toString())
                    Text(
                      "\$${pdata["price"].toString()}",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: density(12),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough),
                    ),
              ],
            ),
            height(7),
            width(density(5)),
            if (false)
              Positioned(
                right: 20,
                top: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "\$${pdata["price"]}",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: density(18),
                        color: appprimarycolor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    width(6),
                    Text(
                      "\$${pdata["price"].toString()}",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: density(12),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                ),
              ),
          ],
        ),
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
