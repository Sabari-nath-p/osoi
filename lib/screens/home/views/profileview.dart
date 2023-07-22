import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/screens/home/views/homeview.dart';
import 'package:oso/screens/login/loginMain.dart';
import 'package:oso/screens/subscription/subscriptionList.dart';
import 'package:oso/screens/subscription/subscriptionMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/url.dart';
import '../../../datamodel/adressData.dart';
import '../../../datamodel/userData.dart';
import '../../../supporter/sizesupporter.dart';
import '../../../test/myAddress.dart';
import '../../../test/order.dart';
import '../../../test/personal.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
    listenprofile();
  }

  String name = "";
  String ppUrl =
      "http://api.ecom.alpha.logidots.com/storage/3051/conversions/R-thumbnail.jpg";
  String Total = "";
  String token = "";
  String usedCoin = "";
  String available = "";
  late userData personalData;
  int pid = 0;
  ValueNotifier<int> profileUpdate = ValueNotifier(0);

  listenprofile() {
    profileUpdate.addListener(() {
      loadUser();
    });
  }

  loadUser() async {
    Box box = await Hive.openBox("user");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String mobile = pref.getString("mobile").toString();
    token = pref.getString("TOKEN").toString();

    final response = await http.get(Uri.parse("$baseurl/me"),
        headers: ({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(token);

    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
      var js = json.decode(response.body);
      List<addressData> adata = [];
      for (var address in js["address"]) {
        addressData ad = addressData(
            address: (address["address"]["street_address"] != null)
                ? address["address"]["street_address"]
                : "test address",
            city: address["address"]["city"],
            country: address["address"]["country"],
            details: "nil",
            state: address["address"]["state"],
            zip: address["address"]["zip"],
            title: address["title"],
            id: address["id"]);
        adata.add(ad);
      }

      if (js["profile"] != null) ppUrl = js["profile"]["avatar"]["thumbnail"];

      String profileUrl = ppUrl;

      userData udata = new userData(
          name: js["name"],
          email: js["email"],
          id: js['id'],
          phone: mobile,
          address: adata,
          profileUrl: ppUrl,
          availablePoint: js["wallet"]["available_points"]);
      name = udata.name;
      Total = js["wallet"]["total_points"].toString();
      available = js["wallet"]["available_points"].toString();
      usedCoin = js["wallet"]["points_used"].toString();
      pid = js['id']; //js["profile"]["id"];
      box.put(1, udata);
      personalData = udata;

      setState(() {
        loading = 1;
      });
    }
  }

  int loading = 0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: (loading == 1)
              ? Container(
                  height: h,
                  width: w,
                  color: appprimarycolor,
                  child: Column(
                    children: [
                      Container(
                        height: density(238),
                        width: w,
                        child: Stack(
                          children: [
                            Positioned(
                                left: density(100),
                                right: density(100),
                                top: density(30),
                                height: density(100),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white)),
                                  child: CircleAvatar(
                                    backgroundColor: (ppUrl ==
                                            "http://api.ecom.alpha.logidots.com/storage/3051/conversions/R-thumbnail.jpg")
                                        ? Colors.white24
                                        : Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(
                                        width: density(95),
                                        height: density(95),
                                        child: Image.network(
                                          ppUrl,
                                          color: (ppUrl ==
                                                  "http://api.ecom.alpha.logidots.com/storage/3051/conversions/R-thumbnail.jpg")
                                              ? Colors.white
                                              : null,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Positioned(
                                left: density(80),
                                right: density(80),
                                top: density(135),
                                height: density(100),
                                child: Text(
                                  "$name",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                )),
                            Positioned(
                                top: density(170),
                                left: density(55),
                                right: density(55),
                                child: Container(
                                  width: density(263),
                                  height: density(65),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.black12.withOpacity(0.07),
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: Colors.yellowAccent
                                              .withOpacity(.2))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      coinBox("$available", "Available"),
                                      Container(
                                        width: 1,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        height: double.infinity,
                                        color: Colors.white10,
                                      ),
                                      coinBox("$usedCoin", "Used"),
                                      Container(
                                        width: 1,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        height: double.infinity,
                                        color: Colors.white10,
                                      ),
                                      coinBox("$Total", "Total"),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      height(25),
                      Expanded(
                        child: Container(
                          width: w,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35))),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                height(25),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: ((context) => Personal(
                                                  udata: personalData,
                                                  profileNotify: profileUpdate,
                                                  pid: pid,
                                                ))));
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        width(5),
                                        SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                "assets/images/profileDetails.png")),
                                        width(10),
                                        Expanded(
                                          child: Text(
                                            "Profile details",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                        ),
                                        width(
                                          10,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                height(15),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: ((context) => orderScreen(
                                                  token: token,
                                                ))));
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        width(5),
                                        SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                "assets/images/myOrder.png")),
                                        width(10),
                                        Expanded(
                                          child: Text(
                                            "My Order",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                        ),
                                        width(
                                          10,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                height(15),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                subscriptionList())));
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        width(5),
                                        SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                              "assets/images/myAddress.png",
                                              fit: BoxFit.fill,
                                            )),
                                        width(10),
                                        Expanded(
                                          child: Text(
                                            "My Subscription",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                        ),
                                        width(
                                          10,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                height(15),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: ((context) => myAddress(
                                                  token: token,
                                                ))));
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        width(5),
                                        SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                              "assets/images/myAddress.png",
                                              fit: BoxFit.fill,
                                            )),
                                        width(10),
                                        Expanded(
                                          child: Text(
                                            "My Address",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                        ),
                                        width(
                                          10,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                height(18),
                                //    if (false)
                                InkWell(
                                  onTap: () async {
                                    if (!await launchUrl(Uri.parse(
                                        "https://designlondon.alpha.logidots.com/privacy"))) {}
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        width(5),
                                        SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                              "assets/images/policy.png",
                                              fit: BoxFit.fill,
                                            )),
                                        width(10),
                                        Expanded(
                                          child: Text(
                                            "Policy & Rules",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                        ),
                                        width(
                                          10,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: 390,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.white, width: 10)),
                          padding: EdgeInsets.only(left: 22, bottom: 22),
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => signup())));
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              Box box = await Hive.openBox("user");
                              box.deleteFromDisk();
                              pref.setString("LOGIN", "OUT");
                              isLogged = false;
                              profileUrl =
                                  "http://api.ecom.alpha.logidots.com/storage/3051/conversions/R-thumbnail.jpg";
                            },
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 16,
                                color: appprimarycolor,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: appprimarycolor, size: 40),
                )),
    );
  }

  coinBox(String point, String type) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (false)
                  SizedBox(
                    width: density(20),
                    height: density(20),
                    child: Image.asset("assets/icons/coin.png"),
                  ),
                Text(
                  "$point",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Montserrat",
                      color: Colors.white),
                )
              ],
            ),
            Text(
              "$type",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  fontFamily: "Montserrat",
                  color: Colors.white.withOpacity(.8)),
            )
          ],
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
}
