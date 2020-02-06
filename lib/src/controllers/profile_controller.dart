import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/order.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/order_repository.dart';
import 'package:green_pakistan/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProfileController extends ControllerMVC {
  User user = new User();
  List<Order> recentOrders = [];
  GlobalKey<ScaffoldState> scaffoldKey;

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForRecentOrders();
    listenForUser();
  }

  void listenForUser() {
    getCurrentUser().then((_user) {
      setState(() {
        user = _user;
      });
    });
  }

  void listenForRecentOrders({String message}) async {
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() {
        recentOrders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshProfile() async {
    recentOrders.clear();
    user = new User();
    listenForRecentOrders(message: 'Orders refreshed successfuly');
    listenForUser();
  }
}
