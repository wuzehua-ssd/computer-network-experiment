import 'dart:ui';

import 'package:flutter/material.dart';

// 软件主题颜色
var _main_color = Colors.blue;

Color getMainColor() {
  return _main_color;
}

setMainColor(Color c) {
  _main_color = c;
}