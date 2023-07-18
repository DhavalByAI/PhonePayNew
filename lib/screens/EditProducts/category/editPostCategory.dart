import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/model/CategoryModel.dart';
import 'package:phonepeproperty/screens/EditProducts/category/editPostSubCategory.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPostCategory extends StatefulWidget {
  final String title,
      postId,
      catId,
      catName,
      catImg,
      subCatId,
      subCatName,
      price,
      mobileNo,
      desc,
      stateCode,
      statename,
      cityCode,
      cityName,
      localityName,
      localityCode,
      address,
      additionalList;
  final List images;
  final double latValue;
  final double longValue;
  const EditPostCategory(
      {this.title,
      this.postId,
      this.catId,
      this.catName,
      this.catImg,
      this.subCatId,
      this.subCatName,
      this.price,
      this.mobileNo,
      this.desc,
      this.images,
      this.stateCode,
      this.statename,
      this.cityCode,
      this.cityName,
      this.localityName,
      this.localityCode,
      this.latValue,
      this.longValue,
      this.address,
      this.additionalList});

  @override
  _EditPostCategoryState createState() => _EditPostCategoryState();
}

class _EditPostCategoryState extends State<EditPostCategory> {
  List<CategoryModel> _modelCateory;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _modelCateory = [];
    _loading = true;
    this.fetchAppConfigData();
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search By Property Type',
          style: Palette.whiteTitle2,
        ),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      /*------------------ body ----------------*/
      body: _loading == false
          ? ListView.builder(
              padding: EdgeInsets.all(15.0),
              itemCount: _modelCateory.length,
              itemBuilder: (context, index) {
                CategoryModel modelCategory = _modelCateory[index];
                String categoryId = modelCategory.id;
                String categoryImg = modelCategory.picture;
                String categoryName = modelCategory.name;
                List subCategory = modelCategory.subCategory;

                return Card(
                  margin: EdgeInsets.all(6.0),
                  elevation: 12.0,
                  shadowColor: Colors.black26,
                  shape: Palette.topCardShape,
                  child: ListTile(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPostsubCategory(
                            postId: widget.postId,
                            title: widget.title,
                            catId: categoryId,
                            catName: categoryName,
                            catImg: categoryImg,
                            subCatId: widget.subCatId,
                            subCatName: widget.subCatName,
                            price: widget.price,
                            mobileNo: widget.mobileNo,
                            desc: widget.desc,
                            images: widget.images,
                            stateCode: widget.stateCode,
                            statename: widget.statename,
                            cityCode: widget.cityCode,
                            cityName: widget.cityName,
                            localityName: widget.localityName,
                            localityCode: widget.localityCode,
                            latValue: widget.latValue,
                            longValue: widget.longValue,
                            address: widget.address,
                            subcatList: subCategory,
                          ),
                        )),
                    leading: Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage('$categoryImg'))),
                    ),
                    title: Text('$categoryName', style: Palette.title2),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> fetchAppConfigData() async {
    final String url = Constants.CATEGORY_LIST;

    http.Response response = await http.get(url);

    //object response
    var decode = json.decode(response.body);

    List categoryData = decode;
    List<CategoryModel> setCategory = CategoryModel.parseList(categoryData);

    setState(() {
      _modelCateory.addAll(setCategory);
      //print(categoryData);

      if (response.statusCode == 200) {
        _loading = false;
      } else {
        _loading = true;
      }
    });
  }
}
