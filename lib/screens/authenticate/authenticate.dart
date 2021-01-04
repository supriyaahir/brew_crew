import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showShowIn = true;
  void toggleView(){
    setState(() => showShowIn = !showShowIn );
  }
  @override
  Widget build(BuildContext context) {
    if(showShowIn){
      return SignInPage(toggleView: toggleView);
    }
    else{
      return Register(toggleView: toggleView);
    }
  }
}