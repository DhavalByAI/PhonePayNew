import 'package:flutter/material.dart';
import 'package:phonepeproperty/model/CategoryModel.dart';
import 'package:phonepeproperty/screens/category/selectSubCatToAdd.dart';
import 'package:phonepeproperty/style/palette.dart';

import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectCategory extends StatefulWidget {
  final String title;

  SelectCategory(this.title);

  @override
  State<StatefulWidget> createState() => _SelectCategoryState(this.title);
}

class _SelectCategoryState extends State<SelectCategory> {
  List<CategoryModel> _modelCateory;

  bool _loading;

  String title;
  _SelectCategoryState(this.title);

  @override
  void initState() {
    super.initState();
    fetchAppConfigData();
    _modelCateory = [];
    _loading = true;
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: cDarkBlue,
          title: Text(
            'Property Type',
            style: Palette.whiteTitle2,
          ),
          brightness: Brightness.dark,
          centerTitle: true,
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
                    shadowColor: cDarkBlue,
                    shape: Palette.topCardShape,
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectSubCatToAddProd(
                                  title,
                                  categoryId,
                                  categoryName,
                                  categoryImg,
                                  subCategory))),
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
      ),
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
