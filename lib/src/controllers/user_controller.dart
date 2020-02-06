import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/user_repository.dart'
    as repository;
import 'package:mvc_pattern/mvc_pattern.dart';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    });
  }

  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.login(user).then((value) {
        //print(value.apiToken);
        if (value != null && value.apiToken != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Welcome ${value.name}!'),
          ));
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Wrong email or password'),
          ));
        }
      });
    }
  }

  void register() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Welcome ${value.name}!'),
          ));
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Wrong email or password'),
          ));
        }
      });
    }
  }
}
