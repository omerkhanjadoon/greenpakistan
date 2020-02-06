import 'package:flutter/material.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/models/route_argument.dart';

import 'CardWidget.dart';

class CardsCarouselWidget extends StatefulWidget {
  List<Nursery> nurserysList;
  String heroTag;

  CardsCarouselWidget({Key key, this.nurserysList, this.heroTag})
      : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.nurserysList.isEmpty
        ? CircularLoadingWidget(height: 288)
        : Container(
            height: 288,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.nurserysList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Details',
                        arguments: RouteArgument(
                          id: widget.nurserysList.elementAt(index).id,
                          heroTag: widget.heroTag,
                        ));
                  },
                  child: CardWidget(
                      nursery: widget.nurserysList.elementAt(index),
                      heroTag: widget.heroTag),
                );
              },
            ),
          );
  }
}
