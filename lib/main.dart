import 'package:flutter/material.dart';
import 'zoom_scaffold.dart';
import 'other_screen.dart';
import 'restaurant_screen.dart';
import 'menu_screen.dart';

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
      home: MyHomePage(title: 'THE PALEO PADDOCK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var activeScreen = restaurantScreen;

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      contentScreen: activeScreen,
      menuScreen: MenuScreen(),
    );
  }
}
