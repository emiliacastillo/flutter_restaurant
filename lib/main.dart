import 'package:flutter/material.dart';
import 'package:restaurant/menu_screen.dart';
import 'package:restaurant/other_screen.dart';
import 'package:restaurant/restaurant_screen.dart';
import 'package:restaurant/zoom_scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'apk restaurant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final menu = Menu(items: [
    MenuItems(id: 'id1', title: 'title1'),
    MenuItems(id: 'id2', title: 'title2'),
    MenuItems(id: 'id3', title: 'title3'),
    MenuItems(id: 'id4', title: 'title4'),
  ]);

  var selectedMenuItemId = 'restaurant';
  var activeScreen = restaurantScreen;

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      contentScreen: activeScreen,
      menuScreen: MenuScreen(
        menu: menu,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId, ) {
          selectedMenuItemId = itemId;
          if (itemId == 'id2') {
            setState(() {
              activeScreen = restaurantScreen;
            });
          } else if (itemId == 'id3') {
            setState(() {
              activeScreen = otherScreen;
            });
          }
        },
      ),
    );
  }
}
