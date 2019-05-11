import 'package:flutter/material.dart';
import 'zoom_scaffold.dart';
import 'content_screens/other_screen.dart';
import 'content_screens/restaurant_screen.dart';
import 'menu_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final menu = Menu(
    items: [
      MenuItem(
        id: 'restaurant',
        title: 'THE PADDOCK',
      ),
      MenuItem(
        id: 'other1',
        title: 'THE HERO',
      ),
      MenuItem(
        id: 'other2',
        title: 'HELP US GROW',
      ),
      MenuItem(
        id: 'other3',
        title: 'SETTINGS',
      ),
    ],
  );

  var activeScreen = restaurantScreen;
  var selectedMenuItemId = 'restaurant';

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      menuScreen: MenuScreen(
        menu: menu,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemId = itemId;
          if(itemId == 'restaurant') {
            setState(() => activeScreen = restaurantScreen);
          } else {
            setState(() => activeScreen = otherScreen);
          }
          
        },
      ),
      contentScreen: activeScreen,
    );
  }
}
