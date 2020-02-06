import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/faq_category.dart';
import 'package:green_pakistan/src/models/user.dart';
import 'package:green_pakistan/src/repository/user_repository.dart';
import 'package:http/http.dart' as http;

Future<Stream<FaqCategory>> getFaqCategories() async {
  User _user = await getCurrentUser();
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}faq_categories?${_apiToken}with=faqs';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return FaqCategory.fromJSON(data);
  });
}
