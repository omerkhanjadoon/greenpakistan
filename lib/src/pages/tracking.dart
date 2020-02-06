import 'package:flutter/material.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/controllers/tracking_controller.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/elements/OrderItemWidget.dart';
import 'package:green_pakistan/src/elements/ShoppingCartButtonWidget.dart';
import 'package:green_pakistan/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class TrackingWidget extends StatefulWidget {
  RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget> {
  TrackingController _con;

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrder(orderId: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).tracking_order,
            style: Theme.of(context)
                .textTheme
                .title
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: _con.order == null || _con.orderStatus.isEmpty
              ? CircularLoadingWidget(height: 300)
              : Column(
                  children: <Widget>[
                    Theme(
                      data: theme,
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    '${S.of(context).order_id}: #${_con.order.id}')),
                            Text(
                              '${_con.order.orderStatus.status}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        children: List.generate(_con.order.itemOrders.length,
                            (indexItem) {
                          return OrderItemWidget(
                              heroTag: 'tracking_orders',
                              order: _con.order,
                              itemOrder:
                                  _con.order.itemOrders.elementAt(indexItem));
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    Theme(
                      data: ThemeData(
                        primaryColor: Theme.of(context).accentColor,
                      ),
                      child: Stepper(
                        controlsBuilder: (BuildContext context,
                            {VoidCallback onStepContinue,
                            VoidCallback onStepCancel}) {
                          return SizedBox(height: 0);
                        },
                        steps: _con.getTrackingSteps(context),
                        currentStep:
                            int.tryParse(this._con.order.orderStatus.id) - 1,
                      ),
                    ),
                  ],
                ),
        ));
  }
}
