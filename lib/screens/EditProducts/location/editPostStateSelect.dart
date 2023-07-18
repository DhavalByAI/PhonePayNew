import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/EditProducts/location/editPostCitySelect.dart';
import 'package:phonepeproperty/style/palette.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPostStateSelect extends StatefulWidget {
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
  const EditPostStateSelect(
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
  _EditPostStateSelectState createState() => _EditPostStateSelectState();
}

class _EditPostStateSelectState extends State<EditPostStateSelect> {
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

  //
  /*------------------ Build Funcation ----------------*/
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
        //shape: Palette.seachBoxCardShape,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: appBarTitle,
        brightness: Brightness.dark,
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
        color: Theme.of(context).primaryColor,
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
          title: Text(
            '$_stateName',
            style: Palette.title2,
          ),
          onTap: () {
            _selectedCityNavigation(_stateCode, _stateName);
          },
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
      isLoading = false;
    });
  }

  void _selectedCityNavigation(String stateCode, String stateName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostCitySelect(
          postId: widget.postId,
          title: widget.title,
          catId: widget.catId,
          catName: widget.catName,
          catImg: widget.catImg,
          subCatId: widget.subCatId,
          subCatName: widget.subCatName,
          price: widget.price,
          mobileNo: widget.mobileNo,
          desc: widget.desc,
          images: widget.images,
          stateCode: stateCode,
          statename: stateName,
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
}
