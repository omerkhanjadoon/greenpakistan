import 'package:flutter/material.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/item.dart';
import 'package:green_pakistan/src/models/route_argument.dart';

class ItemsCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Item item;
  String heroTag;

  ItemsCarouselItemWidget({Key key, this.heroTag, this.marginLeft, this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Item',
            arguments: RouteArgument(id: item.id, heroTag: heroTag));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Hero(
                tag: heroTag + item.id,
                child: Container(
                  margin: EdgeInsets.only(left: this.marginLeft, right: 20),
                  width: 100,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(item.image.thumb),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25, top: 5),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Theme.of(context).accentColor),
                alignment: AlignmentDirectional.topEnd,
                child: Helper.getPrice(
                  item.price,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
              width: 100,
              margin: EdgeInsets.only(left: this.marginLeft, right: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    this.item.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    this.item.nursery.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
