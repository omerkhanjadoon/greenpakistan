import 'package:flutter/material.dart';
import 'package:green_pakistan/src/elements/DrawerWidget.dart';
import 'package:green_pakistan/src/elements/SearchBarWidget.dart';
import 'package:green_pakistan/src/elements/ShoppingCartButtonWidget.dart';

class ConsultancyWidget extends StatefulWidget {
  @override
  _ConsultancyWidgetState createState() => _ConsultancyWidgetState();
}

class _ConsultancyWidgetState extends State<ConsultancyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _con.scaffoldKey,

      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).focusColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "Learn To Plant",
          style: Theme.of(context).textTheme.title.merge(TextStyle(
              letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),

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
            SizedBox(height: 10),
            Center(
                child: Text(
                    "Online Consultancy regarding plants and diseases are Comming Soon  !"))
          ],
        ),
      ),
    );
  }
}
