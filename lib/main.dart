import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oso/constant/colors.dart';
import 'package:oso/datamodel/cartmodel.dart';
import 'package:oso/screens/home/homemain.dart';
import 'package:oso/screens/login/loginMain.dart';
import 'package:oso/screens/splash/splashmain.dart';
import 'package:oso/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datamodel/adressData.dart';
import 'datamodel/userData.dart';

String check = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  check = pref.getString("LOGIN").toString();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(cartProductModelAdapter().typeId)) {
    Hive.registerAdapter(cartProductModelAdapter());
  }
  if (!Hive.isAdapterRegistered(userDataAdapter().typeId)) {
    Hive.registerAdapter(userDataAdapter());
  }
  if (!Hive.isAdapterRegistered(addressDataAdapter().typeId)) {
    Hive.registerAdapter(addressDataAdapter());
  }
  Stripe.publishableKey =
      "pk_test_51Mo0uKSJgjAhCvZujMyY5HVghvuxqf06AxE4WCL1byJILtOvHSTSCirPkLM0lsQG6I9FMxKn2TO6d5ecWsNTElLj00tpvQn16V";
  runApp(oso());
}

class oso extends StatelessWidget {
  const oso({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: appprimarycolor,
          primaryColorDark: appprimarycolor,
          datePickerTheme: DatePickerThemeData(
            backgroundColor: appprimarycolor,
          )),
      darkTheme: ThemeData(primaryColorDark: appprimarycolor),
      home: (check == "IN") ? HomeMain() : SplashMain(),
    );
  }
}
