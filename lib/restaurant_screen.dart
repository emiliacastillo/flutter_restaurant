
import 'package:flutter/material.dart';
import 'package:restaurant/zoom_scaffold.dart';

final Screen restaurantScreen = new Screen(
    title: 'Mi Restaurant',
    bacckground: DecorationImage(
      image: AssetImage('assets/backgrond_global.jpg'),
      fit: BoxFit.cover
    ),
    contentBuilder: (BuildContext context){
       return ListView(
          children: <Widget>[
            _RestaurantCard(
              headImageAssetPath: 'assets/comida1.jpg',
              icon: Icons.fastfood,
              iconBackgroundColor: Colors.orange,
              title: 'comida riquisima',
              subtitle: 'Colon 318 / caridad y central',
              heartCount: 100,
              iconemotion: Icons.favorite_border,
            ),
            _RestaurantCard(
              headImageAssetPath: 'assets/comida2.jpg',
              icon: Icons.local_dining,
              iconBackgroundColor: Colors.red,
              title: 'la buena comida',
              subtitle: 'calle anagudo #155',
              heartCount: 92,
              iconemotion: Icons.favorite_border,
            ),
            _RestaurantCard(
              headImageAssetPath: 'assets/comida3.jpg',
              icon: Icons.local_drink,
              iconBackgroundColor: Colors.cyan,
              title: 'la peor comida',
              subtitle: 'parque y teatro caridad ',
              heartCount: 55,
              iconemotion: Icons.favorite_border,
            ),
          ],
        );
     }  
);

class _RestaurantCard extends StatelessWidget {
  final String headImageAssetPath;
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final int heartCount;
  final IconData iconemotion;

  _RestaurantCard(
      {this.headImageAssetPath,
      this.icon,
      this.iconBackgroundColor,
      this.title,
      this.subtitle,
      this.heartCount,
      this.iconemotion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Card(
        elevation: 10.0,
        child: Column(
          children: <Widget>[
            Image.asset(
              headImageAssetPath,
              width: double.infinity,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'mermaid',
                          fontSize: 25.0,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                            fontFamily: 'bebas-neue',
                            fontSize: 16.0,
                            letterSpacing: 1.0,
                            color: Color(0xFFAAAAAA)),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 2.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.white,
                      Color(0xFFAAAAAA),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        iconemotion,
                        color: Colors.red,
                      ),
                      Text(
                        '$heartCount',
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
