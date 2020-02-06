import 'dart:async';

import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/cart.dart';
import 'package:green_pakistan/src/models/credit_card.dart';
import 'package:green_pakistan/src/models/item_order.dart';
import 'package:green_pakistan/src/models/order.dart';
import 'package:green_pakistan/src/models/order_status.dart';
import 'package:green_pakistan/src/models/payment.dart';
import 'package:green_pakistan/src/repository/cart_repository.dart';
import 'package:green_pakistan/src/repository/order_repository.dart'
    as orderRepo;
import 'package:green_pakistan/src/repository/settings_repository.dart';
import 'package:green_pakistan/src/repository/settings_repository.dart'
    as settingRepo;
import 'package:green_pakistan/src/repository/user_repository.dart' as userRepo;
import 'package:mvc_pattern/mvc_pattern.dart';

class CheckoutController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  Payment payment;
  double taxAmount = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  void listenForCarts({String message, bool withAddOrder = false}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      calculateSubtotal();
      if (withAddOrder != null && withAddOrder == true) {
        addOrder(carts);
      }
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.itemOrders = new List<ItemOrder>();
    _order.tax = setting.defaultTax;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    carts.forEach((_cart) {
      ItemOrder _itemOrder = new ItemOrder();
      _itemOrder.quantity = _cart.quantity;
      _itemOrder.price = _cart.item.price;
      _itemOrder.item = _cart.item;
      _itemOrder.extras = _cart.extras;
      _order.itemOrders.add(_itemOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.item.price;
    });
    taxAmount = subTotal * settingRepo.setting.defaultTax / 100;
    total = subTotal + taxAmount;
    setState(() {});
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Payment card updated successfully'),
      ));
    });
  }
}
