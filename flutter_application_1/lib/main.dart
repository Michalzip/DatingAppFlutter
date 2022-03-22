import 'package:flutter/material.dart';
import 'Pages/signupPage.dart';
import 'Pages/loginPage.dart';
import 'package:footer/footer_view.dart';
import 'widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/usersViewPage.dart';
import 'Pages/adminLayoutProfilePage.dart';
import 'Pages/changeProfileDescribe.dart';
// import 'generated_plugin_registrant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        '/chatScreen': (context) => const ChatScreen(),
        '/userProfile': (context) => const UserPanel(),
        '/changeText': (context) => const MyCustomForm(),
        // '/messageRoom':(context)=> chatRoom(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget MainLayout() {
    late var color = Colors.redAccent[700];
    return FooterView(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(top: 15.0),
          child: Container(
              child: Column(
            children: [
              commonWidgets.Title(),
              Center(
                child: Image.asset('assets/images/menuIcon3.png',
                    height: 200, width: 350, fit: BoxFit.fill),
              ),
              SizedBox(
                height: 50,
              ),
              _signUpButton(),
              SizedBox(
                height: 15,
              ),
              _submitButton(),
            ],
          )),
        ),
      ],
      footer: commonWidgets.FooterBar(),
      flex: 6, //default flex is 2
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
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

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        width: 140,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.amber
            // border: Border.all(color: Colors.white, width: 2),
            ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.pink[900],
        child: Stack(
            children: <Widget>[Positioned.fill(top: 50, child: MainLayout())]),
      ),
    );
  }
}
