import 'package:flutter/cupertino.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:flutter/material.dart';
import '../Pages/loginPage.dart';
import '../main.dart';
import '../widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminLayoutProfilePage.dart';
import 'package:firebase_core/firebase_core.dart';
import "dart:async";
import 'package:firebase_storage/firebase_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPaheState createState() => _LoginPaheState();
}

class _LoginPaheState extends State<LoginPage> {
  @override
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();

  String? email;
  String? password;
  bool _validateForEmail = false;
  bool _validateForPassword = false;
  bool _showInfo = false;

  Future clearinput(time) async {
    await Future.delayed(Duration(seconds: time), () {
      _text1.clear();
      _text2.clear();
      _text3.clear();
    });
  }

  void Login() async {
  

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print("to jest IDD:::" + userCredential.user!.uid);
      if (userCredential != null) {
        Navigator.pushNamed(context, '/userProfile');

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {

      }
    } catch (e) {
      print(e);
    }
  }

  Widget _BackButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        _showInfo = false;
      },
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

  Widget EmailInput() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 270,
        child: Column(
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
                    child: TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  controller: _text1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.2,
                    ),
                    errorText:
                        _text1.text == null ? "Please enter your email" : null,
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
                    child: TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  controller: _text2,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.2,
                      )),
                ))),
          ],
        ));
  }

  Widget _RegisterButton() {
    return InkWell(
      onTap: () async {
        Login();
        clearinput(1);
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
          'Login',
          style: TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),
    );
  }

  Widget fieldsForSignUp() {
    return Column(
      children: <Widget>[
        SizedBox(height: 30),
        EmailInput(),
        passwordInput(),
      ],
    );
  }

  Widget Mainlayout() {
    return FooterView(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(top: 19.0),
          child: Container(
              child: Column(
            children: [
              _BackButton(),
              commonWidgets.Title(),
              fieldsForSignUp(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              _RegisterButton(),
            ],
          )),
        ),
      ],
      footer: commonWidgets.FooterBar(),
      flex: 5, //default flex is 2
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: 1500, color: Colors.pink[900], child: Mainlayout()));
  }
}
