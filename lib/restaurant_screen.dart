import 'package:flutter/material.dart';
import 'zoom_scaffold.dart';
import 'restaurant_card.dart';

//This contains the values of the home restaurant screen.

final Screen restaurantScreen = new Screen(
  title: 'THE PALEO PADDOCK',
  background: DecorationImage(
    image: AssetImage('assets/wood_bk.jpg'),
    fit: BoxFit.cover,
  ),
  contentBuilder: (BuildContext context) {
    return ListView(
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
        );
  }
);