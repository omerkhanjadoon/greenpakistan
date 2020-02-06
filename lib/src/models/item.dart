import 'package:green_pakistan/src/models/category.dart';
import 'package:green_pakistan/src/models/extra.dart';
import 'package:green_pakistan/src/models/media.dart';
import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/models/nutrition.dart';
import 'package:green_pakistan/src/models/review.dart';

class Item {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String weight;
  bool featured;
  Nursery nursery;
  Category category;
  List<Extra> extras;
  List<Review> itemReviews;
  List<Nutrition> nutritions;

  Item();

  Item.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    price = jsonMap['price'].toDouble();
    discountPrice = jsonMap['discount_price'] != null
        ? jsonMap['discount_price'].toDouble()
        : null;
    description = jsonMap['description'];
    ingredients = jsonMap['ingredients'];
    weight = jsonMap['weight'].toString();
    featured = jsonMap['featured'] ?? false;
    nursery = jsonMap['restaurant'] != null
        ? Nursery.fromJSON(jsonMap['restaurant'])
        : null;
    category = jsonMap['category'] != null
        ? Category.fromJSON(jsonMap['category'])
        : null;
    image =
        jsonMap['media'] != null ? Media.fromJSON(jsonMap['media'][0]) : null;
    extras = jsonMap['extras'] != null
        ? List.from(jsonMap['extras'])
            .map((element) => Extra.fromJSON(element))
            .toList()
        : null;
    nutritions = jsonMap['nutrition'] != null
        ? List.from(jsonMap['nutrition'])
            .map((element) => Nutrition.fromJSON(element))
            .toList()
        : null;
    itemReviews = jsonMap['food_reviews'] != null
        ? List.from(jsonMap['food_reviews'])
            .map((element) => Review.fromJSON(element))
            .toList()
        : null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    return map;
  }
}
