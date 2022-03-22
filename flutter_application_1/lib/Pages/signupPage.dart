import 'package:flutter/cupertino.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'loginPage.dart';
import '../widgets/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  @override
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();
  final _text4 = TextEditingController();
  String? name;
  String? secondName;
  String? email;
  String? password;
  String image =
      'https://www.freeiconspng.com/thumbs/question-icon/question-icon-29.png';
  String describe = "";
  var messages = [];
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var user = FirebaseAuth.instance.currentUser;

  void Register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      //after rejestration go to CHAT APP
      if (userCredential != null) {
        Navigator.pushNamed(context, '/chatScreen');
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "uid": userCredential.user!.uid,
          'email': email,
          'password': password,
          'avatar': image,
          'name': name,
          'secondName': secondName,
          'describe': describe,
          'messages': messages
        });
        print("USER REHISTER!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _BackButton() {
    return InkWell(
      onTap: () => Navigator.pop(
          context, MaterialPageRoute(builder: (context) => MyApp())),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              ),
              Text("Back",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }

  Widget _RegisterButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));

        Register();
      },
      child: Container(
        width: 140,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            //  border: Border.all(color: Colors.white, width: 2),
            boxShadow: <BoxShadow>[],
            color: Colors.amber),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),
    );
  }

  Widget fieldsForSignUp() {
    return Column(
      children: <Widget>[
        EmailInput(),
        nameInput(),
        secondNameInput(),
        passwordInput(),
      ],
    );
  }

  Widget EmailInput() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 290,
              child: Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
                height: commonWidgets.heightInput,
                child: Center(
                    child: TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  controller: _text1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ))),
          ],
        ));
  }

  Widget secondNameInput() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 290,
              child: Text(
                "Second Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
                height: commonWidgets.heightInput,
                child: Center(
                    child: TextField(
                  onChanged: (value) {
                    secondName = value;
                  },
                  controller: _text4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ))),
          ],
        ));
  }

  Widget passwordInput() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 290,
              child: Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
                height: commonWidgets.heightInput,
                child: Center(
                    child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  controller: _text2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ))),
          ],
        ));
  }

  Widget nameInput() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 290,
              child: Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Container(
                height: commonWidgets.heightInput,
                child: Center(
                    child: TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  controller: _text3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ))),
          ],
        ));
  }

  Widget Mainlayout() {
    return FooterView(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(top: 15.0),
          child: Container(
              child: Column(
            children: [
              _BackButton(),
              commonWidgets.Title(),
              fieldsForSignUp(),
              SizedBox(
                height: 50,
              ),
              _RegisterButton()
            ],
          )),
        ),
      ],
      footer: commonWidgets.FooterBar(),
      flex: 6, //default flex is 2
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(color: Colors.pink[900], child: Mainlayout()));
  }
}
