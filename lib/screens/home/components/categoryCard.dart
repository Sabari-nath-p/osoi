import 'package:flutter/material.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/screens/categoryview/categoryMain.dart';

class CategoryCard extends StatelessWidget {
  var catData;
  CategoryCard({super.key, required this.catData});
  late BuildContext Context;
  @override
  Widget build(BuildContext context) {
    Context = context;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => categoryMain(pdata: catData)));
      },
      child: Container(
        width: density(150),
        height: density(150),
        margin: EdgeInsets.only(right: density(12)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(density(7)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  color: Colors.grey.withOpacity(.4),
                  blurRadius: .7,
                  spreadRadius: .2),
            ]),
        child: SizedBox(
          width: density(110),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              (catData["image"].isNotEmpty)
                  ? catData["image"]["original"]
                  : noimage,
              fit: BoxFit.cover,
            ),
          ),
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
