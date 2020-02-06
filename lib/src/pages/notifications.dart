import 'package:flutter/material.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/controllers/notification_controller.dart';
import 'package:green_pakistan/src/elements/EmptyNotificationsWidget.dart';
import 'package:green_pakistan/src/elements/NotificationItemWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends StateMVC<NotificationsWidget> {
  NotificationController _con;

  _NotificationsWidgetState() : super(NotificationController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _con.refreshNotifications,
        child: _con.notifications.isEmpty
            ? EmptyNotificationsWidget()
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.notifications,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).notifications,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.notifications.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return NotificationItemWidget(
                            notification: _con.notifications.elementAt(index));
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
