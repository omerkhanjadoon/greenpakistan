import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/credit_card.dart';
import 'package:green_pakistan/src/models/order.dart';
import 'package:green_pakistan/src/models/order_status.dart';
import 'package:green_pakistan/src/models/payment.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/user_repository.dart';
import 'package:http/http.dart' as http;

Future<Stream<Order>> getOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;orderStatus&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> addOrder(Order order, Payment payment) async {
  User _user = await getCurrentUser();
  CreditCard _creditCard = await getCreditCard();
  order.user = _user;
  order.payment = payment;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );

  return Order.fromJSON(json.decode(response.body)['data']);
}
