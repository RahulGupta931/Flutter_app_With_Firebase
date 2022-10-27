import 'package:flutter/material.dart';
import 'package:flutter_music_api/login.dart';
import 'package:flutter_music_api/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
     isLogin ? LoginScreen(onClickedSignUp: toggle) : SignUpPage(onClickedSignIn: toggle);
    void toggle()=> setState(() =>
      isLogin = !isLogin
    );
  
}