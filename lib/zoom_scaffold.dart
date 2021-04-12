import 'package:flutter/material.dart';

class ZoomScaffold extends StatefulWidget {
  final Screen contentScreen;
  final Widget menuScreen;
  ZoomScaffold({this.contentScreen, this.menuScreen});

  @override
  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 0.1, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 0.1, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 0.1, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    menuController = MenuController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  createContentDisplay() {
    return zoomAndSlideContent(Container(
      decoration: BoxDecoration(image: widget.contentScreen.bacckground),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  menuController.toggle();
                }),
            title: Text(
              widget.contentScreen.title,
              style: TextStyle(fontFamily: 'bebas-neue', fontSize: 25.0),
            ),
          ),
          body: widget.contentScreen.contentBuilder(context)),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen) / 2;
        scalePercent = scaleDownCurve.transform(menuController.percentOpen) / 2;
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen) / 2;
        scalePercent = scaleUpCurve.transform(menuController.percentOpen) / 2;
        break;
      default:
    }
    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * menuController.percentOpen;
    return Transform(
        transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
          ..scale(contentScale, contentScale),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color(0x44000000),
                offset: Offset(0.0, 5.0),
                blurRadius: 20.0,
                spreadRadius: 10.0)
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius),
            child: content,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.menuScreen,
        createContentDisplay(),
      ],
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
        // ignore: deprecated_member_use
        context.ancestorStateOfType(new TypeMatcher<_ZoomScaffoldState>())
            as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }

  _onMenuControllerChange(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Screen {
  final String title;
  final DecorationImage bacckground;
  final WidgetBuilder contentBuilder;

  Screen({this.title, this.bacckground, this.contentBuilder});
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({this.vsync})
      : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = Duration(milliseconds: 100)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }
  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState { closed, opening, open, closing }
