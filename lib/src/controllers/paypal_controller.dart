import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:green_pakistan/src/repository/user_repository.dart' as userRepo;
import 'package:mvc_pattern/mvc_pattern.dart';

class PayPalController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  PayPalController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String _apiToken = 'api_token=${userRepo.currentUser.apiToken}';
    final String _userId = 'user_id=${userRepo.currentUser.id}';
    url =
        '${GlobalConfiguration().getString('base_url')}payments/paypal/express-checkout?$_apiToken&$_userId';
    setState(() {});
    super.initState();
  }
}
