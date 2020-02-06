import 'package:green_pakistan/src/models/extra.dart';
import 'package:green_pakistan/src/models/item.dart';

class Favorite {
  String id;
  Item item;
  List<Extra> extras;
  String userId;

  Favorite();

  Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
    item = jsonMap['food'] != null ? Item.fromJSON(jsonMap['food']) : null;
    extras = jsonMap['extras'] != null
        ? List.from(jsonMap['extras'])
            .map((element) => Extra.fromJSON(element))
            .toList()
        : null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["food_id"] = item.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
