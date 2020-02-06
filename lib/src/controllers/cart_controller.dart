import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/cart.dart';
import 'package:green_pakistan/src/repository/cart_repository.dart';
import 'package:green_pakistan/src/repository/settings_repository.dart'
    as settingRepo;
import 'package:mvc_pattern/mvc_pattern.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
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
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    });
  }

  Future<void> refreshCarts() async {
    listenForCarts(message: 'Carts refreshed successfuly');
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((onValue) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("The ${_cart.item.name} was removed from your cart"),
      ));
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

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }
}
