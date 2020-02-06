import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/favorite.dart';
import 'package:green_pakistan/src/models/item.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/user_repository.dart';
import 'package:http/http.dart' as http;

Future<Stream<Item>> getTrendingItems() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}foods?${_apiToken}with=restaurant&limit=6';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Item.fromJSON(data);
  });
}

Future<Stream<Item>> getItem(String itemId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}foods/$itemId?${_apiToken}with=nutrition;restaurant;category;extras;foodReviews;foodReviews.user';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Item.fromJSON(data));
}

Future<Stream<Item>> getItemsByCategory(categoryId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}foods?${_apiToken}with=restaurant&search=category_id:$categoryId&searchFields=category_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Item.fromJSON(data);
  });
}

Future<Stream<Favorite>> isFavoriteItem(String itemId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites/exist?${_apiToken}food_id=$itemId&user_id=${_user.id}';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getObjectData(data))
      .map((data) => Favorite.fromJSON(data));
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?${_apiToken}with=food;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Favorite.fromJSON(data));
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(favorite.toMap()),
  );

  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Stream<Item>> getItemsOfNursery(String restaurantId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}foods?${_apiToken}with=restaurant&search=restaurant.id:$restaurantId&searchFields=restaurant.id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Item.fromJSON(data);
  });
}

Future<Stream<Item>> getTrendingItemsOfNursery(String restaurantId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  // TODO Trending items only
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}foods?${_apiToken}with=restaurant&search=restaurant.id:$restaurantId&searchFields=restaurant.id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Item.fromJSON(data);
  });
}

Future<Stream<Item>> getFeaturedItemsOfNursery(String restaurantId) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  // TODO Featured items only
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}foods?${_apiToken}with=restaurant&search=restaurant_id:$restaurantId&searchFields=restaurant_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Item.fromJSON(data);
  });
}
