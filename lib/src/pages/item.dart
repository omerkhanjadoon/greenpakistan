import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/controllers/item_controller.dart';
import 'package:green_pakistan/src/elements/AddToCartAlertDialog.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/elements/ExtraItemWidget.dart';
import 'package:green_pakistan/src/elements/ReviewsListWidget.dart';
import 'package:green_pakistan/src/elements/ShoppingCartFloatButtonWidget.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// ignore: must_be_immutable
class ItemWidget extends StatefulWidget {
  RouteArgument routeArgument;

  ItemWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ItemWidgetState createState() {
    return _ItemWidgetState();
  }
}

class _ItemWidgetState extends StateMVC<ItemWidget> {
  ItemController _con;

  _ItemWidgetState() : super(ItemController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForItem(itemId: widget.routeArgument.id);
    _con.listenForFavorite(itemId: widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.item == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              onRefresh: _con.refreshItem,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 120),
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
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
                              tag: widget.routeArgument.heroTag ??
                                  '' + _con.item.id,
                              child: Image.network(
                                _con.item.image.url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Wrap(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _con.item.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2,
                                          ),
                                          Text(
                                            _con.item.nursery.name,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Helper.getPrice(
                                            _con.item.price,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3,
                                          ),
                                          Text(
                                            _con.item.weight + S.of(context).g,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 40),
                                Text(Helper.skipHtml(_con.item.description)),
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.add_circle,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).extras,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                  subtitle: Text(
                                    S
                                        .of(context)
                                        .select_extras_to_add_them_on_the_item,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return ExtraItemWidget(
                                      extra: _con.item.extras.elementAt(index),
                                      onChanged: _con.calculateTotal,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 20);
                                  },
                                  itemCount: _con.item.extras.length,
                                  primary: false,
                                  shrinkWrap: true,
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.donut_small,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).ingredients,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Helper.applyHtml(context, _con.item.ingredients,
                                    style: TextStyle(fontSize: 12)),
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.local_activity,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).nutrition,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(
                                      _con.item.nutritions.length, (index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(0.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 6.0)
                                          ]),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                              _con.item.nutritions
                                                  .elementAt(index)
                                                  .name,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                          Text(
                                              _con.item.nutritions
                                                  .elementAt(index)
                                                  .quantity
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  leading: Icon(
                                    Icons.recent_actors,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).reviews,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                ReviewsListWidget(
                                  reviewsList: _con.item.itemReviews,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 32,
                    right: 20,
                    child: _con.loadCart
                        ? SizedBox(
                            width: 60,
                            height: 60,
                            child: RefreshProgressIndicator(),
                          )
                        : ShoppingCartFloatButtonWidget(
                            iconColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).hintColor,
                            item: _con.item,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 140,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.15),
                                offset: Offset(0, -2),
                                blurRadius: 5.0)
                          ]),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).quantity,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        _con.decrementQuantity();
                                      },
                                      iconSize: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    ),
                                    Text(_con.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead),
                                    IconButton(
                                      onPressed: () {
                                        _con.incrementQuantity();
                                      },
                                      iconSize: 30,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      icon: Icon(Icons.add_circle_outline),
                                      color: Theme.of(context).hintColor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _con.favorite?.id != null
                                      ? OutlineButton(
                                          onPressed: () {
                                            _con.removeFromFavorite(
                                                _con.favorite);
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context).primaryColor,
                                          shape: StadiumBorder(),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .accentColor),
                                          child: Icon(
                                            Icons.favorite,
                                            color:
                                                Theme.of(context).accentColor,
                                          ))
                                      : FlatButton(
                                          onPressed: () {
                                            _con.addToFavorite(_con.item);
                                          },
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14),
                                          color: Theme.of(context).accentColor,
                                          shape: StadiumBorder(),
                                          child: Icon(
                                            Icons.favorite,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                ),
                                SizedBox(width: 10),
                                Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: FlatButton(
                                        onPressed: () {
                                          if (_con.isSameNursery(_con.item)) {
                                            _con.addToCart(_con.item);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AddToCartAlertDialogWidget(
                                                    oldItem: _con.cart?.item,
                                                    newItem: _con.item,
                                                    onPressed: (item,
                                                        {reset: true}) {
                                                      return _con.addToCart(
                                                          _con.item,
                                                          reset: true);
                                                    });
                                              },
                                            );
                                          }
                                        },
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        color: Theme.of(context).accentColor,
                                        shape: StadiumBorder(),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            S.of(context).add_to_cart,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Helper.getPrice(
                                        _con.total,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
