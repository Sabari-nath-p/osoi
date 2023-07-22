import 'dart:convert';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/datamodel/cartmodel.dart';
import 'package:oso/screens/productDetails/similarProduct.dart';

import '../../constant/textstyles.dart';
import '../../constant/url.dart';
import '../../supporter/sizesupporter.dart';
import '../home/views/cartview.dart';

class productMain extends StatefulWidget {
  ValueNotifier
      notify; // used to update cart when new product is added to the cart
  String slug;
  productMain({super.key, required this.slug, required this.notify});

  @override
  State<productMain> createState() => _productMainState(slug: slug);
}

class _productMainState extends State<productMain> {
  String slug;
  _productMainState({required this.slug});

  int qty = 0; //varible to controll quantity to be added  to card

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  int CshopId = -1;
  double saveAmount = 0;
  int savepercentage = 0;
  int inStock = 1;
  String name = "";
  int deliveryOption = 0;
  double salePrice = 0;
  double price = 0;
  List imageLink = [];
  String unit = "";
  String description = "";
  String priceVaritation = "";
  String id = "0";
  var pdata = null;
  int optionSelector = -1;
  int shopId = -1;
  String subscription = "";
  double subscriptionDiscount = 0;
  double mSave = 0;
  double Mprice = 0;
  int subID = -1;
  bool ispreorder = false;
  var predata;
  loadData() async {
    final Response = await http.get(Uri.parse(
        "$baseurl/products/$slug?language=en&searchJoin=and&with=categories%3Bshop%3Btype%3Bvariations%3Bvariations.attribute.values%3Bmanufacturer%3Bvariation_options%3Btags%3Bauthor"));
    pdata = json.decode(Response.body);

    setState(() {
      name = pdata["name"];
      id = pdata["id"].toString();
      if (pdata["description"] != null) description = pdata["description"];
      price = (pdata["price"] != null)
          ? double.parse(pdata["price"].toString())
          : 0;
      shopId = pdata["shop_id"];
      salePrice = (pdata["sale_price"] != null)
          ? double.parse(pdata["sale_price"].toString())
          : price;
      inStock = pdata["quantity"];
      Mprice = salePrice;
      deliveryOption = pdata["delivery_types"].length;
      unit = pdata["unit"];
      //imageLink = pdata["image"]["thumbnail"];
      if (pdata["gallery"].isNotEmpty)
        for (var img in pdata["gallery"]) {
          imageLink.add(
            img["original"],
          );
        }
      else if (pdata["image"].isNotEmpty)
        imageLink.add(
          pdata["image"]["original"],
        );
      else
        imageLink.add(noimage);
      if (price != 0) {
        saveAmount = price - salePrice;
        mSave = saveAmount;
        double temp = ((salePrice * 100) / price);
        temp = temp - temp % 1;
        savepercentage = 100 - temp.toInt();
      }

      if (price == 0) {
        priceVaritation = "${pdata["max_price"]} - Rs ${pdata["min_price"]}";
      }

      checkInCart();
      loadCart();
      UpdateCart();
      checkispreorder();
    });
  }

  UpdateCart() {
    widget.notify.addListener(() {
      loadCart();
      checkInCart();
    });
  }

  checkispreorder() {
    for (var st in pdata["payment_frequencies"]) {
      if (st["type"] == "pre_order") {
        setState(() {
          ispreorder = true;
          predata = st;
        });
      }
    }
  }

  String ordertype = "";
  checkInCart() async {
    Box box = await Hive.openBox("cart");
    SharedPreferences sharedpreferance = await SharedPreferences.getInstance();
    String shop = sharedpreferance.getString("SHOP_ID").toString();
    ordertype = sharedpreferance.getString("ORDER_TYPE").toString();
    if (shop != "null") {
      CshopId = int.parse(shop);
    }
    if (box.get(pdata["id"]) != null) {
      cartProductModel pd = box.get(pdata["id"]);
      print(1);
      setState(() {
        qty = pd.quantity;
        print(10);

        if (pd.vid != 0 && pdata["variation_options"].isNotEmpty && qty > 0) {
          print(2);
          for (int i = 0; i < pdata["variation_options"].length; i++) {
            if (pd.vid == pdata["variation_options"][i]["id"]) {
              optionSelector = i;
              print(3);
              price = double.parse(pdata["variation_options"][i]["price"])
                  .toDouble();
              print(4);
              salePrice = (pdata["variation_options"][i]["sale_price"] != null)
                  ? double.parse(pdata["variation_options"][i]["sale_price"])
                      .toDouble()
                  : price;
              print(5);
              if (pdata["variation_options"][i]["image"] != null)
                imageLink.clear();
              if (pdata["variation_options"][i]["image"] != null)
                imageLink
                    .add(pdata["variation_options"][i]["image"]["thumbnail"]);
            }
            print(6);
          }
        }
      });
    } else {
      setState(() {
        qty = 0;
      });
    }
  }

