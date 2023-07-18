import 'package:flutter/material.dart';
import 'package:phonepeproperty/screens/AddProducts/selectcityPost.dart';
import 'package:phonepeproperty/style/palette.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phonepeproperty/config/constant.dart';

class SelectStateAddProd extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final String subCatId;
  final String subCatName;
  final String adTitle;
  final String price;
  final String mobileNo;
  final String desc;
  final List<String> images;
  final String stateCode;
  final String stateName;
  final String cityCode;
  final String cityName;
  final String localityCode;
  final String localityName;

  SelectStateAddProd(
    this.categoryId,
    this.categoryName,
    this.categoryImg,
    this.subCatId,
    this.subCatName,
    this.adTitle,
    this.price,
    this.mobileNo,
    this.desc,
    this.images,
    this.stateCode,
    this.stateName,
    this.cityCode,
    this.cityName,
    this.localityCode,
    this.localityName,
  );

  @override
  State<StatefulWidget> createState() => _SelectStateAddProdState(
        this.categoryId,
        this.categoryName,
        this.categoryImg,
        this.subCatId,
        this.subCatName,
        this.adTitle,
        this.price,
        this.mobileNo,
        this.desc,
        this.images,
        this.stateCode,
        this.stateName,
        this.cityCode,
        this.cityName,
        this.localityCode,
        this.localityName,
      );
}

class _SelectStateAddProdState extends State<SelectStateAddProd> {
  String categoryId;
  String categoryName;
  String categoryImg;
  String subCatId;
  String subCatName;
  String adTitle;
  String price;
  String mobileNo;
  String desc;
  List<String> images;
  String stateCode;
  String stateName;
  String cityCode;
  String cityName;
  String localityCode;
  String localityName;

  _SelectStateAddProdState(
    this.categoryId,
    this.categoryName,
    this.categoryImg,
    this.subCatId,
    this.subCatName,
    this.adTitle,
    this.price,
    this.mobileNo,
    this.desc,
    this.images,
    this.stateCode,
    this.stateName,
    this.cityCode,
    this.cityName,
    this.localityCode,
    this.localityName,
  );

  List<dynamic> data = [];
  List<dynamic> filterlist = [];
  bool isLoading = true;

  TextEditingController controller = TextEditingController();
  String filter = "";

  Widget appBarTitle = Text("Select Location", style: Palette.whiteTitle2);
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    List<dynamic> tmpList = List<dynamic>();
    for (int i = 0; i < data.length; i++) {
      tmpList.add(data[i]);
    }
    setState(() {
      data = tmpList;
      filterlist = data;

      controller.addListener(() {
        if (controller.text.isEmpty) {
          setState(() {
            filter = "";
            filterlist = data;
          });
        } else {
          setState(() {
            filter = controller.text;
          });
        }
      });
    });

    super.initState();
    fetchState();
  }

  @override
  Widget build(BuildContext context) {
    //search function
    if ((filter.isNotEmpty)) {
      List<dynamic> tmpList = List<dynamic>();
      for (int i = 0; i < filterlist.length; i++) {
        if (filterlist[i]['name']
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          tmpList.add(filterlist[i]);
        }
      }
      filterlist = tmpList;
    }

    //
    /*------------------ scaffold ----------------*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        //shape: Palette.seachBoxCardShape,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: appBarTitle,
        brightness: Brightness.dark,
        centerTitle: true,
        actions: <Widget>[
          //search icon....
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(Icons.close, color: Colors.white);
                  this.appBarTitle = TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "Search State...",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                    autofocus: true,
                    cursorColor: Colors.white,
                  );
                } else {
                  this.actionIcon = Icon(Icons.search, color: Colors.white);
                  this.appBarTitle =
                      Text("Select Location", style: Palette.whiteTitle2);
                  filterlist = data;
                  controller.clear();
                }
              });
            },
          ),
        ],
      ),

      //
      /*------------------ body ----------------*/
      //
      body: ListView(
        children: [
          _topContainer(),
          isLoading == false
              ? _getStateList()
              : Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: cDarkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60.0),
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Card(
              elevation: 0.0,
              color: Colors.white24,
              shape: Palette.cardShape,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Text('India', style: Palette.whiteTitle2)),
            )
          ],
        ),
      ),
    );
  }

  Widget _getStateList() {
    return ListView.builder(
      padding: EdgeInsets.all(15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: data == null ? 0 : filterlist.length,
      itemBuilder: (context, index) {
        var _stateCode = filterlist[index]['code'];
        var _stateName = filterlist[index]['name'];

        return ListTile(
          onTap: () {
            setState(() {
              stateCode = _stateCode;
              stateName = _stateName;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCityAddProd(
                          categoryId,
                          categoryName,
                          categoryImg,
                          subCatId,
                          subCatName,
                          adTitle,
                          price,
                          mobileNo,
                          desc,
                          images,
                          stateCode,
                          stateName,
                          '',
                          '',
                          '',
                          '')));
            });
          },
          title: Text(
            '$_stateName',
            style: Palette.title2,
          ),
        );
      },
    );
  }

  Future<void> fetchState() async {
    final String url = Constants.SELECT_STATE;

    var req = {"country_code": "in"};

    http.Response response = await http.post(url, body: req);

    //object response
    //Map<String, dynamic> decode = json.decode(response.body);
    setState(() {
      var decode = json.decode(response.body);
      data = decode['data'];
      filterlist = data;
      isLoading = false;
    });
  }
}
