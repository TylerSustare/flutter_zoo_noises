import 'dart:math';
import 'package:flutter/material.dart';

List<MaterialColor> colors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.cyan,
  Colors.teal,
];

MaterialColor getColor([MaterialColor currentColor = Colors.teal]) {
  var color = colors[Random().nextInt(colors.length)];
  while (currentColor == color) {
    color = colors[Random().nextInt(colors.length)];
  }
  return color;
}