  int count = 0;
  double total = 0;
  double save = 0;
  @override
  void dispose() {
    super.dispose();
  }

  loadCart() async {
    setState(() {
      save = 0;
      total = 0;
      count = 0;
    });
    Box box = await Hive.openBox("cart");
    for (var id in box.keys) {
      if (box.get(id) != null) {
        cartProductModel pd = box.get(id);
        if (pd.quantity > 0) {
          setState(() {
            count++;
            total = total + pd.subTotal;
            save = save + pd.save;
          });
        }
      }
    }
    setState(() {
      loading = 1;
    });
  }

  int loading = 0;
  bool isZoom = false;
  String zoomLink = "";

  @override
  Widget build(BuildContext context) {
    String sqty; // convert quantity count to fromatted String model
    String cqty; // formate string to cart model
    int textcount = (!ispreorder) ? 22 : 16;
    if (qty == 0) salePrice = Mprice;
    if (qty < 10)
      sqty = "0$qty";
    else
      sqty = qty.toString();
    if (count < 10)
      cqty = "0$count";
    else
      cqty = count.toString();

    return Scaffold(
        body: (loading == 1 && pdata != null)
            ? SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white24,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (imageLink.length > 0)
                                Container(
                                  color: Colors.white,
                                  height: density(300),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: ImageSlideshow(
                                          indicatorColor: appprimarycolor,
                                          isLoop: (imageLink.length > 1),
                                          autoPlayInterval:
                                              (imageLink.length > 1) ? 6000 : 0,
                                          children: [
                                            for (int i = 0;
                                                i < imageLink.length;
                                                i++)
                                              Container(
                                                height: density(300),
                                                child: Image.network(
                                                  imageLink[i],
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          top: density(20),
                                          left: density(20),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.withOpacity(.2),
                                              child: Icon(
                                                Icons.arrow_back_ios_new,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              Stack(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    height: density(110) +
                                        (density(26) *
                                            ((name.length / textcount).round() -
                                                1)),
                                  ),
                                  Positioned(
                                    left: density(16),
                                    top: density(15),
                                    bottom: density(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: (!ispreorder)
                                                ? density(330)
                                                : density(260),
                                            child: Text(
                                              '$name',
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: density(18),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              (salePrice != 0)
                                                  ? '\$ $salePrice'
                                                  : '\$ $priceVaritation',
                                              style: TextStyle(
                                                  fontSize: density(16),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins"),
                                            ),
                                            width(density(8)),
                                            if (price != salePrice)
                                              Text(
                                                '\$ $price',
                                                style: TextStyle(
                                                    fontSize: density(14),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Poppins",
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '$unit',
                                              style: TextStyle(
                                                  color: appprimarycolor,
                                                  fontSize: density(16),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins"),
                                            ),
                                            width(10),
                                            SizedBox(
                                              child: RatingBar.builder(
                                                itemSize: 20,
                                                initialRating: double.parse(
                                                        pdata["ratings"]
                                                            .toString())
                                                    .toDouble(),
                                                minRating: 1,
                                                tapOnlyMode: false,
                                                ignoreGestures: true,
                                                glow: false,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 1.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: appprimarycolor,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (inStock < 1 && qty == 0)
                                    Positioned(
                                        right: density(20),
                                        bottom: density(10),
                                        child: Container(
                                          height: density(37),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: density(10)),
                                          decoration: BoxDecoration(
                                              color: appprimarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(70)),
                                          child: Text(
                                            "Out of Stock",
                                            style: TextStyle(
                                                fontSize: density(16),
                                                fontFamily: "Poppins",
                                                color: Colors.white),
                                          ),
                                        )),
                                  if (ispreorder && qty == 0)
                                    Positioned(
                                        bottom: density(70),
                                        right: density(20),
                                        child: InkWell(
                                          onTap: () {
                                            ordertype == "pre_order";
                                            if (price != 0) {
                                              if (count == 0 ||
                                                  (ordertype == "pre_order" &&
                                                      (shopId == CshopId ||
                                                          CshopId == -1))) {
                                                frequecnyadd(predata);
                                              } else {
                                                QuickAlert.show(
                                                    context: context,
                                                    type:
                                                        QuickAlertType.warning,
                                                    text:
                                                        "You are trying to add difference payment frequency,clear previous cart to add current product",
                                                    showCancelBtn: true,
                                                    onConfirmBtnTap: () async {
                                                      Box bx =
                                                          await Hive.openBox(
                                                              "cart");
                                                      Box box =
                                                          await Hive.openBox(
                                                              "cart");
                                                      for (var p in box.keys) {
                                                        cartProductModel pd =
                                                            box.get(p);
                                                        pd.quantity = 0;
                                                        box.put(p, pd);
                                                      }
                                                      frequecnyadd(predata,
                                                          option: true);
                                                    });
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "please select option");
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                // color: appprimarycolor,
                                                border: Border.all(
                                                    color: appprimarycolor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        density(10))),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Pre Order',
                                                  style: TextStyle(
                                                    color: appprimarycolor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  if (qty == 0 && inStock > 0)
                                    Positioned(
                                        bottom: density(20),
                                        right: density(20),
                                        child: InkWell(
                                          onTap: () {
                                            if (price != 0) {
                                              setState(() {
                                                openSusbcription();
                                                //loadCart();
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "please select option");
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: appprimarycolor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        density(10))),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ADD TO CART',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Monsterrat"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  if (qty > 0)
                                    Positioned(
                                        right: density(20),
                                        bottom: density(15),
                                        child: Container(
                                          height: density(40),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: density(21)),
                                          decoration: BoxDecoration(
                                              color: appprimarycolor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      density(10))),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    qty--;
                                                    addtoCart();
                                                    //  loadCart();
                                                  });
                                                },
                                                child: Text(
                                                  "-",
                                                  style: TextStyle(
                                                      fontSize: density(30),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              width(density(21)),
                                              Text(
                                                "$sqty",
                                                style: TextStyle(
                                                    fontSize: density(20),
                                                    fontFamily: "Montserrat",
                                                    color: Colors.white),
                                              ),
                                              width(density(21)),
                                              InkWell(
                                                onTap: () {
                                                  if (price != 0) {
                                                    setState(() {
                                                      qty++;
                                                      addtoCart();
                                                      //  loadCart();
                                                    });
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "please select option");
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                ],
                              ),
                              SizedBox(
                                height: density(10),
                              ),
                              if (pdata["variation_options"].isNotEmpty)
                                Container(
                                  width: density(390),
                                  //       color: Colors.white,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: density(16),
                                      vertical: density(17)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: density(22),
                                        child: Text(
                                          pdata["variation_options"][0]
                                              ["options"][0]["name"],
                                          style: TextStyle(
                                              fontSize: density(18),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      SizedBox(
                                        height: density(15),
                                      ),
                                      SizedBox(
                                        width: density(350),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      pdata["variation_options"]
                                                          .length;
                                                  i++)
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      optionSelector = i;
                                                      optid = pdata[
                                                              "variation_options"]
                                                          [i]["id"];
                                                      price = double.parse(pdata[
                                                                  "variation_options"]
                                                              [i]["price"])
                                                          .toDouble();

                                                      salePrice = (pdata["variation_options"]
                                                                      [i][
                                                                  "sale_price"] !=
                                                              null)
                                                          ? double.parse(pdata[
                                                                      "variation_options"][i]
                                                                  [
                                                                  "sale_price"])
                                                              .toDouble()
                                                          : price;
                                                      if (pdata["variation_options"]
                                                              [i]["image"] !=
                                                          null)
                                                        imageLink.clear();

                                                      if (pdata["variation_options"]
                                                              [i]["image"] !=
                                                          null)
                                                        imageLink.add((pdata["variation_options"]
                                                                            [i]
                                                                        ["image"]
                                                                    [
                                                                    "original"] !=
                                                                null)
                                                            ? pdata["variation_options"]
                                                                    [i]["image"]
                                                                ["original"]
                                                            : pdata["variation_options"]
                                                                    [i]["image"]
                                                                ["thumbnail"]);
                                                    });

                                                    addtoCart();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        (pdata["variation_options"]
                                                                            [i][
                                                                        "title"]
                                                                    .length <=
                                                                2)
                                                            ? 40
                                                            : null,
                                                    padding:
                                                        (pdata["variation_options"]
                                                                            [i][
                                                                        "title"]
                                                                    .length <=
                                                                2)
                                                            ? null
                                                            : EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        9,
                                                                    vertical:
                                                                        2),
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (i == optionSelector)
                                                              ? appprimarycolor
                                                              : null,
                                                      border: Border.all(
                                                          color:
                                                              appprimarycolor),
                                                      borderRadius: BorderRadius.circular(
                                                          (pdata["variation_options"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          "title"]
                                                                      .length <=
                                                                  2)
                                                              ? 100
                                                              : 16),
                                                      //shape: BoxShape.circle
                                                    ),
                                                    child: Text(
                                                      pdata["variation_options"]
                                                          [i]["title"],
                                                      style: TextStyle(
                                                          color: (i !=
                                                                  optionSelector)
                                                              ? appprimarycolor
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (description != "")
                                SizedBox(
                                  height: density(10),
                                ),
                              if (description != "")
                                Container(
                                  width: density(390),
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: density(16),
                                      vertical: density(17)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: density(20),
                                        child: Text(
                                          'Product Details',
                                          style: TextStyle(
                                              fontSize: density(16),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: density(15),
                                      ),
                                      SizedBox(
                                        width: density(350),
                                        child: Text(
                                          description,
                                          style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w400,
                                              fontSize: density(14),
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              height(density(10)),
                              if (pdata != null)
                                Container(
                                  color: Colors.white,
                                  height: density(274),
                                  width: density(390),
                                  padding: EdgeInsets.only(
                                      left: density(16), top: density(10)),
                                  child: similarProduct(
                                    data: pdata["related_products"],
                                    notify: widget.notify,
                                    id: id,
                                  ),
                                ),
                              height(density(50)),
                              if (count != 0) height(density(130))
                            ],
                          ),
                        ),
                      ),
                      if (count != 0)
                        Positioned(
                            bottom: 0,
                            height: density(100),
                            child: Stack(
                              children: [
                                Container(
                                  width: density(390),
                                  height: density(100),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: .05,
                                            blurRadius: 9.2)
                                      ]),
                                ),
                                Positioned(
                                    top: density(25),
                                    left: density(28),
                                    bottom: density(40),
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 40,
                                      color: appprimarycolor,
                                    )),
                                Positioned(
                                    top: density(26),
                                    left: density(76),
                                    child: Text(
                                      "$cqty items",
                                      style: TextStyle(
                                          fontSize: density(14),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins"),
                                    )),
                                Positioned(
                                    top: density(26),
                                    left: density(151),
                                    child: Text("\$ $total",
                                        style: TextStyle(
                                            fontSize: density(16),
                                            color: appprimarycolor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins"))),
                                Positioned(
                                    right: density(22),
                                    bottom: density(35),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => cartview(
                                                      notifier: widget.notify,
                                                      zipName: [],
                                                      selectedZip: "690517",
                                                    )));
                                      },
                                      child: Container(
                                        width: density(128),
                                        height: density(42),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: appprimarycolor),
                                        child: Text("View Cart",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins")),
                                      ),
                                    )),
                                Positioned(
                                    left: density(76),
                                    bottom: density(28),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: density(74),
                                      height: density(21),
                                      color: Color.fromARGB(100, 243, 210, 102),
                                      child: Text(
                                        "Save $save",
                                        style:
                                            TextStyle(color: appprimarycolor),
                                      ),
                                    ))
                              ],
                            )),
                    ],
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: appprimarycolor, size: 40),
              ));
  }

  double density(
    double d,
  ) {
    double height = MediaQuery.of(context).size.width;
    double value = d * (height / 390);
    return value;
  }

  int optid = 0;
  addtoCart() async {
    // saveAmount = //price - salePrice;
    Box box = await Hive.openBox("cart");
    cartProductModel pd = cartProductModel(
        id: pdata["id"],
        name: name,
        unit: pdata["unit"],
        price: salePrice,
        quantity: qty,
        image: imageLink[0],
        slug: pdata["slug"],
        vid: optid,
        subTotal: (salePrice * qty),
        save: (saveAmount * qty),
        subscription: subscription,
        deliveryOption: deliveryOption,
        subscriptionID: subID,
        Des: description);

    box.put(pdata["id"], pd);
    widget.notify.value++;
  }

  openSusbcription() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(builder: (context, reload) {
              return Container(
                height: 270,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 29, top: 26, right: 29),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          20,
                        ),
                        topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Purchase Type",
                          style: tx600(16, color: Colors.black),
                        ),
                        for (var st in pdata["payment_frequencies"])
                          if (st["type"] != "pre_order")
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();

                                setState(() {
                                  print(ordertype);
                                  if (st["type"] != "pre_order") {
                                    if ((shopId == CshopId ||
                                            CshopId == -1 ||
                                            count == 0) &&
                                        ordertype != "pre_order") {
                                      frequecnyadd(st);
                                    } else if (ordertype == "pre_order") {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.warning,
                                          text:
                                              "You are trying to add difference payment frequency,clear previous cart to add current product",
                                          showCancelBtn: true,
                                          onConfirmBtnTap: () async {
                                            Box bx = await Hive.openBox("cart");
                                            Box box =
                                                await Hive.openBox("cart");
                                            for (var p in box.keys) {
                                              cartProductModel pd = box.get(p);
                                              pd.quantity = 0;
                                              box.put(p, pd);
                                            }
                                            frequecnyadd(st, option: true);
                                          });
                                    } else {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.warning,
                                          text:
                                              "You are trying to add different shop,clear previous cart to add current product",
                                          showCancelBtn: true,
                                          onConfirmBtnTap: () async {
                                            Box bx = await Hive.openBox("cart");
                                            Box box =
                                                await Hive.openBox("cart");
                                            for (var p in box.keys) {
                                              cartProductModel pd = box.get(p);
                                              pd.quantity = 0;
                                              box.put(p, pd);
                                            }
                                            frequecnyadd(st, option: true);
                                          });
                                    }
                                  } else {
                                    if (count == 0 ||
                                        (ordertype == "pre_order" &&
                                            (shopId == CshopId ||
                                                CshopId == -1))) {
                                      frequecnyadd(st);
                                    } else {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.warning,
                                          text:
                                              "You are trying to add difference payment frequency,clear previous cart to add current product",
                                          showCancelBtn: true,
                                          onConfirmBtnTap: () async {
                                            Box box =
                                                await Hive.openBox("cart");
                                            for (var p in box.keys) {
                                              cartProductModel pd = box.get(p);
                                              pd.quantity = 0;
                                              box.put(p, pd);
                                            }
                                            frequecnyadd(st, option: true);
                                          });
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 320,
                                height: 40,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(.5, 1),
                                          color: Colors.grey.withOpacity(.4),
                                          blurRadius: 1,
                                          spreadRadius: .1)
                                    ]),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        st["name"],
                                        style: tx500(16),
                                      ),
                                    ),
                                    if (st["default_discount_amount"] != null)
                                      Text(
                                        "${double.parse(st["default_discount_amount"]).toInt()} % off",
                                        style:
                                            tx400(12, color: appprimarycolor),
                                      ),
                                    width(5),
                                  ],
                                ),
                              ),
                            ),
                        height(30)
                      ]),
                ),
              );
            }));
  }

  frequecnyadd(var st, {bool option = false}) async {
    if (option) Navigator.of(context).pop();
    qty++;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("SHOP_ID", shopId.toString());
    pref.setString("ORDER_TYPE", st["type"]);
    double amount = (salePrice != 0) ? salePrice : price;

    if (st["default_discount_amount"] != null) {
      print("Save");
      print("Amount");
      saveAmount = mSave;
      double temp = saveAmount +
          ((double.parse(st["default_discount_amount"]) * amount) / 100);
      ;
      saveAmount = double.parse(temp.toStringAsFixed(2));
      print(saveAmount);
      subscriptionDiscount = double.parse(st["default_discount_amount"]);

      // salePrice = price - saveAmount;
    } else {
      saveAmount = mSave;
      // salePrice = price - saveAmount;
      subscriptionDiscount = 0;
    }
    if (st["type"] == "recurring") deliveryOption = 3;
    subscription = st["name"].toString();
    subID = st["id"];
    // widget.notify.value++;

    addtoCart();
  }
}
