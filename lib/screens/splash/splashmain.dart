import 'package:flutter/material.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/screens/login/loginMain.dart';
import 'package:oso/screens/login/otp.dart';
import 'package:oso/supporter/sizesupporter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';

class SplashMain extends StatelessWidget {
  SplashMain({super.key});

  checkLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String check = pref.getString("LOGIN").toString();
    if (check == "null" || check == "OUT") {
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => signup())));

      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => signup())));
    } else if (check == "SKIP") {
      Navigator.pop(context);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => HomeMain())));
    } else {
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => HomeMain())));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return Scaffold(
      backgroundColor: appcolorBackground,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 300,
                child: Image.asset(
                  "assets/images/splash_icon.png",
                )),
            height(34),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 41),
              child: Text(
                "Welcome to Our Street of India",
                style: tx700(18),
                textAlign: TextAlign.center,
              ),
            ),
            height(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Please provide your delivery location to see product at nearby store",
                style: tx500(
                  14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            height(40),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => login()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appprimarycolor),
                child: Text(
                  "Get Started",
                  style: tx600(14.5, color: appcolorBackground),
                ),
              ),
            ),
            height(40),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => login()));
              },
              child: Text(
                "Enter Location Manually",
                style: tx600(12, color: appprimarycolor.withOpacity(.8)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
