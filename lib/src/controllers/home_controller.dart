import 'package:green_pakistan/src/models/category.dart';
import 'package:green_pakistan/src/models/item.dart';
import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/models/review.dart';
import 'package:green_pakistan/src/repository/category_repository.dart';
import 'package:green_pakistan/src/repository/item_repository.dart';
import 'package:green_pakistan/src/repository/nursery_repository.dart';
import 'package:green_pakistan/src/repository/settings_repository.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Nursery> topNursery = <Nursery>[];
  List<Review> recentReviews = <Review>[];
  List<Item> trendingItems = <Item>[];

  HomeController() {
    listenForCategories();
    listenForTopNursery();
    listenForRecentReviews();
    listenForTrendingItems();
  }

  void listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForTopNursery() async {
    getCurrentLocation().then((LocationData _locationData) async {
      final Stream<Nursery> stream =
          await getNearNursery(_locationData, _locationData);
      stream.listen((Nursery _nursery) {
        setState(() => topNursery.add(_nursery));
      }, onError: (a) {}, onDone: () {});
    });
  }

  void listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForTrendingItems() async {
    final Stream<Item> stream = await getTrendingItems();
    stream.listen((Item _item) {
      setState(() => trendingItems.add(_item));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshHome() async {
    categories = <Category>[];
    topNursery = <Nursery>[];
    recentReviews = <Review>[];
    trendingItems = <Item>[];
    listenForCategories();
    listenForTopNursery();
    listenForRecentReviews();
    listenForTrendingItems();
  }
}
