//this widget class is used to create a kind of zooming in-out UI in which there 2 pages,
//the menu page and the current active page.

import 'package:flutter/material.dart';
import 'menu_screen.dart';

class ZoomScaffold extends StatefulWidget {
  //content screen is not a widget because we are imposing a particular visual structure on the page widget.
  //this helps us in changing the page structure on-the-fly
  final Screen contentScreen;
  final Widget menuScreen;

  ZoomScaffold({
    Key key,
    this.contentScreen,
    this.menuScreen,
  }) : super(key: key);

  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.menuScreen,
        createContentDisplay(),
      ],
    );
  }

  //this function returns the content screen, which can be constantly updated with new content.
  //this screen is at the top of the stack, and overlays the menu screen.
  createContentDisplay() {
    return zoomAndSlideContent(
      Container(
        decoration: BoxDecoration(
          image: widget.contentScreen.background,
        ),
        child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              widget.contentScreen.title,
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
          body: widget.contentScreen.contentBuilder(context),
        ),
      ),
    );
  }

  //to add the sliding animation
  //we are taking the whole content, scaling it down to 80% of it's size, then sliding it to the right.
  zoomAndSlideContent(Widget content) {
    return Transform(
      transform: Matrix4.translationValues(240.0, 0.0, 0.0)..scale(0.8, 0.8),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: const Color(0x44000000),
              offset: const Offset(0.0, 5.0),
              blurRadius: 20.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: content,
        ),
      ),
    );
  }
}

//This class is used to update the contents of the screen without creating a new page, so that the widget hierarchy is maintained,
//i.e. the screen is at the top.

class Screen {
  final String title;
  final DecorationImage background;
  final WidgetBuilder contentBuilder;

  Screen({this.title, this.background, this.contentBuilder});
}
