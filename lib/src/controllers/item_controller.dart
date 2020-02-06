import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/cart.dart';
import 'package:green_pakistan/src/models/extra.dart';
import 'package:green_pakistan/src/models/favorite.dart';
import 'package:green_pakistan/src/models/item.dart';
import 'package:green_pakistan/src/repository/cart_repository.dart';
import 'package:green_pakistan/src/repository/item_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ItemController extends ControllerMVC {
  Item item;
  double quantity = 1;
  double total = 0;
  Cart cart;
  Favorite favorite;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  ItemController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForItem({String itemId, String message}) async {
    final Stream<Item> stream = await getItem(itemId);
    stream.listen((Item _item) {
      setState(() => item = _item);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForFavorite({String itemId}) async {
    final Stream<Favorite> stream = await isFavoriteItem(itemId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  bool isSameNursery(Item item) {
    if (cart != null) {
      return cart.item?.nursery?.id == item.nursery.id;
    }
    return true;
  }

  void addToCart(Item item, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _cart = new Cart();
    _cart.item = item;
    _cart.extras = item.extras.where((element) => element.checked).toList();
    _cart.quantity = this.quantity;
    addCart(_cart, reset).then((value) {
      setState(() {
        this.loadCart = false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This item was added to cart'),
      ));
    });
  }

  void addToFavorite(Item item) async {
    var _favorite = new Favorite();
    _favorite.item = item;
    _favorite.extras = item.extras.where((Extra _extra) {
      return _extra.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This item was added to favorite'),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This item was removed from favorites'),
      ));
    });
  }

  Future<void> refreshItem() async {
    var _id = item.id;
    item = new Item();
    listenForFavorite(itemId: _id);
    listenForItem(itemId: _id, message: 'Item refreshed successfuly');
  }

  void calculateTotal() {
    total = item.price ?? 0;

    item.extras.forEach((extra) {
      total += extra.checked ? extra.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
