import 'package:flutter/material.dart';

TextStyle tx700(double size, {Color color = Colors.black54}) => TextStyle(
      fontSize: size,
      color: color,
      fontFamily: "poppins",
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w700,
    );

TextStyle tx500(double size, {Color color = Colors.black54}) => TextStyle(
    fontSize: size,
    fontFamily: "poppins",
    color: color,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none);

TextStyle tx600(double size, {Color color = Colors.black54}) => TextStyle(
    fontSize: size,
    fontFamily: "poppins",
    color: color,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none);
TextStyle tx400(double size, {Color color = Colors.black54}) => TextStyle(
    fontSize: size,
    fontFamily: "poppins",
    color: color,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none);
