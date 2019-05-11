import 'package:flutter/material.dart';
import 'restaurant_card.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/wood_bk.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'bebas-neue',
              fontSize: 25.0,
            ),
          ),
          centerTitle: true,

          //view or widget on the left side of the widget, in this case the app bar. used to add the menu icon
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        body: ListView(
          children: <Widget>[

            RestaurantCard(
              headImageAssetPath: 'assets/eggs_in_skillet.jpg',
              icon: Icons.fastfood,
              iconBackgroundColor: Colors.orange,
              title: 'il domacca',
              subtitle: "78 5TH AVENUE, NEW YORK",
              heartCount: 84,
            ),

            RestaurantCard(
              headImageAssetPath: 'assets/steak_on_cooktop.jpg',
              icon: Icons.local_dining,
              iconBackgroundColor: Colors.red,
              title: 'Mc Grady',
              subtitle: "79 5TH AVENUE, NEW YORK",
              heartCount: 84,
            ),

            RestaurantCard(
              headImageAssetPath: 'assets/spoons_of_spices.jpg',
              icon: Icons.fastfood,
              iconBackgroundColor: Colors.purpleAccent,
              title: 'Sugar & Spice',
              subtitle: "80 5TH AVENUE, NEW YORK",
              heartCount: 84,
            ),
          ],
        ),
      ),
    );
  }
}

