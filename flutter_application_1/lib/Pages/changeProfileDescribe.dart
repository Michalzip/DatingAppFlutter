import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import '../widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminLayoutProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  var userId = FirebaseAuth.instance.currentUser;
  Future<void> addDescribe(TextEditingController describe) {
    return user.doc(userId!.uid).update({'describe': describe.text}).then(
        (v) => print("OPERATION COMPLETE!"));
  }

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Second text field: ${myController.text}');
  }

  @override
  Widget build(BuildContext context) {
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
            alignment: Alignment.topRight,
            child: Column(
              children: [
                SizedBox(height: 30),
                Text("Change Your Describe Here",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 30),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                          child: TextField(
                        controller: myController,
                        onChanged: (text) {
                          print('First text field: $text');
                        },
                      )),
                    ),

                    Container( 
                      width:double.infinity,
               
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding:EdgeInsets.only(left:0),
                              height: 80.0,
                              width: 50.0,
                              child: Center(
                                child: IconButton(
                                  icon: Image.asset('assets/save.png'),
                                  alignment: Alignment.topRight,
                                  color: Colors.blue,
                                  iconSize: 40,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserPanel()));
                                    addDescribe(myController);
                                  },
                                ),
                              )),
                        ]))
                  ],
                 
                
                    )
                    
                    )
              ],
            )));
  }
}
