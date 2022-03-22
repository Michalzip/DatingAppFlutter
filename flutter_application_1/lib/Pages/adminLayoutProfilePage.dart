import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'changeProfileDescribe.dart';
import 'usersViewPage.dart';


class UserPanel extends StatefulWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  String? ImagePhoto;
  final _auth = FirebaseAuth.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String? downloadURL;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var user = FirebaseAuth.instance.currentUser;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        print(_photo);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;

    final destination = 'Images/';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(user!.uid);
      await ref.putFile(_photo!);

      final download = await ref.getDownloadURL();
      setState(() {
        downloadURL = download;
      });
    } catch (e) {
      print(e);
    }

    return users.doc(user!.uid).update({'avatar': downloadURL}).then(
        (v) => print("OPERATION COMPLETE!"));
  }

  Widget _iconUser() {
    return Container(
      child: Ink(
        decoration: const ShapeDecoration(
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: ImageIcon(AssetImage("assets/images/change.png")),
          color: Color.fromARGB(255, 121, 27, 59),
          iconSize: 30,
          onPressed: () async {
            //Test();

            imgFromGallery();
          },
        ),
      ),
    );
  }

  Widget _changdeDescribe(context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyCustomForm()));
        },
        child: Container(
          alignment: Alignment.center,
          child: Text("new describe",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ));
  }

  Widget _buttonLogout(context) {
    return InkWell(
        onTap: () {
          _auth.signOut();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          print('wylogowano');
        },
        child: Center(
            //padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Logout",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))));
  }

  Widget _chat(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
        print('wylogowano');
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              ),
              Text("chat",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }


  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPress() {
      // openDialog();
      return Future.value(true);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // backgroundColor:Colors.pink[900],
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
            margin: new EdgeInsets.symmetric(vertical: .0),
            child: Column(
              children: [
                SizedBox(height: 20),
                // Center(child: Center(child:Text("Profile",style:TextStyle(fontSize:37))),),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  contentPadding: EdgeInsets.zero,
                                  children: <Widget>[
                                    Container(
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
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Settings App',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SimpleDialogOption(
                                        child: Center(
                                      child: _changdeDescribe(context),
                                    )),
                                    Divider(height: 1, color: Colors.black),
                                    SimpleDialogOption(
                                        child: Center(
                                      child: _buttonLogout(context),
                                    )),
                                    Divider(height: 1, color: Colors.black),
                                  ],
                                );
                              });
                        })),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: [
                          Container(
                            width: 150.0,
                            height: 150.0,
                            child: Stack(children: [
                              Container(
                                alignment: Alignment.center,
                                // color: Colors.redAccent,
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
                          SizedBox(height: 3),
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
                                snapshot.data['describe'] ,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ]);
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      return Container(child: _iconUser());
                    }),

                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    child: Stack(children: [
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.chat_outlined),
                          //color:Colors
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen()));
                          },
                        ),
                      ),
                    ]))
              ],
            ),
          ),
        ));
  }
}
