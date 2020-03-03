import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/blog.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/user_repository.dart';
import 'package:http/http.dart' as http;

List<Blog> getBlogs() {
  return [
    Blog("1", "Get Started with Plants", "description",
        "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
    Blog("2", "Best Plantation Practices", "description",
        "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
    Blog("3", "5 Steps to Become an Environment Saviour", "description",
        "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
    Blog("4", "Grow Vegetables in your home", "description",
        "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
    Blog("5", "5 Steps to Become an Environment Saviour", "description",
        "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
    Blog("6", "Grow Vegetables in your home", "description",
        "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
  ];
}

//Future<Stream<List<Blog>>> getBlogs() async {
//  User _user = await getCurrentUser();
//  final String _apiToken = 'api_token=${_user.apiToken}&';
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}blogs?$_apiToken';
//
////  final client = new http.Client();
//  // final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
//
////  return streamedRest.stream
////      .transform(utf8.decoder)
////      .transform(json.decoder)
////      .map((data) => Helper.getData(data))
////      .expand((data) => (data as List))
////      .map((data) => Blog.fromJSON(data));
////  Stream<List<Blog>> blogs = {
////    [
////      Blog("1", "hello world", "description",
////          "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg"),
////      Blog("2", "hello world 33", "description",
////          "https://img.freepik.com/free-photo/hands-planting-tree_56296-23.jpg")
////    ]
////  };
//
//  return Stream.fromIterable(blogs);
//}

Future<Stream<Blog>> getBlog(String id) async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}blogs/$id?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Blog.fromJSON(data));
}
