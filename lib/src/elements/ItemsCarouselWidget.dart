import 'package:flutter/material.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/elements/ItemsCarouselItemWidget.dart';
import 'package:green_pakistan/src/models/item.dart';

class ItemsCarouselWidget extends StatelessWidget {
  List<Item> itemsList;
  String heroTag;

  ItemsCarouselWidget({Key key, this.itemsList, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return itemsList.isEmpty
        ? CircularLoadingWidget(height: 210)
        : Container(
            height: 210,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return ItemsCarouselItemWidget(
                  heroTag: heroTag,
                  marginLeft: _marginLeft,
                  item: itemsList.elementAt(index),
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
