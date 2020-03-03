import 'package:flutter/material.dart';
import 'package:green_pakistan/src/controllers/Blog_controller.dart';
import 'package:green_pakistan/src/elements/BlogGridItemWidget.dart';
import 'package:green_pakistan/src/elements/BlogListItemWidget.dart';
import 'package:green_pakistan/src/elements/CircularLoadingWidget.dart';
import 'package:green_pakistan/src/elements/DrawerWidget.dart';
import 'package:green_pakistan/src/elements/SearchBarWidget.dart';
import 'package:green_pakistan/src/elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class BlogWidget extends StatefulWidget {
  BlogWidget();

  @override
  _BlogWidgetState createState() => _BlogWidgetState();
}

class _BlogWidgetState extends StateMVC<BlogWidget> {
  String layout = 'grid';

  BlogController _con;

  _BlogWidgetState() : super(BlogController()) {
    _con = controller;
  }
  @override
  void initState() {
    //_con.listenForBlog(id: widget.routeArgument.id);
    _con.listenForBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
//    _con.ca.isNotEmpty ? _con.items[0].nursery.name : '',
          "Blogs",
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshBlog,
        child: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.assignment,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    "Learn To Plant",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.layout = 'list';
                          });
                        },
                        icon: Icon(
                          Icons.format_list_bulleted,
                          color: this.layout == 'list'
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.layout = 'grid';
                          });
                        },
                        icon: Icon(
                          Icons.apps,
                          color: this.layout == 'grid'
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _con.items.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : Offstage(
                      offstage: this.layout != 'list',
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.items.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return BlogListItemWidget(
                            heroTag: 'favorites_list',
                            blog: _con.items.elementAt(index),
                          );
                        },
                      ),
                    ),
              _con.items.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : Offstage(
                      offstage: this.layout != 'grid',
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 2
                            : 4,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(_con.items.length, (index) {
                          return BlogGridItemWidget(
                            heroTag: 'favorites_grid',
                            blog: _con.items.elementAt(index),
                          );
                        }),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
