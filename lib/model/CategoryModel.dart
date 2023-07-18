class CategoryModel {
  final String id;
  final String icon;
  final String name;
  final String picture;
  final List subCategory;

  CategoryModel(
    this.id,
    this.icon,
    this.name,
    this.picture,
    this.subCategory
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      json["cat_id"],
      json["icon"],
      json["cat_name"],
      json["picture"],
      json["sub_category"]
    );
  }

  static List<CategoryModel> parseList(List<dynamic> list) {
    return list.map((i) => CategoryModel.fromJson(i)).toList();
  }
}
