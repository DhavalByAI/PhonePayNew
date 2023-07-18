import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phonepeproperty/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLocality extends StatefulWidget {
  final String stateCode;
  final String stateName;
  final String cityCode;
  final String cityName;

  SelectLocality(this.stateCode, this.stateName, this.cityCode, this.cityName);

  @override
  State<StatefulWidget> createState() => _SelectLocalityState(
      this.stateCode, this.stateName, this.cityCode, this.cityName);
}

class _SelectLocalityState extends State<SelectLocality> {
  String stateCode;
  String stateName;
  String cityCode;
  String cityName;

  _SelectLocalityState(
      this.stateCode, this.stateName, this.cityCode, this.cityName);

  List<dynamic> data = [];
  var noLocalityError;
  List<dynamic> filterlist = [];
  bool isLoading = true;

  TextEditingController controller = TextEditingController();
  String filter = "";

  Widget appBarTitle = Text("Select Locality", style: Palette.whiteTitle2);
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
    fetchCity();
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
                      hintText: "Search Locality...",
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
                      Text("Select Locality", style: Palette.whiteTitle2);
                  filterlist = data;
                  controller.clear();
                }
              });
            },
          ),

          //select city state icon
          IconButton(
            icon: Icon(Icons.done, color: Colors.white),
            onPressed: () {
              selectedState();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home', (Route<dynamic> route) => false);
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
              ? filterlist.length != 0
                  ? _getCityList()
                  : Container(
                      margin:
                          EdgeInsets.only(top: 100.0, right: 20.0, left: 20.0),
                      child: Text(
                        '$noLocalityError',
                        style: Palette.header,
                      ),
                    )
              : Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: cDarkBlue,
                    ),
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
            Icon(Icons.my_location, size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Expanded(
              child: Card(
                elevation: 0.0,
                color: Colors.white24,
                shape: Palette.cardShape,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: Text('$stateName', style: Palette.whiteTitle2)),
              ),
            ),
            Text('>', style: Palette.whiteTitle2),
            Expanded(
                child: Card(
              elevation: 0.0,
              color: Colors.white24,
              shape: Palette.cardShape,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Text('$cityName', style: Palette.whiteTitle2)),
            )),
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
        String cityCode = filterlist[index]['id'].toString();
        String cityName = filterlist[index]['name'];

        return ListTile(
          onTap: () {
            setState(() {
              selectCity(cityCode, cityName);
            });
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          },
          title: Text(
            '$cityName',
            style: Palette.title2,
          ),
        );
      },
    );
  }

  Future<void> fetchCity() async {
    final String url = "${Constants.SELECT_LOCALITY}";

    var req = {"city_code": cityCode};

    http.Response response = await http.post(url, body: req);

    //object response
    //Map<String, dynamic> decode = json.decode(response.body);
    setState(() {
      /* var responseData = json.decode(response.body);
      if (responseData['status'] == 'error') {
        isLoading = false;
        noLocalityError = 'No Locality are Available..!';
      } else {
        filterlist = data;
        isLoading = false;
        print('locality ==== $data');
      } */
      var decode = json.decode(response.body);
      data = decode['data'];
      filterlist = data;
      isLoading = false;
    });
  }

  void selectedState() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('state_code', stateCode);
    preferences.setString('state_name', stateName);
    preferences.setString('city_code', cityCode);
    preferences.setString('city_name', cityName);
    preferences.setString('locality_code', '');
    preferences.setString('locality_name', '');
  }

  void selectCity(String _cityCode, String _cityName) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString('state_code', stateCode);
    preferences.setString('state_name', stateName);
    preferences.setString('city_code', cityCode);
    preferences.setString('city_name', cityName);
    preferences.setString('locality_code', _cityCode);
    preferences.setString('locality_name', _cityName);
  }
}
