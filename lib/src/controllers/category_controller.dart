import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/category.dart';
import 'package:green_pakistan/src/models/item.dart';
import 'package:green_pakistan/src/repository/category_repository.dart';
import 'package:green_pakistan/src/repository/item_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CategoryController extends ControllerMVC {
  List<Item> items = <Item>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForItemsByCategory({String id, String message}) async {
    final Stream<Item> stream = await getItemsByCategory(id);
    stream.listen((Item _item) {
      setState(() {
        items.add(_item);
      });
    }, onError: (a) {
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

  void listenForCategory({String id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
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

  Future<void> refreshCategory() async {
    items.clear();
    category = new Category();
    listenForItemsByCategory(message: 'Category refreshed successfuly');
    listenForCategory(message: 'Category refreshed successfuly');
  }
}
