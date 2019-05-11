import 'dart:io';

import 'package:flutter/material.dart';
import 'zoom_scaffold.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'MenuScreen');

//this class is used to return the menu screen, which is at the bottom of the stack and is overlayed with the content screen.
class MenuScreen extends StatefulWidget {
  final Menu menu;
  final String selectedItemId;
  final Function(String) onMenuItemSelected;

  MenuScreen({
    this.menu,
    this.onMenuItemSelected,
    this.selectedItemId,
  }) : super(key: menuScreenKey);

  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;
  double selectorYTop;
  double selectorYBottom;

  setSelectedRenderBox(RenderBox newRenderBox) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      try {
        setState(() {
          selectorYTop = newYTop;
          selectorYBottom = newYBottom;
        });
      } catch (e) {
        //print("exception!");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    titleAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

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

        var shouldRenderSelector = true;
        var actualSelectorYTop = selectorYTop;
        var actualSelectorYBottom = selectorYBottom;
        var selectorOpacity = 1.0;

        if(menuController.state == MenuState.closed || menuController.state == MenuState.closing || selectorYTop == null) {
          final RenderBox menuScreenRenderBox = context.findRenderObject() as RenderBox;
          if(menuScreenRenderBox != null) {
            final menuScreenHeight = menuScreenRenderBox.size.height;
            actualSelectorYTop = menuScreenHeight - 50.0;
            actualSelectorYBottom = menuScreenHeight;
            selectorOpacity = 0.0;
          } else {
            shouldRenderSelector = false;
          }
        }

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
                createMenuTitle(menuController),
                createMenuItems(menuController),
                shouldRenderSelector
                ? ItemSelector(
                    topY: actualSelectorYTop,
                    bottomY: actualSelectorYBottom,
                    opacity: selectorOpacity,
                  )
                : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  //used to create different items to select in the menu
  createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay =
        menuController.state != MenuState.closing ? 0.15 : 0.0;
    for (var i = 0; i < widget.menu.items.length; i++) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd =
          animationIntervalStart + animationIntervalDuration;
      final isSelected = widget.menu.items[i].id == widget.selectedItemId;

      listItems.add(
        AnimatedMenuListItem(
          menuState: menuController.state,
          isSelected: isSelected,
          duration: const Duration(milliseconds: 600),
          curve: Interval(
            animationIntervalStart,
            animationIntervalEnd,
            curve: Curves.easeOut,
          ),
          menuListItem: _MenuListItem(
            title: widget.menu.items[i].title,
            isSelected: isSelected,
            onTap: () {
              widget.onMenuItemSelected(widget.menu.items[i].id);
              menuController.close();
            },
          ),
        ),
      );
    }

    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        255.0,
        0.0,
      ),
      child: Column(
        children: listItems,
      ),
    );
  }

  //this function creates the menu title, and applies transform to it.
  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return AnimatedBuilder(
      animation: titleAnimationController,

      //this is the text part that doesn't change
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Menu',
            style: TextStyle(
              color: const Color(0x88444444),
              fontSize: 250.0,
              fontFamily: 'mermaid',
            ),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),

      //this is the animated part which is animated anytime the animation runs.
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.translationValues(
            250.0 * (1.0 - titleAnimationController.value) - 100.0,
            0.0,
            0.0,
          ),
          child: child,
        );
      },
    );
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double topY;
  final double bottomY;
  final double opacity;

  ItemSelector({
    this.bottomY,
    this.opacity,
    this.topY,
  }) : super(duration: const Duration(milliseconds: 250));

  _ItemSelectorState createState() => _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(visitor) {
    _topY = visitor(
      _topY,
      widget.topY,
      (dynamic value) => new Tween<double>(begin: value),
    );
    _bottomY = visitor(
      _bottomY,
      widget.bottomY,
      (dynamic value) => new Tween<double>(begin: value),
    );
    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topY.evaluate(animation),
      child: Opacity(
        opacity: _opacity.evaluate(animation),
        child: Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}

//These widgets say "something about me is animate-able".
class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final Duration duration;
  final bool isSelected;

  AnimatedMenuListItem({
    this.duration,
    this.menuListItem,
    this.menuState,
    curve,
    this.isSelected,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => _AnimatedMenuListItemState();
}

//This class gives us machinery to automatically calculate the animation values.
class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  //used to find the position in render tree of the menu item to draw the rectangular selector.
  updateSelectedRenderBox() {
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null && widget.isSelected) {
      //print("renderbox size: ${renderBox.localToGlobal(const Offset(0.0, 0.0))}");
      (menuScreenKey.currentState as _MenuScreenState)
          .setSelectedRenderBox(renderBox);
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();
    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: Transform(
        transform: Matrix4.translationValues(
            0.0, _translation.evaluate(animation), 0.0),
        child: widget.menuListItem,
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

class Menu {
  final List<MenuItem> items;

  Menu({
    this.items,
  });
}

class MenuItem {
  final String id;
  final String title;

  MenuItem({
    this.title,
    this.id,
  });
}
