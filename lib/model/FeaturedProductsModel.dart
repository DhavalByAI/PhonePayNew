class FeaturedProductsModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String category;
  final String location;
  final String createdAt;
  final String dealername;
  final String price;
  final String highlight;
  final String featured;
  final String urgent;

  FeaturedProductsModel(
    this.id,
    this.title,
    this.thumbnailUrl,
    this.category,
    this.location,
    this.createdAt,
    this.dealername,
    this.price,
    this.highlight,
    this.featured,
    this.urgent,
  );

  factory FeaturedProductsModel.fromJson(Map<String, dynamic> json) {
    return FeaturedProductsModel(
      json["id"],
      json["product_name"],
      json["picture"],
      json["category"],
      json["location"],
      json["created_at"],
      json["username"],
      json["price"],
      json["highlight"],
      json["featured"],
      json["urgent"],
    );
  }

  static List<FeaturedProductsModel> parseList(List<dynamic> list) {
    return list.map((i) => FeaturedProductsModel.fromJson(i)).toList();
  }
}
