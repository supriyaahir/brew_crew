import 'package:brew_crew/services/authentication_service.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/models/user.dart';
import 'package:provider/provider.dart';
//import 'dart:html';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    print("user from stream context");
    print(user);

    final uid = user.uid;
    print(uid);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          UserData userData = snapshot.data;

              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text('update your brew settings',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: userData.name,
                      decoration: textInputDecoration.copyWith(hintText: 'Name'),
                      validator: (val) => val.isEmpty ? 'Please Enter a Name' : null,
                      onChanged: (val) {
                        setState(() => _currentName = val);
                      },
                    ),
                    SizedBox(height: 20.0),

                    //dropdown
                    DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentSugars ?? userData.sugars,
                      items: sugars.map((sugar) {
                        return DropdownMenuItem(
                          value: sugar,
                          child: Text('$sugar sugars'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _currentSugars = val);
                      },
                    ),

                    //slider
                    Slider(
                        value: (_currentStrength ?? userData.strength).toDouble(),
                        min:100.0,
                        max: 900.0,
                        divisions: 8,
                        activeColor: Colors.brown[_currentStrength ?? userData.strength],
                        inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                        onChanged: (val){
                          setState(() {
                            _currentStrength= val.round();
                          });
                        }
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async{
                          if(_formKey.currentState.validate()){
                            await DatabaseService(uid: user.uid).updateUserData(
                                _currentSugars ?? userData.sugars,
                                _currentName ?? userData.name,
                                _currentStrength ?? userData.strength);
                            Navigator.pop(context);
                          }
                        }
                    )
                  ],
                ),
              );
        }
        else{
              return Loading();
        }

      }
    );
  }
}
