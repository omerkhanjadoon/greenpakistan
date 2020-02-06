import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/item.dart';

typedef ItemBoolFunc = void Function(Item item, {bool reset});

class AddToCartAlertDialogWidget extends StatelessWidget {
  final Item oldItem;
  final Item newItem;
  final ItemBoolFunc onPressed;

  const AddToCartAlertDialogWidget({
    Key key,
    @required this.oldItem,
    @required this.newItem,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Reset Cart?"),
//      content: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Text("You want to reset your cart and add this item ?"),
//          SizedBox(height: 10),
//          Text("Because you must add items of the same nursery.(${oldItem.nursery.name})"),
//        ],
//      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: Text(
              "You must add items of the same nurserys choose one nurserys only!",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              onPressed(newItem, reset: true);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      blurRadius: 5,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'new_nursery' + this.newItem?.nursery?.id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image: NetworkImage(
                                this.newItem?.nursery?.image?.thumb),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.newItem.nursery.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Reset your cart and order meals form this nursery',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      blurRadius: 5,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'old_nursery' + this.oldItem.nursery.id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            image:
                                NetworkImage(this.oldItem.nursery.image.thumb),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.oldItem.nursery.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Keep your old meals of this nursery',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text("Reset"),
          onPressed: () {
            onPressed(newItem, reset: true);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: new Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
