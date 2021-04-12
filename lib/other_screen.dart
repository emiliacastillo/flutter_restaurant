import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/zoom_scaffold.dart';

final otherScreen = new Screen(
    title: 'Other Screen',
    bacckground: new DecorationImage(
        image: AssetImage('assets/weaver.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Color(0xCC000000), BlendMode.multiply)),
    contentBuilder: (BuildContext context) {
      return Center(
        child: Container(
          height: 300.0,
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/weaver.jpg'),
                  Expanded(
                    child: Center(
                      child: Text('Esta es otra de mis paginas')
                    ),
                  )
                ],
              ),
            ),
          )
          
        )
      );
    }
);