//this widget class is used to create a kind of zooming in-out UI in which there 2 pages,
//the menu page and the current active page.

import 'package:flutter/material.dart';
import 'menu/menu_controller.dart';
import 'content_screens/screen.dart';

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

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;

  //when we scale down from 100% to 80% page widget size, that animation happens in the first 30% time of the overall animation.
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);

  //Scale up from 80% to 100% page widget size take it's complete time.
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  //page widget slide out time
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  //page widget slide in time
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

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
              onPressed: () {
                menuController.toggle();
              },
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
    
    //used to set speeds on menu opening and closing.
    var slidePercent, scalePercent;
    switch(menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }


    final slideAmount = 240.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * menuController.percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
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
          borderRadius: BorderRadius.circular(cornerRadius),
          child: content,
        ),
      ),
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  _ZoomScaffoldMenuControllerState createState() => _ZoomScaffoldMenuControllerState();
}

class _ZoomScaffoldMenuControllerState extends State<ZoomScaffoldMenuController> {

  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);

    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState =
        context.ancestorStateOfType(TypeMatcher<_ZoomScaffoldState>())
            as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }
 
  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }
}

//there's a function that takes in a BuildContext and a MenuController and return a widget, and we're calling it ZoomScaffoldBuilder.
//The menu system provides one of these functions, so that we can give the menu a MenuController.
//This will let the menu options access the content screen they are part of.
typedef Widget ZoomScaffoldBuilder(
  BuildContext context,
  MenuController menuController,
);

//This class is used to update the contents of the screen without creating a new page, so that the widget hierarchy is maintained,
//i.e. the screen is at the top.
