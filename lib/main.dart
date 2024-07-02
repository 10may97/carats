import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:restaurantapp/firebase_options.dart';
import 'package:restaurantapp/pages/home_page.dart';
import 'package:restaurantapp/pages/login_page.dart';
import 'package:restaurantapp/pages/register_page.dart';

void main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Restaurant App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>MainPage(),
        '/login':(context)=>const LoginPage(),
        '/register':(context)=>const RegisterPage(),
        '/home':(context)=>HomePage(),
      },
    );
  }
}
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }
}