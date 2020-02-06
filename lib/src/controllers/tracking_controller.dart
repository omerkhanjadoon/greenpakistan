import 'package:flutter/material.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/order.dart';
import 'package:green_pakistan/src/models/order_status.dart';
import 'package:green_pakistan/src/repository/order_repository.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

class TrackingController extends ControllerMVC {
  Order order;
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      listenForOrderStatus();
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus();
    stream.listen((OrderStatus _orderStatus) {
      setState(() {
        orderStatus.add(_orderStatus);
      });
    }, onError: (a) {}, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    this.orderStatus.forEach((OrderStatus _orderStatus) {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          _orderStatus.status,
          style: Theme.of(context).textTheme.subhead,
        ),
        subtitle: order.orderStatus.id == _orderStatus.id
            ? Text(
                '${DateFormat('HH:mm | yyyy-MM-dd').format(order.dateTime)}',
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            : SizedBox(height: 0),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '${Helper.skipHtml(order.hint)}',
            )),
        isActive: (int.tryParse(order.orderStatus.id)) >=
            (int.tryParse(_orderStatus.id)),
      ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrders() async {
    order = new Order();
    listenForOrder(message: 'Tracking refreshed successfuly');
  }
}
