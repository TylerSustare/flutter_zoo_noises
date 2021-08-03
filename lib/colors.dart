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
  Colors.cyan
];

MaterialColor getColor() {
  return colors[Random().nextInt(colors.length)];
}
