import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/searchProducts/location/serachSelectLocality.dart';
import 'package:phonepeproperty/style/palette.dart';

class SearchSelectCity extends StatefulWidget {
  final String catId,
      catName,
      subCatId,
      subCatName,
      additionalInfo,
      priceFrom,
      priceTo,
      stateId,
      stateName;

  SearchSelectCity(
      {this.catId,
      this.catName,
      this.subCatId,
      this.subCatName,
      this.additionalInfo,
      this.priceFrom,
      this.priceTo,
      this.stateId,
      this.stateName});

  @override
  _SearchSelectCityState createState() => _SearchSelectCityState();
}

class _SearchSelectCityState extends State<SearchSelectCity> {
  List<dynamic> data = [];
  List<dynamic> filterlist = [];
  bool isLoading = true;

  TextEditingController controller = TextEditingController();
  String filter = "";

  Widget appBarTitle = Text("Select City", style: Palette.whiteTitle2);
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

  var cityCode;
  var cityName;

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
    fetchCity();
  }

  //----------------------- Build Function -------------------//
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
        actions: [
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
                      hintText: "Search city...",
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
                      Text("Select City", style: Palette.whiteTitle2);
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
              ? _getCityList()
              : Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: Center(child: CircularProgressIndicator()))
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
            Icon(Icons.my_location, size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Card(
              elevation: 0.0,
              color: Colors.white24,
              shape: Palette.cardShape,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Text('India', style: Palette.whiteTitle2)),
            ),
            Text('>', style: Palette.whiteTitle2),
            Card(
              elevation: 0.0,
              color: Colors.white24,
              shape: Palette.cardShape,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Text('${widget.stateName}', style: Palette.whiteTitle2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCityList() {
    return ListView.builder(
      padding: EdgeInsets.all(15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: data == null ? 0 : filterlist.length,
      itemBuilder: (context, index) {
        var _cityCode = filterlist[index]['id'];
        var _cityName = filterlist[index]['name'];

        return ListTile(
          onTap: () {
            setState(() {
              cityCode = _cityCode;
              cityName = _cityName;
              _selecteLocalityNavigation(cityCode, cityName);
            });
          },
          title: Text(
            '$_cityName',
            style: Palette.title2,
          ),
        );
      },
    );
  }

  Future<void> fetchCity() async {
    final String url = "${Constants.SELECT_CITY}&state_code=${widget.stateId}";

    http.Response response = await http.post(url);

    //object response
    //Map<String, dynamic> decode = json.decode(response.body);
    setState(() {
      data = json.decode(response.body);
      filterlist = data;
      isLoading = false;
    });
  }

  void _selecteLocalityNavigation(String cityCode, String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchSelectLocality(
          catId: widget.catId,
          catName: widget.catName,
          subCatId: widget.subCatId,
          subCatName: widget.subCatName,
          stateId: widget.stateId,
          stateName: widget.stateName,
          cityId: cityCode,
          cityName: cityName,
          additionalInfo: widget.additionalInfo,
          priceFrom: widget.priceFrom,
          priceTo: widget.priceTo,
        ),
      ),
    );
  }
}
