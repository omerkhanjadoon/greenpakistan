import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/order.dart';
import 'package:green_pakistan/src/repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOrders();
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: 'Order refreshed successfuly');
  }
}
