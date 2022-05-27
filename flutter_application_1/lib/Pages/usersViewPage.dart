import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'adminLayoutProfilePage.dart';
import 'LayoutProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatSState createState() => _ChatSState();
}

class _ChatSState extends State<ChatScreen> {
  var loggedUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Widget _BackButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(
            context, MaterialPageRoute(builder: (context) => UserPanel()));
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 50, bottom: 10),
                child: Row(children: <Widget>[
                  Icon(Icons.keyboard_arrow_left, color: Colors.black),
                  Text("Back",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                ]),
              ),
            ],
          )),
    );
  }

  Widget _showMoreButton(context, AsyncSnapshot<dynamic> snapshot, index) {
    var user = snapshot.data.docs[index];
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    String documentId = user.id;
    String Icon = user['avatar'];

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfle(documentId, Icon)));
        //////////
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                //child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              ),
              Text("showMore",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 169, 96, 96),
                    shadows: <Shadow>[
                      Shadow(
                          offset: Offset(0, 0.90),
                          blurRadius: 8,
                          color: Colors.black26),
                    ],
                  ))
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(loggedUser!.uid);
    return Scaffold(
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
            child: Column(children: [
              _BackButton(),
              Flexible(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('uid', isNotEqualTo: loggedUser!.uid)
                        .snapshots(), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot user = snapshot.data.docs[index];

                              return Container(

                                  //  height:215,
                                  child: Column(
                                children: [
                                  Center(
                                      child: Column(children: [
                                    Container(
                                        width: 120,

                                        //height: 120,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            imageUrl: user['avatar'],
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        )),
                                    SizedBox(height: 10),
                                    Container(
                                      child: Text(
                                        user['name'] + " " + user['secondName'],
                                        style: TextStyle(
                                          fontSize: 21,
                                          letterSpacing: 0.4,
                                          shadows: <Shadow>[
                                            Shadow(
                                                offset: Offset(0, 0.90),
                                                blurRadius: 8,
                                                color: Colors.black),
                                          ],
                                          decoration: TextDecoration.none,
                                          color:
                                              Color.fromARGB(255, 169, 96, 96),
                                          fontWeight: FontWeight.bold,
                                          //Color.fromARGB(255, 169, 96, 96)
                                          //Color.fromARGB(255, 151, 124, 138)
                                        ),
                                      ),
                                    ),
                                    _showMoreButton(context, snapshot, index)
                                  ])),
                                ],
                              ));
                              ;
                            });
                      } else if (snapshot.hasError) {
                        return Text('ERROR');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      return Text('');
                    }),
              )
            ])));
  }
}
