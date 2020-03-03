import 'package:flutter/material.dart';
import 'package:green_pakistan/src/models/blog.dart';
import 'package:green_pakistan/src/repository/blog_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class BlogController extends ControllerMVC {
  List<Blog> items = <Blog>[];
  List<Blog> blogs = <Blog>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Blog blog;

  BlogController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForBlogs() async {
    final List<Blog> stream = getBlogs();
    setState(() => this.items = stream);

//    stream.listen((List<Blog> _blogs) {
//      setState(() => blogs = _blog);
//    }, onError: (a) {
//      print(a);
//      scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text('Check your internet connection'),
//      ));
//    }, onDone: () {
//      scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text("Blogs refreshed successfully!"),
//      ));
//    });
  }

  void listenForBlog({String id, String message}) async {
    final Stream<Blog> stream = await getBlog(id);
    stream.listen((Blog _blog) {
      setState(() => blog = _blog);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Check your internet connection'),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshBlog() async {
    items.clear();
    // blog = new Blog();

    listenForBlogs();
  }
}
