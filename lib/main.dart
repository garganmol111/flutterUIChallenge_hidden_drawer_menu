import 'package:flutter/material.dart';
import 'src_hidden_drawer_menu/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THE PALEO PADDOCK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'THE PALEO PADDOCK'),
    );
  }
}

