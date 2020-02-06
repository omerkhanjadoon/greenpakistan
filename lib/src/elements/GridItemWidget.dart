import 'package:flutter/material.dart';
import 'package:green_pakistan/src/helpers/helper.dart';
import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/models/route_argument.dart';

class GridItemWidget extends StatelessWidget {
  Nursery nursery;
  String heroTag;

  GridItemWidget({Key key, this.nursery, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Details',
            arguments: RouteArgument(id: nursery.id, heroTag: heroTag));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Hero(
                  tag: heroTag + nursery.id,
                  child: Image.network(
                    nursery.image.thumb,
                    fit: BoxFit.cover,
                    height: 82,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              nursery.name,
              style: Theme.of(context).textTheme.body1,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: 2),
            Expanded(
              child: Row(
                children: Helper.getStarsList(double.parse(nursery.rate)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
