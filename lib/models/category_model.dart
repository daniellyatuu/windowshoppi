class CategoryList {
  int id;
  String title;

  CategoryList({this.id, this.title});

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      id: json['id'],
      title: json['name'],
    );
  }
}
