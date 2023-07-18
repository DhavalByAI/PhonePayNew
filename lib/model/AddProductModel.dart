class ModelAddProduct {
  String _catId = '';
  String _catName = '';

  ModelAddProduct(this._catId, this._catName);

  String get cateId => _catId;
  String get cateName => _catName;

  set cateId(String newCateId) { this._catId = newCateId; }
  set cateName(String newCateName) { this._catName = newCateName; }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['catId'] = _catId;
    map['catName'] = _catName;

    return map;
  }

  // Extract a Note object from a Map object
  ModelAddProduct.fromMapObject(Map<String, dynamic> map) {
    this._catId = map['catId'];
    this._catName = map['catName'];
  }
}
