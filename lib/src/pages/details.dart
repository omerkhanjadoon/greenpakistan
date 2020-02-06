import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/controllers/nursery_controller.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/elements/GalleryCarouselWidget.dart';
import 'package:green_pakistan/src/elements/ItemItemWidget.dart';
import 'package:green_pakistan/src/elements/ReviewsListWidget.dart';
import 'package:green_pakistan/src/elements/ShoppingCartFloatButtonWidget.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsWidget extends StatefulWidget {
  RouteArgument routeArgument;

  DetailsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  NurseryController _con;

  _DetailsWidgetState() : super(NurseryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForNursery(id: widget.routeArgument.id);
    _con.listenForGalleries(widget.routeArgument.id);
    _con.listenForNurseryReviews(id: widget.routeArgument.id);
    _con.listenForFeaturedItems(widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/Menu',
                arguments: new RouteArgument(id: widget.routeArgument.id));
          },
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          icon: Icon(Icons.nursery),
          label: Text(S.of(context).menu),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: RefreshIndicator(
          onRefresh: _con.refreshNursery,
          child: _con.nursery == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.9),
                          expandedHeight: 300,
                          elevation: 0,
                          iconTheme: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Hero(
                              tag: widget.routeArgument.heroTag +
                                  _con.nursery.id,
                              child: Image.network(
                                _con.nursery.image.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, bottom: 10, top: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.nursery.name,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 32,
                                      child: Chip(
                                        padding: EdgeInsets.all(0),
                                        label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(_con.nursery.rate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body2
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor))),
                                            Icon(
                                              Icons.star_border,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Html(
                                  data: _con.nursery.description,
                                  defaultTextStyle: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .merge(TextStyle(fontSize: 14)),
                                ),
                              ),
                              ImageThumbCarouselWidget(
                                  galleriesList: _con.galleries),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  leading: Icon(
                                    Icons.stars,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).information,
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Helper.applyHtml(
                                    context, _con.nursery.information),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.nursery.address,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style:
                                            Theme.of(context).textTheme.body2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              '/Map',
                                              arguments: new RouteArgument(
                                                  param: _con.nursery));
                                        },
                                        child: Icon(
                                          Icons.directions,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${_con.nursery.phone} \n${_con.nursery.mobile}',
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.body2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          launch("tel:${_con.nursery.mobile}");
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _con.featuredItems.isEmpty
                                  ? SizedBox(height: 0)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.nursery,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).featured_items,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                      ),
                                    ),
                              _con.featuredItems.isEmpty
                                  ? SizedBox(height: 0)
                                  : ListView.separated(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: _con.featuredItems.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 10);
                                      },
                                      itemBuilder: (context, index) {
                                        return ItemItemWidget(
                                          heroTag: 'details_featured_item',
                                          item: _con.featuredItems
                                              .elementAt(index),
                                        );
                                      },
                                    ),
                              SizedBox(height: 100),
                              _con.reviews.isEmpty
                                  ? SizedBox(height: 5)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.recent_actors,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).what_they_say,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                      ),
                                    ),
                              _con.reviews.isEmpty
                                  ? SizedBox(height: 5)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: ReviewsListWidget(
                                          reviewsList: _con.reviews),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 32,
                      right: 20,
                      child: ShoppingCartFloatButtonWidget(
                        iconColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
        ));
  }
}
