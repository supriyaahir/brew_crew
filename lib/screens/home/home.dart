import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/screens/home/brew_list.dart';

class Home extends StatelessWidget {

 // final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context)
      {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    return  MultiProvider(
        providers: [
        Provider<DatabaseService>(
        create: (_) => DatabaseService(),
    ),
    StreamProvider(
    create: (context) => context.read<DatabaseService>().brews,
    )
    ],
    child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Brew Crew'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await context.read<AuthenticationService>().signOut();
            },
          ),
          FlatButton.icon(onPressed: () => _showSettingsPanel(),
              icon: Icon(Icons.settings),
              label: Text('settings'))
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BrewList()
      ),
    ),
    );
  }
}