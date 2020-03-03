import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/route_argument.dart';
import 'package:green_pakistan/src/pages/Consultancy.dart';
import 'package:green_pakistan/src/pages/blog.dart';
import 'package:green_pakistan/src/pages/cart.dart';
import 'package:green_pakistan/src/pages/category.dart';
import 'package:green_pakistan/src/pages/checkout.dart';
import 'package:green_pakistan/src/pages/debug.dart';
import 'package:green_pakistan/src/pages/details.dart';
import 'package:green_pakistan/src/pages/help.dart';
import 'package:green_pakistan/src/pages/item.dart';
import 'package:green_pakistan/src/pages/languages.dart';
import 'package:green_pakistan/src/pages/login.dart';
import 'package:green_pakistan/src/pages/map.dart';
import 'package:green_pakistan/src/pages/menu_list.dart';
import 'package:green_pakistan/src/pages/order_success.dart';
import 'package:green_pakistan/src/pages/pages.dart';
import 'package:green_pakistan/src/pages/payment_methods.dart';
import 'package:green_pakistan/src/pages/paypal_payment.dart';
import 'package:green_pakistan/src/pages/settings.dart';
import 'package:green_pakistan/src/pages/signup.dart';
import 'package:green_pakistan/src/pages/splash_screen.dart';
import 'package:green_pakistan/src/pages/tracking.dart';
import 'package:green_pakistan/src/pages/walkthrough.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(
            builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Walkthrough':
        return MaterialPageRoute(builder: (_) => Walkthrough());
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Pages':
        return MaterialPageRoute(
            builder: (_) => PagesTestWidget(currentTab: args));
      case '/Details':
        return MaterialPageRoute(
            builder: (_) =>
                DetailsWidget(routeArgument: args as RouteArgument));
      case '/Blog':
        return MaterialPageRoute(builder: (_) => BlogWidget());
      case '/Consultancy':
        return MaterialPageRoute(builder: (_) => ConsultancyWidget());
      case '/Map':
        return MaterialPageRoute(
            builder: (_) => MapWidget(routeArgument: args as RouteArgument));
      case '/Menu':
        return MaterialPageRoute(
            builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      case '/Item':
        return MaterialPageRoute(
            builder: (_) => ItemWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(
            builder: (_) =>
                CategoryWidget(routeArgument: args as RouteArgument));
      case '/Cart':
        return MaterialPageRoute(
            builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(
            builder: (_) =>
                TrackingWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Cash on Delivery')));
      case '/PayOnPickup':
        return MaterialPageRoute(
            builder: (_) => OrderSuccessWidget(
                routeArgument: RouteArgument(param: 'Pay on Pickup')));
      case '/PayPal':
        return MaterialPageRoute(
            builder: (_) =>
                PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(
            builder: (_) =>
                OrderSuccessWidget(routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => PagesTestWidget(currentTab: 2));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
