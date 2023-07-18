import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/EditProducts/editProductOne.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;

class EditPostsubCategory extends StatefulWidget {
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
  final List subcatList;
  final double latValue;
  final double longValue;
  const EditPostsubCategory(
      {this.title,
      this.postId,
      this.catId,
      this.catName,
      this.catImg,
      this.subCatId,
      this.subCatName,
      this.subcatList,
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
  _EditPostsubCategoryState createState() => _EditPostsubCategoryState();
}

class _EditPostsubCategoryState extends State<EditPostsubCategory> {
  String categoryId;
  String categoryName;
  String categoryImg;
  List subCategory;

  TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    categoryId = widget.catId;
    categoryName = widget.catName;
    categoryImg = widget.catImg;
    subCategory = widget.subcatList;
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Choose to start", style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      /*------------------ body ----------------*/
      body: ListView(
        children: [_topContainer(), isLoading ? _loader() : _subCategoryListView()],
      ),
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

  Widget _subCategoryListView() {
    // return ListView.builder(
    //   padding: EdgeInsets.all(15.0),
    //   shrinkWrap: true,
    //   primary: false,
    //   itemCount: subCategory.length,
    //   itemBuilder: (context, index) {
    //     String subCatId = subCategory[index]['id'];
    //     String subCatImg = subCategory[index]['picture'];
    //     String subCatName = subCategory[index]['name'];

    //     return ListTile(
    //       onTap: () {
    //         _editPostNavigation(subCatId, subCatName);
    //       },
    //       leading: Image(
    //         image: subCatImg == null || subCatImg == ''
    //             ? NetworkImage('$categoryImg')
    //             : NetworkImage('$subCatImg'),
    //         height: 28.0,
    //       ),
    //       title: Text(
    //         '$subCatName',
    //         style: Palette.title2,
    //       ),
    //     );
    //   },
    // );

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
          onTap: () {
            _editPostNavigation(subCatId, subCatName);
          },
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

  Widget _topContainer() {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 15.0),
          //Text("Choose to start", style: Palette.whiteHeader),
          //SizedBox(height: 15.0),
          InkWell(
            // onTap: () => Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => CategoryProducts(
            //             categoryId, categoryName, "", "All", '', '', ''))),
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

  void _editPostNavigation(String subCatId, String subCatname) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductOne(
          postId: widget.postId,
          title: widget.title,
          catId: widget.catId,
          catName: widget.catName,
          subCatId: subCatId,
          subCatName: subCatname,
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
