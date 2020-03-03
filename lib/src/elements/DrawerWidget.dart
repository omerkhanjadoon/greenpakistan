import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:green_pakistan/src/controllers/profile_controller.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/repository/settings_repository.dart';
import 'package:green_pakistan/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  ProfileController _con;

  _DrawerWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _con.user.apiToken == null
          ? CircularLoadingWidget(height: 500)
          : ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 1);
                  },
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
                    ),
                    accountName: Text(
                      _con.user.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    accountEmail: Text(
                      _con.user.email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage:
                          CachedNetworkImageProvider(_con.user.image.thumb),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 2);
                  },
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Home",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 0);
                  },
                  leading: Icon(
                    Icons.notifications,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Notifications",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/Pages',
                      arguments: 3,
                    );
                  },
                  leading: Icon(
                    Icons.local_florist,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "My Orders",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Pages', arguments: 4);
                  },
                  leading: Icon(
                    Icons.favorite,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Favorite Items",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Blog');
                  },
                  leading: Icon(
                    Icons.assignment,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Learn To Plant",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Consultancy');
                  },
                  leading: Icon(
                    Icons.headset_mic,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Online Consultancy",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Application Preferences",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Help');
                  },
                  leading: Icon(
                    Icons.help,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Help & Support",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Settings');
                  },
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Settings",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Languages');
                  },
                  leading: Icon(
                    Icons.translate,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Languages",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (Theme.of(context).brightness == Brightness.dark) {
                      setBrightness(Brightness.light);
                      DynamicTheme.of(context).setBrightness(Brightness.light);
                    } else {
                      setBrightness(Brightness.dark);
                      DynamicTheme.of(context).setBrightness(Brightness.dark);
                    }
                  },
                  leading: Icon(
                    Icons.brightness_6,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    Theme.of(context).brightness == Brightness.dark
                        ? "Light Mode"
                        : "Dark Mode",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  onTap: () {
                    logout().then((value) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/Login', (Route<dynamic> route) => false);
                    });
                  },
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    "Log out",
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Version 0.0.1",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
    );
  }
}
