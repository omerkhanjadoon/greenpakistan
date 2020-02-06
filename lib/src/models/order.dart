import 'package:green_pakistan/src/models/item_order.dart';
import 'package:green_pakistan/src/models/order_status.dart';
import 'package:green_pakistan/src/models/payment.dart';
import 'package:green_pakistan/src/models/user.dart';

class Order {
  String id;
  List<ItemOrder> itemOrders;
  OrderStatus orderStatus;
  double tax;
  String hint;
  DateTime dateTime;
  User user;
  Payment payment;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
    hint = jsonMap['hint'].toString();
    orderStatus = jsonMap['order_status'] != null
        ? OrderStatus.fromJSON(jsonMap['order_status'])
        : new OrderStatus();
    dateTime = DateTime.parse(jsonMap['updated_at']);
    user =
        jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    itemOrders = jsonMap['food_orders'] != null
        ? List.from(jsonMap['food_orders'])
            .map((element) => ItemOrder.fromJSON(element))
            .toList()
        : [];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["foods"] = itemOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment.toMap();
    return map;
  }
}
