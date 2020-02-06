import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/gallery.dart';
import 'package:green_pakistan/src/models/item.dart';
import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/models/review.dart';
import 'package:green_pakistan/src/repository/gallery_repository.dart';
import 'package:green_pakistan/src/repository/item_repository.dart';
import 'package:green_pakistan/src/repository/nursery_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NurseryController extends ControllerMVC {
  Nursery nursery;
  List<Gallery> galleries = <Gallery>[];
  List<Item> items = <Item>[];
  List<Item> trendingItems = <Item>[];
  List<Item> featuredItems = <Item>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  NurseryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForNursery({String id, String message}) async {
    final Stream<Nursery> stream = await getNursery(id);
    stream.listen((Nursery _nursery) {
      setState(() => nursery = _nursery);
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

  void listenForGalleries(String idNursery) async {
    final Stream<Gallery> stream = await getGalleries(idNursery);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForNurseryReviews({String id, String message}) async {
    final Stream<Review> stream = await getNurseryReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForItems(String idNursery) async {
    final Stream<Item> stream = await getItemsOfNursery(idNursery);
    stream.listen((Item _item) {
      setState(() => items.add(_item));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingItems(String idNursery) async {
    final Stream<Item> stream = await getTrendingItemsOfNursery(idNursery);
    stream.listen((Item _item) {
      setState(() => trendingItems.add(_item));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedItems(String idNursery) async {
    final Stream<Item> stream = await getFeaturedItemsOfNursery(idNursery);
    stream.listen((Item _item) {
      setState(() => featuredItems.add(_item));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshNursery() async {
    var _id = nursery.id;
    nursery = new Nursery();
    galleries.clear();
    reviews.clear();
    featuredItems.clear();
    listenForNursery(id: _id, message: 'Nursery refreshed successfuly');
    listenForNurseryReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedItems(_id);
  }
}
