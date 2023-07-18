import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/searchProducts/categoryProducts.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;

class SelectSubCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  SelectSubCategory(this.categoryId, this.categoryName, this.categoryImg);

  @override
  State<StatefulWidget> createState() => _SelectSubCategoryState(
      this.categoryId, this.categoryName, this.categoryImg);
}

class _SelectSubCategoryState extends State<SelectSubCategory> {
  String categoryId;
  String categoryName;
  String categoryImg;
  List subCategory;
  bool isLoading = true;

  _SelectSubCategoryState(this.categoryId, this.categoryName, this.categoryImg);

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    subCategory = [];
    fetchSubCategoryData();
    super.initState();
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        elevation: 0.0,
        title: Text("Choose to start", style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      /*------------------ body ----------------*/
      body: ListView(
        children: [
          _topContainer(),
          isLoading ? _loader() : _subCategoryListView(),
        ],
      ),
    );
  }

  Widget _subCategoryListView() {
    return GridView.builder(
      padding: EdgeInsets.all(15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: subCategory.length != null ? subCategory.length : 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        String subCatId = subCategory[index]['sub_cat_id'];
        String subCatImg = subCategory[index]['picture'];
        String subCatName = subCategory[index]['sub_cat_name'];

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryProducts(
                catId: categoryId,
                catName: categoryName,
                subCatId: subCatId,
                subCatName: subCatName,
                additionalInfo: '',
                priceFrom: '',
                priceTo: '',
                stateId: '',
                stateName: '',
                cityId: '',
                cityName: '',
                localityId: '',
                localityName: '',
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(1),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Image(
                    image: subCatImg == null || subCatImg == ''
                        ? NetworkImage('$categoryImg')
                        : NetworkImage('$subCatImg'),
                    //height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black38),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      '$subCatName',
                      style: Palette.whiteTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // leading: Image(
          //   image: subCatImg == null || subCatImg == ''
          //       ? NetworkImage('$categoryImg')
          //       : NetworkImage('$subCatImg'),
          //   height: 28.0,
          // ),
          // title: Text(
          //   '$subCatName',
          //   style: Palette.title2,
          // ),
        );
      },
    );
  }

  Widget _loader() {
    return Container(
      margin: EdgeInsets.all(50),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        color: cDarkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
          //bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 15.0),
          //Text("Choose to start", style: Palette.whiteHeader),
          //SizedBox(height: 15.0),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProducts(
                  catId: widget.categoryId,
                  catName: widget.categoryName,
                  subCatId: "",
                  subCatName: "",
                  additionalInfo: '',
                  priceFrom: '',
                  priceTo: '',
                  stateId: '',
                  stateName: '',
                  cityId: '',
                  cityName: '',
                  localityId: '',
                  localityName: '',
                ),
              ),
            ).then((value) {
              Navigator.pop(context);
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 50.0, child: Image.network('$categoryImg')),
                SizedBox(width: 10.0),
                Card(
                  elevation: 0.0,
                  color: Colors.white24,
                  shape: Palette.cardShape,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Text('$categoryName', style: Palette.whiteTitle2)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: Palette.seachBoxCardShape,
      child: TextField(
        controller: searchController,
        keyboardType: TextInputType.name,
        autocorrect: true,
        style: TextStyle(fontSize: 14.0, decoration: TextDecoration.none),
        /* onChanged: (value) {
          debugPrint('Something changed in Lead Name Text Field');
          //updateLeadName();
        }, */

        decoration: InputDecoration(
          //labelText: 'Lead Name',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Future<void> fetchSubCategoryData() async {
    final String url = Constants.SUB_CATEGORY_LIST;

    var req = {"category_id": categoryId};

    http.Response response = await http.post(url, body: req);

    //object response
    var decode = json.decode(response.body);
    print(decode);

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        subCategory = decode;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }
}
