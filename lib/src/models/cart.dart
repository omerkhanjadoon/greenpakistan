import 'package:green_pakistan/src/models/extra.dart';
import 'package:green_pakistan/src/models/item.dart';

class Cart {
  String id;
  Item item;
  double quantity;
  List<Extra> extras;
  String userId;

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    quantity =
        jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
    item =
        jsonMap['food'] != null ? Item.fromJSON(jsonMap['food']) : new Item();
    extras = jsonMap['extras'] != null
        ? List.from(jsonMap['extras'])
            .map((element) => Extra.fromJSON(element))
            .toList()
        : [];
    item.price = getItemPrice();
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["food_id"] = item.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }

  double getItemPrice() {
    double result = item.price;
    if (extras.isNotEmpty) {
      extras.forEach((Extra extra) {
        result += extra.price != null ? extra.price : 0;
      });
    }
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }
}
