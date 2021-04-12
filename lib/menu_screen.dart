import 'package:flutter/material.dart';
import 'package:restaurant/zoom_scaffold.dart';

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final selectedItemId;
  final Function(String) onMenuItemSelected;
  MenuScreen({this.menu,this.selectedItemId, this.onMenuItemSelected});
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;

  @override
  void initState() {
    super.initState();
    titleAnimationController = new AnimationController(
        duration: Duration(milliseconds: 250), vsync: this);
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
        break;
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
        break;
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return AnimatedBuilder(
        animation: titleAnimationController,
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              'Menu',
              style: TextStyle(
                  color: Color(0x80444444),
                  fontFamily: 'marmaid',
                  fontSize: 240.0),
              textAlign: TextAlign.left,
              softWrap: false,
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return Transform(
            transform: Matrix4.translationValues(
                250.0 * (1.0 - titleAnimationController.value) - 100.0,
                0.0,
                0.0),
            child: child,
          );
        });
  }

  createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];
     final animationIntervalDuration = 0.5;
    final perListItemDelay =
        menuController.state != MenuState.closing ? 0.15 : 0.0;
    for (var i = 0; i < widget.menu.items.length; i++) {
      final animationIntervalStart = i * perListItemDelay;
      final animationInatervalEnd =
          animationIntervalStart + animationIntervalDuration;
      listItems.add(AnimateMenuListItem(
        menuState: menuController.state,
        duration: Duration(milliseconds: 600),
        curve: Interval(animationIntervalStart, animationInatervalEnd,
            curve: Curves.easeOut),
        menuListItem: _MenuListItem(
          title: widget.menu.items[i].title,
          isSelected:widget.menu.items[i].id==widget.selectedItemId,
          ontap: () {
            widget.onMenuItemSelected(widget.menu.items[i].id);
            menuController.close();
          },
          //selectedColor: Colors.blue,
          //freeColor: Colors.white
        ),
      ));
    }

    return Transform(
      transform: new Matrix4.translationValues(0.0, 225.0, 0.0),
      child: Column(
        children:
            listItems, /*<Widget>[
           AnimateMenuListItem(
            menuState: menuController.state,
            duration: Duration(milliseconds: 600),
            curve: Interval(0.0, 0.5, curve: Curves.easeOut),
            menuListItem: _MenuListItem(
              title: 'Primera Opcion',
              isSelected: false,
              ontap: () {
                menuController.close();
              },
              //selectedColor: Colors.blue,
              //freeColor: Colors.white
            ),
          ),
          AnimateMenuListItem(
            menuState: menuController.state,
            duration: Duration(milliseconds: 600),
            curve: Interval(0.15, 0.65, curve: Curves.easeOut),
            menuListItem: _MenuListItem(
              title: 'Segunda Opcion',
              isSelected: false,
              ontap: () {
                menuController.close();
              },
              //selectedColor: Colors.blue,
              //freeColor: Colors.white
            ),
          ),
          AnimateMenuListItem(
              menuState: menuController.state,
              duration: Duration(milliseconds: 600),
              curve: Interval(0.25, 0.75, curve: Curves.easeOut),
              menuListItem: _MenuListItem(
                title: 'Tercera Opcion',
                isSelected: false,
                ontap: () {
                  menuController.close();
                },
                //selectedColor: Colors.blue,
                //freeColor: Colors.white
              )),
          AnimateMenuListItem(
            menuState: menuController.state,
            duration: Duration(milliseconds: 600),
            curve: Interval(0.35, 0.85, curve: Curves.easeOut),
            menuListItem: _MenuListItem(
              title: 'Cuarta Opcion',
              isSelected: false,
              ontap: () {
                menuController.close();
              },
              //selectedColor: Colors.blue,
              //freeColor: Colors.white
            ),
          ),
         
        ],*/
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZoomScaffoldMenuController(
        builder: (BuildContext context, MenuController menuController) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backgrond_global2.jpg'),
                  fit: BoxFit.cover)),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                createMenuTitle(menuController),
                createMenuItems(menuController)
              ],
            ),
          ));
    });
  }
}

class AnimateMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final Duration duration;

  AnimateMenuListItem({
    this.menuListItem,
    this.menuState,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimateMenuListItemState createState() => _AnimateMenuListItemState();
}

class _AnimateMenuListItemState
    extends AnimatedWidgetBaseState<AnimateMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  @override
  void forEachTween(visitor) {
    var slide, opacity;
    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }
    _translation = visitor(
        _translation, slide, (dynamic value) => Tween<double>(begin: value));

    _opacity = visitor(
        _opacity, opacity, (dynamic value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
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

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color selectedColor;
  final Color freeColor;
  final Function() ontap;
  _MenuListItem(
      {this.title,
      this.isSelected,
      this.selectedColor = Colors.red,
      this.freeColor = Colors.white,
      this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Color(0x44000000),
        onTap: isSelected ? null : ontap,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
            child: Text(
              title,
              style: TextStyle(
                  color: isSelected ? selectedColor : freeColor,
                  fontFamily: 'babas-neue',
                  fontSize: 20.0,
                  letterSpacing: 2.0),
            ),
          ),
        ));
  }
}

class Menu {
  final items;
  Menu({this.items});
}

class MenuItems {
  final String id;
  final String title;
  MenuItems({this.id, this.title});
}
