import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/blog.dart';
import 'package:green_pakistan/src/models/route_argument.dart';

class BlogGridItemWidget extends StatelessWidget {
  final String heroTag;
  final Blog blog;

  BlogGridItemWidget({Key key, this.heroTag, this.blog}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Item',
            arguments:
                new RouteArgument(heroTag: this.heroTag, id: this.blog.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: heroTag + blog.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(this.blog.image),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                blog.title,
                maxLines: 3,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                "1 feb 2020",
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
//
        ],
      ),
    );
  }
}
