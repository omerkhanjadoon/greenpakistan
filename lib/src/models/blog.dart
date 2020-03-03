class Blog {
  String id;
  String title;
  String description;
  String image;

  Blog(this.id, this.title, this.description, this.image);

  Blog.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'].toString(),
        title = jsonMap['title'],
        description = jsonMap['description'],
        image = jsonMap['media'][0]['url'];
}
