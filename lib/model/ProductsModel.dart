class ProductsModel {
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
  final String sqFt;
  final String type;
  final String bhk;

  ProductsModel(
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
    this.sqFt,
    this.type,
    this.bhk,
  );

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
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
      json["Super Build Up Area (Sq.ft)"],
      json["Property Type"],
      json["No. Of Bedrooms"],
    );
  }

  static List<ProductsModel> parseList(List<dynamic> list) {
    return list.map((i) => ProductsModel.fromJson(i)).toList();
  }
}
