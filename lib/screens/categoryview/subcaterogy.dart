import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:oso/constant/url.dart';

Widget subCatergory() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Image.network(noimage),
        ),
        //Text("Category name")
      ],
    ),
  );
}
