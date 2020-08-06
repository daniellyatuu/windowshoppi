class Category {
  int id;
  String title;

  Category({this.id, this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['name'],
    );
  }
}
