import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/constant/url.dart';
import 'package:oso/datamodel/cartmodel.dart';

import '../../../customfunction.dart';
import '../../../supporter/sizesupporter.dart';

class cartProduct extends StatefulWidget {
  cartProductModel pdata;
  ValueNotifier notify;
  bool ischeck = true;
  cartProduct(
      {super.key,
      required this.pdata,
      required this.notify,
      this.ischeck = true});

  @override
  State<cartProduct> createState() => _cartProductState(pdata: pdata);
}

class _cartProductState extends State<cartProduct> {
  cartProductModel pdata;
  _cartProductState({required this.pdata});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String sqty; // convert quantity count to fromatted String model
    if (pdata.quantity < 10)
      sqty = "0${pdata.quantity}";
    else
      sqty = pdata.quantity.toString();
    return (pdata.quantity == 0)
        ? Container()
        : Container(
            width: density(390),
            height: density(130),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned(
                    left: 15,
                    right: 15,
                    bottom: 5,
                    top: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                    )),
                Positioned(
                  left: 25,
                  top: 20,
                  bottom: 20,
                  child: SizedBox(
                      width: density(70),
                      height: density(70),
                      child: Image.network(
                        pdata.image,
                        fit: BoxFit.cover,
                      )),
                ),
                width(density(8)),
                Positioned(
                  left: 108,
                  top: 22,
                  bottom: 70,
                  width: 142,
                  child: Text(
                    "${pdata.name}",
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: density(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!widget.ischeck)
                  Positioned(
                      top: 2,
                      left: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            double save = pdata.save / pdata.quantity;
                            pdata.quantity = 0;
                            pdata.save = save * pdata.quantity;
                            pdata.subTotal = pdata.price * pdata.quantity;
                            addtoCart();
                          });
                        },
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xffADB5C0),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: appprimarycolor,
                            )),
                      )),
                Positioned(
                  right: 30,
                  top: 20,
                  child: Row(
                    children: [
                      if (!widget.ischeck)
                        InkWell(
                          onTap: () {
                            setState(() {
                              double save = (pdata.save / pdata.quantity);
                              pdata.quantity--;
                              pdata.save = save * pdata.quantity;
                              pdata.subTotal = pdata.price * pdata.quantity;
                              addtoCart();
                            });
                          },
                          child: CircleAvatar(
                              radius: 10,
                              backgroundColor: appprimarycolor,
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 18,
                              )),
                        ),
                      width(density(10)),
                      Text(
                        "$sqty",
                        style: TextStyle(
                          fontSize: density(20),
                          fontFamily: "Montserrat",
                        ),
                      ),
                      if (widget.ischeck)
                        Text(
                          " Nos",
                          style: TextStyle(
                            fontSize: density(13),
                            fontFamily: "Montserrat",
                          ),
                        ),
                      width(density(10)),
                      if (!widget.ischeck)
                        InkWell(
                          onTap: () {
                            setState(() {
                              double save = pdata.save / pdata.quantity;
                              pdata.quantity++;
                              pdata.save = (save * pdata.quantity);
                              pdata.subTotal = pdata.price * pdata.quantity;
                              addtoCart();
                            });
                          },
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: appprimarycolor,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                width(density(5)),
                if (widget.ischeck)
                  Positioned(
                      right: 25,
                      bottom: 28,
                      child: Text(
                        pdata.subscription,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                Positioned(
                  left: 108,
                  top: (!widget.ischeck) ? 60 : null,
                  bottom: (!widget.ischeck) ? null : 25,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "\$${ToFixed(pdata.subTotal - pdata.save)}",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: density(18),
                          color: appprimarycolor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      width(6),
                      if (pdata.save != 0)
                        Text(
                          "\$${(pdata.subTotal).toString()}",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: density(12),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough),
                        )
                    ],
                  ),
                ),
                if (!widget.ischeck)
                  Positioned(
                    top: 83,
                    left: 108,
                    right: 30,
                    bottom: 10,
                    child: Text(
                      pdata.Des.replaceAll("About\n", ""),
                      style: tx400(11, color: Colors.black87),
                    ),
                  )
              ],
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

  addtoCart() async {
    //checknotify.value++;
    Box box = await Hive.openBox("cart");

    box.put(pdata.id, pdata);

    widget.notify.value++;
  }
}
