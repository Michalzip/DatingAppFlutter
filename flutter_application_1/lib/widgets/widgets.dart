import 'package:flutter/cupertino.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../Pages/loginPage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class commonWidgets {
  static double heightInput = 40;

  static Title() {
    return Column(
      children: <Widget>[
        Center(
            child: Text("Date App",
                style: TextStyle(
                    letterSpacing: 0.4,
                    shadows: <Shadow>[
                      Shadow(
                          offset: Offset(0, 0.90),
                          blurRadius: 8,
                          color: Colors.black),
                    ],
                    decoration: TextDecoration.none,
                    color: Colors.redAccent[700],
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic))),
      ],
    );
  }

  static FooterBar() {
    late var color = Colors.redAccent[700];

    return Footer(
      backgroundColor: Colors.black38,
      alignment: Alignment.center,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  Container(
                      height: 80.0,
                      width: 52.0,
                      child: Center(
                        child: IconButton(
                          icon: SvgPicture.asset(
                            "assets/facebook.svg",
                            color: color,
                          ),
                          color: color,
                          iconSize: 40,
                          onPressed: () {},
                        ),
                      )),
                  Container(
                      height: 52.0,
                      width: 52.0,
                      child: Center(
                        child: IconButton(
                          icon: SvgPicture.asset("assets/instagram.svg",
                              color: color),
                          color: color,
                          iconSize: 40,
                          onPressed: () {},
                        ),
                      )),
                  Container(
                      height: 52.0,
                      width: 52.0,
                      child: Center(
                        child: IconButton(
                          icon: SvgPicture.asset(
                            "assets/twitter.svg",
                            color: color,
                          ),
                          color: Colors.red,
                          disabledColor: Colors.red,
                          hoverColor: Colors.green,
                          iconSize: 40,
                          onPressed: () {},
                        ),
                      ))
                ]))
          ]),
      padding: EdgeInsets.all(10),
    );
  }
}
