import 'package:flutter/material.dart';
import 'package:green_pakistan/generated/i18n.dart';
import 'package:green_pakistan/src/elements/SearchWidget.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchModal());
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            Text(
              S.of(context).search_for_nurserys_or_items,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .merge(TextStyle(fontSize: 14)),
            )
          ],
        ),
      ),
    );
  }
}
