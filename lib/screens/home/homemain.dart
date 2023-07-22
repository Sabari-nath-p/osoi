import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/constant/textstyles.dart';
import 'package:oso/screens/home/components/locationSelector.dart';
import 'package:oso/screens/home/views/cartview.dart';
import 'package:oso/screens/home/views/categoryview.dart';
import 'package:oso/screens/home/views/homeview.dart';
import 'package:oso/screens/home/views/profileview.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:http/http.dart' as http;

import '../../constant/url.dart';

TextEditingController locCOntroller = TextEditingController();
bool isLogged = false;
String profileUrl =
    "http://api.ecom.alpha.logidots.com/storage/3051/conversions/R-thumbnail.jpg";
TextEditingController SelectedZip = TextEditingController();

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadsetup();
  }

  List<String> zip = [];
  List<String> zipname = [];

  ValueNotifier notifier = ValueNotifier(10);

  loadsetup() async {
    listernNotifier();
    await Future.delayed(Duration(milliseconds: 500));
    location();
  }

  listernNotifier() {
    notifier.addListener(() {
      if (notifier.value != 10) setState(() {});

      print("Value updated in hmoe page");
    });
  }

  location() async {
    final Response =
        await http.get(Uri.parse("${baseurl}/api/service-locations"));
    if (Response.statusCode == 200) {
      var res = json.decode(Response.body);
      zip.clear();
      zipname.clear();
      for (var data in res["data"]) {
        ;
        zip.add("${data["zip_code"]} ${data["location_name"]}");
      }
      locationSelector(context, zip, SelectedZip, notifier);
    }
  }

  PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    print(SelectedZip.text);
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [

            
            HomeView(
              selectedZip: SelectedZip.text.split(" ")[0],
              notifier: notifier,
              zipName: zip,
            ),
            categoryview(zipCode: SelectedZip.text.split(" ")[0]),
            cartview(
              selectedZip: SelectedZip.text.split(" ")[0],
              notifier: notifier,
              zipName: zip,
            ),
            profileScreen()
          ],
          onPageChanged: (index) {
            // Use a better state management solution
            // setState is used for simplicity
            setState(() => _currentPage = index);
          },
        ),
        bottomNavigationBar: BottomBar(
          selectedIndex: _currentPage,
          onTap: (int index) {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
            // if (index == 1) locationSelector(context, zip, SelectedZip);
            ;
          },
          items: <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
                style: tx500(16),
              ),
              activeColor: appprimarycolor,
            ),
            BottomBarItem(
              icon: Icon(Icons.category),
              title: Text('Category'),
              activeColor: appprimarycolor,
            ),
            BottomBarItem(
              icon: Icon(Icons.shopping_bag),
              title: Text('Cart'),
              activeColor: appprimarycolor,
            ),
            BottomBarItem(
              icon: Icon(Icons.person),
              title: Text('Account'),
              activeColor: appprimarycolor,
            ),
          ],
        ),
      ),
    );
  }
}
