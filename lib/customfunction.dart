import 'package:flutter/cupertino.dart';
import 'package:oso/screens/home/views/homeview.dart';

double ToFixed(double value, {int decimal = 2}) {
  return double.parse(value.toStringAsFixed(decimal));
}

class HomeNotifier extends ChangeNotifier {
  String currentZip = "";
  ValueNotifier notifier = ValueNotifier(10);
  List zip = [];
  Widget currentwidget = Container();


  updateWidget(Widget widget) {
    currentwidget = widget;
    notifyListeners();
  }
}
