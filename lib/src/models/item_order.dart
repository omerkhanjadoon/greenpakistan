import 'package:green_pakistan/src/models/extra.dart';
import 'package:green_pakistan/src/models/item.dart';

class ItemOrder {
  String id;
  double price;
  double quantity;
  List<Extra> extras;
  Item item;
  DateTime dateTime;
  ItemOrder();

  ItemOrder.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
    quantity =
        jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
    item = jsonMap['food'] != null ? Item.fromJSON(jsonMap['food']) : [];
    dateTime = DateTime.parse(jsonMap['updated_at']);
    extras = jsonMap['extras'] != null
        ? List.from(jsonMap['extras'])
            .map((element) => Extra.fromJSON(element))
            .toList()
        : null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = price;
    map["quantity"] = quantity;
    map["food_id"] = item.id;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
