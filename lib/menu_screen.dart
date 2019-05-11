import 'package:flutter/material.dart';
import 'zoom_scaffold.dart';

//this class is used to return the menu screen, which is at the bottom of the stack and is overlayed with the content screen.
class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);

  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  //This is building the complete menu screen
  Widget build(BuildContext context) {
    //what this widget does is that it finds an ancestor of ZoomScaffoldState, get's the menu controller out of it,
    //then passes itinto the builder function, then whatever the builder function returns is rendered.
    //This allows us to render the menu screen with the MenuController, i.e. the menu items can identify which content screen is active,
    //and can now function accordingly. This is also used to close the menu screen when any item is tapped, 
    //maximizing the content screen loaded.
    return ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/dark_grunge_bk.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                createMenuTitle(),
                createMenuItems(menuController),
              ],
            ),
          ),
        );
      },
    );
  }

  //used to create different items to select in the menu
  createMenuItems(MenuController menuController) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        255.0,
        0.0,
      ),
      child: Column(
        children: <Widget>[
          _MenuListItem(
            title: 'THE PADDOCK',
            isSelected: true,
            onTap:() {menuController.close();},
          ),
          _MenuListItem(
            title: 'THE HERO',
            isSelected: false,
            onTap:() {menuController.close();},
          ),
          _MenuListItem(
            title: 'HELP US GROW',
            isSelected: false,
            onTap:() {menuController.close();},
          ),
          _MenuListItem(
            title: 'SETTINGS',
            isSelected: false,
            onTap:() {menuController.close();},
          ),
        ],
      ),
    );
  }

  //this function creates the menu title, and applies transform to it.
  createMenuTitle() {
    return new Transform(
      transform: Matrix4.translationValues(-100.0, 0.0, 0.0),
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Menu',
            style: TextStyle(
              color: const Color(0x88444444),
              fontSize: 240.0,
              fontFamily: 'mermaid',
            ),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}

//Used to build individual menu list items
class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onTap;

  const _MenuListItem({
    Key key,
    this.title,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontSize: 25.0,
              fontFamily: 'bebas-neue',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
