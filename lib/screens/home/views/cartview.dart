import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/datamodel/adressData.dart';
import 'package:oso/datamodel/cartmodel.dart';
import 'package:oso/screens/cart/checkout.dart';
import 'package:oso/screens/home/components/cartproductview.dart';
import 'package:oso/supporter/functionsupporter.dart';
import 'package:oso/supporter/weekday.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

import '../../../Converter/verify.dart';
import '../../../constant/url.dart';
import '../../../datamodel/userData.dart';
import '../../../supporter/sizesupporter.dart';
import '../components/locationSelector.dart';
import '../homemain.dart';

class cartview extends StatefulWidget {
  String selectedZip;
  ValueNotifier notifier;
  List<String> zipName;
  cartview(
      {super.key,
      required this.selectedZip,
      required this.notifier,
      required this.zipName});

  @override
  State<cartview> createState() => _cartviewState();
}

class _cartviewState extends State<cartview> {
  List cartlist = [];
  List suboptions = [];
  double Itemtotal = 0;
  double saveAmount = 0;
  String token = "";
  String log = "OUT";
  bool isShiponly = false;

  final ScrollController _controller = ScrollController();
  List<addressData> addressList = [];
  int selectedAddress = 0;
  ValueNotifier<int> addressNotify = ValueNotifier<int>(0);

  notify() {
    addressNotify.addListener(() {
      loadUser();

      Address();
    });
  }

  bool isShipping = true;
  loadUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    token = pref.get("TOKEN").toString();
    log = pref.get("LOGIN").toString();

