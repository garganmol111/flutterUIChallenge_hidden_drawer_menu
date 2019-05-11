import 'package:flutter/material.dart';

//This class is used to update the contents of the screen without creating a new page, so that the widget hierarchy is maintained,
//i.e. the screen is at the top.

class Screen {
  final String title;
  final DecorationImage background;
  final WidgetBuilder contentBuilder;

  Screen({
    this.title,
    this.background,
    this.contentBuilder
  });
}