import 'package:flutter/material.dart';

Widget show(bool isTrue, [Widget child = const SizedBox()]) {
  return isTrue ? child : SizedBox();
}