    //print(pref.getString("SELECTED-ADDRESS").toString());
    // if (pref.getString("SELECTED-ADDRESS").toString() != "null") {
    // selectedAddress =
    //    int.parse(pref.getString("SELECTED-ADDRESS").toString());
    //  }
    selectedAddress = 0;
    Box db = await Hive.openBox("user");
    addressList.clear();
    if (db.isNotEmpty) {
      userData udata = db.get(1);

      for (var ad in udata.address) {
        setState(() {
          print(ad);
          addressList.add(ad);
        });
      }

      if (addressList.length < selectedAddress) {
        selectedAddress = 0;
      }
    }
  }

  startLister() {
    print("working");

    widget.notifier.addListener(() {
      setState(() {
        print("value");
        cartlist.clear();
        suboptions.clear();
        loadCart();
        Itemtotal = 0;
      });
    });
  }

  loadCart() async {
    cartlist.clear();

    saveAmount = 0;

    Box box = await Hive.openBox("cart");

    // itemTotal = 0;

    setState(() {
      for (var p in box.keys) {
        cartProductModel pd = box.get(p);

        if (pd.quantity > 0) {
          if (pd.deliveryOption == 1 &&
              pd.quantity > 0 &&
              deliveryConstant == 0) {
            deliveryConstant = 1;
            deliveryMethodSelector = 1;
          }
          Itemtotal = (Itemtotal + (pd.subTotal - pd.save));
          saveAmount = saveAmount + pd.save;
          if (pd.deliveryOption == 3) {
            isShiponly = true;
            deliveryMethodSelector = 0;
          }
          ;
          int cartid = suboptions.indexOf(pd.subscription);

          if (cartid == -1) {
            suboptions.add(pd.subscription);
            //  cartid = suboptions.indexOf(pd.subscription);
          }
          if (cartid == -1)
            cartlist.add([pd]);
          else
            cartlist[cartid].add(pd);
          // itemTotal = itemTotal + pd.subTotal;
        }
      }
    });
  }

  List allowedDate = [];
  DateTime initalDate = DateTime.now();

  checkFrequency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("checking frequency");
    shopid = pref.getString("SHOP_ID").toString();
    ordertype = pref.getString("ORDER_TYPE").toString();
    print(ordertype);
    if (ordertype == "pre_order")
      setState(() {
        (deliveryConstant = 1);
        deliveryMethodSelector = 1;
      });

    final Response = await http.get(Uri.parse("$baseurl/shops?id=$shopid"));

    if (Response.statusCode == 200) {
      var inres = json.decode(Response.body);
      // print(inres.body);

      final res = await http
          .get(Uri.parse("$baseurl/shops/${inres["data"][0]["slug"]}"));

      if (res.statusCode == 200) {
        var shodetails = json.decode(res.body);

        setState(() {
          for (var data in shodetails["pickuplocation"]["pickup_times"]) {
            allowedDate.add(weekdaytoInt(data["name"]));
          }

          allowedDate = weeksort(allowedDate);

          initalDate = (initalDatefinder(allowedDate));
        });
      }
    }
  }

  String shopname = "";
  String ordertype = "";
  String shopid = "-1";
  String dateSting = "";
  int deliveryConstant = 0;
  List deliveryMethod = ["Shipping", "Pickup"];
  int deliveryMethodSelector = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
    checkFrequency();
    loadCart();
    startLister();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    print(DateTime.sunday);
    Itemtotal = double.parse(Itemtotal.toStringAsFixed(2));
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: w,
          height: h,
          padding: EdgeInsets.all(10),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 63,
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(10),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "My Cart",
                          style: tx700(20, color: Colors.black),
                        ),
                      ),
                      height(30),
                      if (suboptions.isNotEmpty)
                        for (int i = 0; i < suboptions.length; i++)
                          if (cartlist[i].length > 0)
                            Column(
                              children: [
                                Visibility(
                                  visible: (cartlist[i].length > 0),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: appprimarycolor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    child: Row(
                                      children: [
                                        width(20),
                                        Text(
                                          suboptions[i],
                                          style: tx600(16, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                for (cartProductModel model in cartlist[i])
                                  cartProduct(
                                    pdata: model,
                                    notify: widget.notifier,
                                    ischeck: false,
                                  ),
                                Container(
                                  height: 2,
                                  color: Colors.grey.withOpacity(.2),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                              ],
                            ),
                      if (suboptions.isNotEmpty)
                        if (false)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(.7)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.black26))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Billing Address",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Monsterrats",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Address();
                                        },
                                        child: Text(
                                          (addressList.isEmpty)
                                              ? "Add"
                                              : "Change ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: appprimarycolor,
                                              fontFamily: "Monsterrats",
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: appprimarycolor,
                                      ),
                                    ],
                                  ),
                                ),
                                if (addressList.isEmpty)
                                  Container(
                                    height: 120,
                                    child: Center(
                                      child: Text("No Address Avaliable :)",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Monsterrats",
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                if (addressList.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addressList[selectedAddress].title,
                                          style: TextStyle(
                                              fontFamily: "Monsterrats",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          "${addressList[selectedAddress].address}, ${addressList[selectedAddress].state},${addressList[selectedAddress].city} ,${addressList[selectedAddress].zip} ",
                                          style: TextStyle(
                                              fontFamily: "Monsterrats",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      if (suboptions.isNotEmpty)
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(.7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Type",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Monsterrats",
                                    fontWeight: FontWeight.w600),
                              ),
                              height(20),
                              if (!isShiponly)
                                Row(
                                  children: [
                                    for (int i = deliveryConstant;
                                        i < deliveryMethod.length;
                                        i++)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            deliveryMethodSelector = i;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: density(20),
                                              bottom: density(10)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: density(18),
                                              vertical: density(16)),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      density(5)),
                                              border: Border.all(
                                                width:
                                                    (deliveryMethodSelector ==
                                                            i)
                                                        ? 1.5
                                                        : 1,
                                                color:
                                                    (deliveryMethodSelector ==
                                                            i)
                                                        ? appprimarycolor
                                                        : Colors.grey
                                                            .withOpacity(0.4),
                                              )),
                                          child: Text(
                                            (deliveryMethod[i] != "Pickup" ||
                                                    deliveryConstant == 3)
                                                ? "Door Shipping"
                                                : "Shop ${deliveryMethod[i]}",
                                            style: TextStyle(
                                              fontSize: density(13),
                                              color:
                                                  (deliveryMethodSelector == i)
                                                      ? appprimarycolor
                                                      : Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              if (isShiponly)
                                Container(
                                  margin: EdgeInsets.only(
                                      right: density(20), bottom: density(10)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: density(18),
                                      vertical: density(16)),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(density(5)),
                                      border: Border.all(
                                        width: 1.5,
                                        color: appprimarycolor,
                                      )),
                                  child: Text(
                                    "Door Shipping",
                                    style: TextStyle(
                                      fontSize: density(13),
                                      color: appprimarycolor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (ordertype == "pre_order" && Itemtotal > 0)
                        if (allowedDate.isNotEmpty)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(.7),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Pickup Date :",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Monsterrats",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    loadcalender();
                                  },
                                  child: Text(
                                    (dateSting != "")
                                        ? dateSting
                                        : "Add pickup Date",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Monsterrats",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                width(10),
                                InkWell(
                                  onTap: () {
                                    loadcalender();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 19,
                                  ),
                                )
                              ],
                            ),
                          ),
                      if (suboptions.isEmpty)
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 600,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn3.iconfinder.com/data/icons/shopping-and-ecommerce-28/90/empty_cart-512.png",
                                  color: appprimarycolor,
                                ),
                                Text(
                                  "Cart is Empty",
                                  style: tx700(16),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              if (suboptions.isNotEmpty)
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        if (ordertype != "pre_order")
                          verifyProduct();
                        else if (ordertype == "pre_order" && dateSting != "")
                          verifyProduct();
                        else
                          Fluttertoast.showToast(
                              msg: "Please select pickup Date");
                        //   builder: (context) => cart(notify: widget.notifier)));
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appprimarycolor),
                        alignment: Alignment.center,
                        child: (isLoading)
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white, size: 18)
                            : Text(
                                "Checkout  \$$Itemtotal/-",
                                style: tx700(16, color: Colors.white),
                              ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }

  double density(
    double d,
  ) {
    double height = MediaQuery.of(context).size.width;
    double value = d * (height / 390);
    return value;
  }

  verify() async {}
  loadcalender() async {
    final date = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
                primary: appprimarycolor,
                background: Colors.white // <-- SEE HERE
                ),
          ),
          child: child!,
        );
      },
      initialDate: initalDate,
      firstDate: DateTime.now().add(Duration(days: 5)),
      lastDate: initalDate.add(Duration(days: 120)),
      selectableDayPredicate: (day) {
        bool opt = false;

        for (var im in allowedDate) {
          if (im == 0) im = 7;
          if (im == day.weekday) {
            opt = true;
            break;
          }
        }
        return opt;
      },
    );

    setState(() {
      if (date != null) {
        dateSting = DateFormat('dd-MM-yyyy').format(date);
      }
    });
  }

  Address() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (buiilder) {
          return Container(
            //padding: EdgeInsets.all(10),
            constraints: BoxConstraints(
                minHeight: density(205), maxHeight: density(400)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(density(20)),
                    topRight: Radius.circular(density(20)))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  height(density(15)),
                  Row(
                    children: [
                      width(density(10)),
                      SizedBox(
                          height: density(30),
                          width: density(30),
                          child: Icon(
                            Icons.gps_fixed,
                            color: appprimarycolor,
                          )),
                      width(density(10)),
                      Expanded(
                        child: Text("Select Address",
                            style: TextStyle(
                                fontSize: density(18),
                                fontWeight: FontWeight.bold)),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close)),
                      width(20)
                    ],
                  ),
                  height(10),
                  for (int i = deliveryConstant; i < addressList.length; i++)
                    Row(
                      children: [
                        Radio(
                          value: i,
                          toggleable: true,
                          groupValue: selectedAddress,
                          activeColor: appprimarycolor,
                          onChanged: (value) async {
                            setState(() {
                              selectedAddress = int.parse(value.toString());
                            });
                            Navigator.of(context).pop();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setInt("SELECTED-ADDRESS", selectedAddress);
                          },
                        ),
                        Text(
                          addressList[i].address,
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black38.withOpacity(0.4),
                  ),
                  height(25),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      setAdress(buiilder, addressNotify);

                      //Navigator.of(context).push(MaterialPageRoute(
                      // builder: (context) => locationPicker()));
                    },
                    child: Row(
                      children: [
                        width(density(13)),
                        Icon(
                          Icons.add,
                          color: appprimarycolor,
                        ),
                        width(density(8)),
                        Text("Add Address",
                            style: TextStyle(
                                color: appprimarycolor,
                                fontSize: density(18),
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  height(density(20))
                ],
              ),
            ),
          );
        });
  }

  bool isLoading = false;
  verifyProduct() async {
    if (deliveryMethodSelector != -1) {
      setState(() {
        isLoading = true;
      });
      checkoutverify vf = checkoutverify();
      List<Products> prd = [];
      Box box = await Hive.openBox("cart");
      for (var p in box.keys) {
        cartProductModel pd = box.get(p);

        if (pd.quantity > 0) {
          Products p = Products();
          p.deliveryType =
              deliveryMethod[deliveryMethodSelector].toString().toLowerCase();
          p.orderQuantity = pd.quantity;
          p.paymentFrequency = pd.subscriptionID;
          p.productId = pd.id;
          p.subtotal = pd.subTotal;
          p.unitPrice = pd.subTotal / pd.quantity;
          prd.add(p);
        }
      }
      BillingAddress bill = BillingAddress(
          state: addressList[selectedAddress].state,
          streetAddress: addressList[selectedAddress].address,
          zip: addressList[selectedAddress].zip,
          city: addressList[selectedAddress].city,
          country: addressList[selectedAddress].country);
      //  vf.billingAddress = bill;
      //  vf.shippingAddress = bill;
      vf.amount = Itemtotal;
      vf.shippingClassId = "1";
      vf.products = prd;
      print(vf.toJson());
      print(token);

      final Response = await http.post(
          Uri.parse("$baseurl/orders/checkout/verify"),
          body: json.encode(vf.toJson()),
          headers: {
            "content-type": "application/json",
            "authorization": "Bearer $token"
          });
      if (Response.statusCode == 200) {
        print(Response.body);
        var checkOutdata = json.decode(Response.body);
        if (checkOutdata["unavailable_products"].length > 0) {
          setState(() {
            isLoading = false;
          });
          Box product = await Hive.openBox("cart");

          Fluttertoast.showToast(
              msg:
                  "${checkOutdata["unavailable_products"].length} product is unavailable due to out of stock");
          setState(() {
            for (var unproduct in checkOutdata["unavailable_products"]) {}
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print(ordertype);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => cart(
                  notify: widget.notifier,
                  charges: checkOutdata,
                  other: ({
                    "order_type": ordertype,
                    "delivery_type": deliveryMethod[deliveryMethodSelector],
                    "pickup_date": dateSting,
                    "products": prd
                  }))));
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Something went to wrong");
      }
      ;
    } else {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
      Fluttertoast.showToast(msg: "Please select delivery option");
    }
  }
}
