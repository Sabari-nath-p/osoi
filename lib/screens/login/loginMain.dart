import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:http/http.dart' as http;
import 'package:oso/constant/url.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/screens/login/login.dart';
import 'package:oso/screens/login/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../supporter/sizesupporter.dart';

class signup extends StatefulWidget {
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController nameText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  bool ispassword = true;
  bool isLoading = false;
  bool isLogin = false;

  double temp = (24.5).roundToDouble();
  double fem = 0;
  double ffem = 0;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.8;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Container(
            // loginTBL (9:229)
            //  padding: EdgeInsets.fromLTRB(25 * fem, 26 * fem, 25 * fem, 256 * fem),
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(60 * fem),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 150,
                      child: Image.asset(
                        "assets/images/splash_icon.png",
                      )),
                  height(20),
                  Container(
                    // frame162519a2z (9:230)
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 41),
                          child: Text(
                            "Welcome Back",
                            style: tx700(18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        height(20),
                        Container(
                          // inputfieldcVU (9:234)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 10 * fem),
                          padding: EdgeInsets.fromLTRB(
                              20 * fem, 22 * fem, 22.5 * fem, 22 * fem),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xfff9fafb),
                            borderRadius: BorderRadius.circular(20 * fem),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  // frame511037SE (9:235)
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  )),
                              Expanded(
                                  child: TextField(
                                controller: emailText,
                                style: tx500(14, color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    isCollapsed: true,
                                    hintText: "Enter Email",
                                    hintStyle:
                                        tx500(15, color: Color(0xff979797))),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          // inputfieldcVU (9:234)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 10 * fem),
                          padding: EdgeInsets.fromLTRB(
                              20 * fem, 22 * fem, 22.5 * fem, 22 * fem),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xfff9fafb),
                            borderRadius: BorderRadius.circular(20 * fem),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  // frame511037SE (9:235)
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                  child: Icon(
                                    Icons.password,
                                    color: Colors.grey,
                                  )),
                              Expanded(
                                  child: TextField(
                                obscureText: !ispassword,
                                textAlign: TextAlign.start,
                                controller: passwordText,
                                style: tx500(14, color: Colors.black),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    isCollapsed: true,
                                    hintText: "Enter Password",
                                    hintStyle:
                                        tx500(14, color: Color(0xff979797))),
                              )),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    ispassword = !ispassword;
                                  });
                                },
                                child: (ispassword)
                                    ? Icon(Icons.visibility_off,
                                        color: Colors.grey)
                                    : Icon(
                                        Icons.visibility,
                                        color: Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLogin)
                          Container(
                            // inputfieldcVU (9:234)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 19 * fem),
                            padding: EdgeInsets.fromLTRB(
                                20 * fem, 22 * fem, 83.5 * fem, 22 * fem),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xfff9fafb),
                              borderRadius: BorderRadius.circular(20 * fem),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    // frame511037SE (9:235)
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 10 * fem, 0 * fem),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    )),
                                Expanded(
                                    child: TextField(
                                  controller: nameText,
                                  style: tx500(14, color: Colors.black),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      isCollapsed: true,
                                      hintText: "Enter Name",
                                      hintStyle: tx500(16, color: Colors.grey)),
                                ))
                              ],
                            ),
                          ),
                        if (isLogin)
                          InkWell(
                            onTap: () {
                              if (passwordText.text.isNotEmpty &&
                                  emailText.text.isNotEmpty) {
                                userLogin(passwordText.text.trim(),
                                    emailText.text.trim());
                              } else {
                                Fluttertoast.showToast(msg: "Please fill");
                              }
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              margin: EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: (isLoading)
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.white, size: 25)
                                  : Text("sign In",
                                      style: tx500(15, color: Colors.white)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: appprimarycolor),
                            ),
                          ),
                        if (!isLogin)
                          InkWell(
                            onTap: () {
                              if (nameText.text.isNotEmpty &&
                                  passwordText.text.isNotEmpty &&
                                  emailText.text.isNotEmpty) {
                                registeraccount(
                                    nameText.text.trim(),
                                    passwordText.text.trim(),
                                    emailText.text.trim());
                              } else {
                                Fluttertoast.showToast(msg: "Please fill");
                              }
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              margin: EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: (isLoading)
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.white, size: 25)
                                  : Text("Sign Up",
                                      style: tx500(15, color: Colors.white)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: appprimarycolor),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!isLogin)
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already Have an Account?',
                                  style: tx500(14),
                                ),
                                Text(' ', style: tx500(14)),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLogin = !isLogin;
                                    });
                                  },
                                  child: Text('Sign in', style: tx500(14)),
                                ),
                              ],
                            ),
                          ),
                        if (isLogin)
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'you, didn\'t have an account?',
                                  style: tx500(14),
                                ),
                                Text(' ',
                                    style: tx500(14, color: Color(0xff767a8a))),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLogin = !isLogin;
                                    });
                                  },
                                  child: Text('Sign up', style: tx500(14)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  height(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          final googleSignIn = await GoogleSignIn(
                                  clientId:
                                      "74093371214-qr7ge0lbit4ec367dk4b96usidhaj11j.apps.googleusercontent.com",
                                  serverClientId:
                                      "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")
                              .signIn();
                          print(googleSignIn!.email.toString());
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(.09)),
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                                "https://i.pinimg.com/originals/8c/03/0b/8c030bd6bd7ee87ad41485e3c7598dd4.png"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final LoginResult result = await FacebookAuth.instance
                              .login(); // by default we request the email and the public profile
                          // or FacebookAuth.i.login()
                          if (result.status == LoginStatus.success) {
                            // you are logged
                            final AccessToken accessToken = result.accessToken!;
                            print(accessToken);
                          } else {
                            print(result.status);
                            print(result.message);
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(.09)),
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                                "https://logodownload.org/wp-content/uploads/2014/09/facebook-logo-0.png"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => login()));
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(.09)),
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                                "https://bridgecareersolution.com/wp-content/uploads/elementor/thumbs/0e475bb9b17b3fa4f94f31fba1635b8f-telephone-call-icon-logo-by-vexels-5-p3ac38syv1opsr5kquw7vp6sgyhkyzubkh0ld5b228.png"),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  registeraccount(String name, String password, String email) async {
    setState(() {
      isLoading = true;
    });

    final Respones = await http.post(Uri.parse("$baseurl/register"),
        headers: ({"Accept": "application/json"}),
        body: ({"name": name, "email": email, "password": password}));

    if (Respones.statusCode == 200 || Respones.statusCode == 201) {
      var js = json.decode(Respones.body);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("TOKEN", js["token"]);
      preferences.setString("LOGIN", "IN");
      testuer(js["token"], "");

      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => HomeMain())));
    } else {
      setState(() {
        print(Respones.body);
        var js = json.decode(Respones.body);

        if (js["email"] != null)
          Fluttertoast.showToast(msg: js["email"][0]);
        else
          Fluttertoast.showToast(msg: "Something went wrong, Please retry");
        isLoading = false;
      });
    }
  }

  userLogin(String password, String email) async {
    setState(() {
      isLoading = true;
    });

    final Respones = await http.post(Uri.parse("$baseurl/token"),
        headers: ({"Accept": "application/json"}),
        body: ({"email": email, "password": password}));

    if (Respones.statusCode == 200 || Respones.statusCode == 201) {
      var js = json.decode(Respones.body);
      if (js["token"] != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("TOKEN", js["token"]);
        preferences.setString("LOGIN", "IN");
        testuer(js["token"], "");

        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => HomeMain())));
      } else {
        Fluttertoast.showToast(msg: "Invalid Credentials");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        print(Respones.body);
        var js = json.decode(Respones.body);

        if (js["email"] != null)
          Fluttertoast.showToast(msg: js["email"][0]);
        else
          Fluttertoast.showToast(msg: "Something went wrong, Please retry");
        isLoading = false;
      });
    }
  }
}
