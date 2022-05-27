import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'chatPage.dart';

class UserProfle extends StatelessWidget {
  final String documentId;
  final String icon;

  UserProfle(this.documentId, this.icon);

  var users = FirebaseFirestore.instance.collection('users');

  Widget _iconUser() {
    return Container(
      child: Ink(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink.shade900,
              Colors.red.shade700,

              //    Colors.pink,
              // Colors.red,
            ],
          )),
          margin: new EdgeInsets.symmetric(vertical: 0.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              StreamBuilder(
                  stream: users.doc(documentId).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: [
                        Container(
                          width: 150.0,
                          height: 150.0,
                          child: Stack(children: [
                            Container(
                              alignment: Alignment.center,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data['avatar'],
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: _iconUser()),
                          ]),
                        ),
                        Text(
                            snapshot.data['name'] +
                                " " +
                                snapshot.data['secondName'],
                            style: TextStyle(
                              fontSize: 32,
                              letterSpacing: 0.4,
                              shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(0, 0.90),
                                    blurRadius: 8,
                                    color: Colors.black),
                              ],
                              decoration: TextDecoration.none,
                              color: Color.fromARGB(255, 169, 96, 96),
                              fontWeight: FontWeight.bold,
                            )),
                        Container(
                          width: 212,
                          child: Center(
                              child: Text(
                                  snapshot.data['describe'],
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(height: 5),
                        Center(
                            child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 128, 91, 91),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: TextButton(
                            child: Text("Send Message"),
                            style: TextButton.styleFrom(
                              primary: Colors.white, //Text Color
                              // backgroundColor: Color.fromARGB(255, 128, 91, 91), //Button Background Color
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          chatRoom(documentId, icon)));
                            },
                          ),
                        )),
                      ]);
                    } else if (snapshot.hasError) {
                      return Text('ERROR');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    return Container(child: _iconUser());
                  }),
            ],
          ),
        )));
  }
}
