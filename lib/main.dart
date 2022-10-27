import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_api/auth_page.dart';
import 'utils.dart';
import 'home_page.dart';
// ignore: depend_on_referenced_packages
import "package:firebase_core/firebase_core.dart";


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return AuthPage();
          }
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
