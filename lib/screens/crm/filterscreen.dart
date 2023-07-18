import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/crm/crm.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class FilterScreen extends StatefulWidget {


  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  List statusList = [];
  List sourceList = [];


  RangeValues _priceRange = RangeValues(0, 1000000000);
  String oneCrPrice;
  String start;
  String end;
  var priceStart;
  var priceEnd;

  var statusValue;
  var sourceValue;

  TextEditingController firstNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchdropDownData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('Filter', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: _filter(),
    );
  }

  Widget _priceRangeWidget() {
    var _formatedpricefrom =
    NumberFormatter.formatter(_priceRange.start.toInt().toString());
    var _formatedpriceTo =
    NumberFormatter.formatter(_priceRange.end.toInt().toString());

    return Container(
      //margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        //shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Container(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Price Range', style: Palette.title2),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      _formatedpricefrom,
                      style: Palette.title2,
                    ),
                  ),
                  Container(child: Text('  to  ', style: Palette.title2)),
                  Container(
                    child: oneCrPrice == '10000000'
                        ? Text(
                      _formatedpriceTo + ' +',
                      style: Palette.title2,
                    )
                        : Text(
                      _formatedpriceTo,
                      style: Palette.title2,
                    ),
                  ),
                ],
              ),
              Container(
                child: RangeSlider(
                  activeColor: cDarkBlue,
                  inactiveColor: Colors.grey,
                  values: _priceRange,
                  min: 0,
                  max: 1000000000,
                  divisions: 20,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                      //oneCrPrice = _priceRange.end.toInt().toString();
                      //print(_priceRange);
                      //start = _formatedpricefrom;
                      //end = _formatedpriceTo;

                      priceStart = values.start;
                      priceEnd = values.end;

                      print('start:::::::::::$priceStart');
                      print('end:::::::::::$priceEnd');
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _filter() {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              _priceRangeWidget(),
              SizedBox(height: 10.0,),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                elevation: 10.0,
                child: TextField(
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  style: Palette.textFieldBlack,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter First Name',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                elevation: 10.0,
                child: Container(
                  height: 50,
                  child: DropdownButtonFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    value: statusValue,
                    hint: Text('Select Status'),
                    items: statusList.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        statusValue = newValue;
                        print('status:::::::$statusValue');
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                elevation: 10.0,
                child: Container(
                  height: 50,
                  child: DropdownButtonFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    value: sourceValue,
                    hint: Text('Select Source'),
                    items: sourceList.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        sourceValue = newValue;
                        print('sourceValue:::::::$sourceValue');
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              _addButton()
            ],
          )
      ),
    );
  }

  Widget _addButton() {
    return Center(
      child: InkWell(
        onTap: () {
          var fName =  firstNameController.text;

          print(fName);
          print(sourceValue);
          print(statusValue);
          print(priceStart);
          print(priceEnd);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CRM( name: fName,sourceId: sourceValue,statusId: statusValue,start: priceStart,end: priceEnd,),
            ),
          );

        },
        child: Container(
          width: 200,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: cDarkBlue,
          ),
          child: Center(
            child: Text('Search',style: Palette.addButton,),
          ),
        ),
      ),
    );
  }

  fetchdropDownData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.getString('userid');
    String token = pref.getString('token');
    String url = Constants.FETCH_DROPDOWNDATA;

    var requestBody = {
      'user_id': userid,
    };

    var response = await http.post(
      url,
      body: requestBody,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        statusList = items['status'];
        sourceList = items['source'];
      });
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }
}
