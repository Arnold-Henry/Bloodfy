import 'dart:async';

import 'package:bloodfy/Screens/Authentications/login_screen.dart';
import 'package:bloodfy/Screens/Centers/center_dashboard.dart';
import 'package:bloodfy/Screens/home_dashboard.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_manager/data_manager.dart';
import 'firebase_authentication/firebase_authentication.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return DataManagerProvider();
      },
      child: MaterialApp(
        title: "Bloodfy",
        supportedLocales: const <Locale>[
          Locale('en', ''),
          Locale('ar', ''),
        ],

        // --------------------- Add Theme Data ---------------------- //
        // Add theme data here
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.blueGrey[900],
          accentColor: Colors.cyan[600],

          // Define the default font family.

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
            headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal),
            bodyText2: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  // -------------- for start page
  Widget defaultPage = Container();
  late SharedPreferences login;
  bool loginSuccess = false;
  late String role;

  Future<void> checkIfAlreadyLogin() async {
    login = await SharedPreferences.getInstance();
    bool newUser = (login.getBool('login') ?? true);
    if (newUser == false) {
      setState(() {
        loginSuccess = true;
        role = login.getString('role').toString();
      });
      signIn(login.getString('email').toString(),
          login.getString('password').toString(), role, context);
    }
  }

//------------ check if the user is using app for first time or not
//   void checkSharedPrefs() async {
//     var sharedPrefs = await SharedPreferences.getInstance();
//     if (sharedPrefs.containsKey("firstTime")) {
//       defaultPage = Container();
//     }
//   }

//-------- initialize with a Timer that will push to new screen after few seconds
  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => loginSuccess
              ? role == 'Donor'
                  ? const HomePageScreen()
                  : CenterDashboard()
              : const LoginScreen(),
        ),
      );
    });
  }

// ---------------- Splash Screen Widget
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.blueGrey[900],
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/home.png",
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 16), // Add spacing between the image and CircularProgressIndicator
          CircularProgressIndicator(
            strokeWidth: 4,
            backgroundColor: Colors.amberAccent[400],
          ),
        ],
      ),
    ),
  );
}

}