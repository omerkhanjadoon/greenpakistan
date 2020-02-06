import 'package:flutter/material.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/controllers/nursery_controller.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/elements/DrawerWidget.dart';
import 'package:green_pakistan/src/elements/ItemItemWidget.dart';
import 'package:green_pakistan/src/elements/ItemsCarouselWidget.dart';
import 'package:green_pakistan/src/elements/SearchBarWidget.dart';
import 'package:green_pakistan/src/elements/ShoppingCartButtonWidget.dart';
import 'package:green_pakistan/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  NurseryController _con;

  _MenuWidgetState() : super(NurseryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForItems(widget.routeArgument.id);
    _con.listenForTrendingItems(widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.items.isNotEmpty ? _con.items[0].nursery.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.trending_up,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).trending_this_week,
                style: Theme.of(context).textTheme.display1,
              ),
              subtitle: Text(
                S.of(context).double_click_on_the_item_to_add_it_to_the,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .merge(TextStyle(fontSize: 11)),
              ),
            ),
            ItemsCarouselWidget(
                heroTag: 'menu_trending_item', itemsList: _con.trendingItems),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.list,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).all_menu,
                style: Theme.of(context).textTheme.display1,
              ),
              subtitle: Text(
                S.of(context).longpress_on_the_item_to_add_suplements,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .merge(TextStyle(fontSize: 11)),
              ),
            ),
            _con.items.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.items.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return ItemItemWidget(
                        heroTag: 'menu_list',
                        item: _con.items.elementAt(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
