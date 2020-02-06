import 'package:flutter/material.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/controllers/home_controller.dart';
import 'package:green_pakistan/src/elements/CardsCarouselWidget.dart';
import 'package:green_pakistan/src/elements/CaregoriesCarouselWidget.dart';
import 'package:green_pakistan/src/elements/GridWidget.dart';
import 'package:green_pakistan/src/elements/ItemsCarouselWidget.dart';
import 'package:green_pakistan/src/elements/ReviewsListWidget.dart';
import 'package:green_pakistan/src/elements/SearchBarWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _con.refreshHome,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.stars,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).top_nurserys,
                  style: Theme.of(context).textTheme.display1,
                ),
                subtitle: Text(
                  S.of(context).ordered_by_nearby_first,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            CardsCarouselWidget(
                nurserysList: _con.topNursery, heroTag: 'home_top_nurserys'),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
                itemsList: _con.trendingItems, heroTag: 'home_item_carousel'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.category,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).item_categories,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            CategoriesCarouselWidget(
              categories: _con.categories,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.trending_up,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).most_popular,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridWidget(
                nurserysList: _con.topNursery,
                heroTag: 'home_nurserys',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                leading: Icon(
                  Icons.recent_actors,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).recent_reviews,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ReviewsListWidget(reviewsList: _con.recentReviews),
            ),
          ],
        ),
      ),
    );
  }
}
