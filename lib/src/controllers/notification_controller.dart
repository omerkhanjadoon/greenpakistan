import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/notification.dart' as model;
import 'package:green_pakistan/src/repository/notification_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NotificationController extends ControllerMVC {
  List<model.Notification> notifications = <model.Notification>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  NotificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications();
  }

  void listenForNotifications({String message}) async {
    final Stream<model.Notification> stream = await getNotifications();
    stream.listen((model.Notification _notification) {
      setState(() {
        notifications.add(_notification);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(message: 'Notifications refreshed successfuly');
  }
}
