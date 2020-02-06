import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/cart.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/user_repository.dart' as userRepo;
import 'package:http/http.dart' as http;

Future<Stream<Cart>> getCart() async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}with=food;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Cart.fromJSON(data);
  });
}

Future<Stream<int>> getCartCount() async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
        (data) => Helper.getIntData(data),
      );
}

Future<Cart> addCart(Cart cart, bool reset) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String _resetParam = 'reset=${reset ? 1 : 0}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts?$_apiToken&$_resetParam';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );

  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<Cart> updateCart(Cart cart) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<Cart> removeCart(Cart cart) async {
  User _user = userRepo.currentUser;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}
