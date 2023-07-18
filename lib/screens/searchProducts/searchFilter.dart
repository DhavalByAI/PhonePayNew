import 'package:flutter/material.dart';
import 'package:phonepeproperty/screens/searchProducts/categoryProducts.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'dart:convert';
import 'package:phonepeproperty/widgets/loadingDialog.dart';

class SearchByFilter extends StatefulWidget {
  final String catId;
  final String catName;
  final String subCatId;
  final String subCatName;

  SearchByFilter(this.catId, this.catName, this.subCatId, this.subCatName);

  @override
  State<StatefulWidget> createState() => _SearchByFilterState(
      this.catId, this.catName, this.subCatId, this.subCatName);
}

class _SearchByFilterState extends State<SearchByFilter> {
  String catId;
  String catName;
  String subCatId;
  String subCatName;

  _SearchByFilterState(
      this.catId, this.catName, this.subCatId, this.subCatName);

  List _radioData = [];
  List _radioGrpData = [];

  List _response;
  String _responseString;

  int value;

  String _personalRadio = '34'; //custom[26]
  String _typeRadio = '83'; //custom[40]
  String _reraRadio = '120'; //custom[48]
  String _stageRadio = '85'; //custom[41]
  String _reservedRadio = '61'; //custom[36]

  TextEditingController _onFloorController = TextEditingController(); //custom[35]
  TextEditingController _supAreaController = TextEditingController(); //custom[27]
  TextEditingController _carpetAreaController = TextEditingController(); //custom[28]
  TextEditingController _totalFloorController = TextEditingController(); //custom[34]

  String _amenitiesCheck; //custom[37]
  String _amenitiesValue;
  String _liftValue; //63
  bool _lift = false;
  String _parkValue; //64
  bool _park = false;

  String _waterCheck; //custom[38]
  String _otherRoomCheck; //custom[53]

  List<String> _bedRoomDropDown = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9+'
  ]; //custom[29] (37, 38, 39, 40, 41, 81, 82, 42, 127)
  String _selectBedRoom = '2';
  String _bedRoomValue = '38';

  List<String> _bathRoomDropDown = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10+'
  ]; //custom[30] (43, 44, 45, 46, 47, 128, 129, 130, 131, 132)
  String _selectBathRoom = '2';
  String _bathRoomValue = '44';

  List<String> _balconiesDropDown = ['1', '2', '3+']; //custom[31] (48, 49, 50)
  String _selectedBalcony = '1';
  String _balconeyValue = '48';

  List<String> _furnishingDropDown = [
    'Furnished',
    'Semi - Furnished',
    'Unfurnished'
  ]; //custom[33] (58, 59, 60)
  String _selectFurnish = 'Unfurnished';
  String _furnishValue = '60';

  List<String> _facingDropDown = [
    'East',
    'West',
    'North',
    'South',
    'North East',
    'South East',
    'North West',
    'South West'
  ]; //custom[39] (73, 74, 75, 76, 77, 78, 79, 80)
  String _selectFacing = 'East';
  String _facingValue = '73';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  /*------------------ price ----------------*/
  RangeValues _priceRange = RangeValues(10000, 2000000);
  String oneCrPrice;

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  /*---------------------- Build Funcation ------------------------*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addition Info', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      /*------------------ body ----------------*/
      body: ListView(
        children: [
          _priceRangeWidget(),
          _radioContainer(),
          _editTextContainer(),
          //_checkBoxContainer()
          _dropDownContainer(),
          SizedBox(height: 50.0),
        ],
      ),
      floatingActionButton: _saveBtn(),
    );
  }

  Widget _priceRangeWidget() {
    var _formatedpricefrom =
        NumberFormatter.formatter(_priceRange.start.toInt().toString());

    var _formatedpriceTo =
        NumberFormatter.formatter(_priceRange.end.toInt().toString());

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
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
                  values: _priceRange,
                  min: 10000,
                  max: 10000000,
                  divisions: 20,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                      oneCrPrice = _priceRange.end.toInt().toString();
                      print(_priceRange);
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

  Widget _radioList() {
    return ListView.builder(
      padding: EdgeInsets.all(15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: _radioData.length,
      itemBuilder: (context, i) {
        _radioGrpData = _radioData[i]['name'];
        //radio List
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                _radioData[i]['title'],
                style: Palette.title2,
              ),
            ),
            Container(
              height: 32.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: _radioGrpData.length,
                  itemBuilder: (context, i2) {
                    //define value
                    var _radioGrp = _radioGrpData[i2]['name'];
                    var _radioGrpName = _radioGrpData[i2]['name'];
                    var _radioGrpValue = _radioGrpData[i2]['value'];
                    var _radioGrpDataName = _radioGrpData[i2]['data-name'];
                    var _radioGrpChecked = _radioGrpData[i2]['checked'];

                    return Row(
                      children: [
                        Container(
                          child: Text(
                            _radioGrpData[i2]['title'],
                            style: Palette.subTitle2,
                          ),
                        ),
                        Container(
                          child: Radio(
                            value: i2,
                            groupValue: value,
                            onChanged: (val) {
                              setState(() {
                                value = val;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(height: 10.0),
          ],
        );
      },
    );
  }

  Widget _radioContainer() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            /*------------------ Personal Details ----------------*/
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personal Details', style: Palette.title2),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 1
                      Container(child: Text('Owner', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '34',
                          groupValue: _personalRadio,
                          onChanged: (val) {
                            setState(() {
                              _personalRadio = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 5.0),

                      //Radio 2
                      Container(
                          child: Text('Builder', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '35',
                          groupValue: _personalRadio,
                          onChanged: (val) {
                            setState(() {
                              _personalRadio = val;
                            });
                          },
                        ),
                      ),

                      //Radio 3
                      Container(
                          child: Text('Dealer', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '36',
                          groupValue: _personalRadio,
                          onChanged: (val) {
                            setState(() {
                              _personalRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 5.0),

            /*------------------ Property Type ----------------*/
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Property Type', style: Palette.title2),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 1
                      Container(child: Text('New', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '83',
                          groupValue: _typeRadio,
                          onChanged: (val) {
                            setState(() {
                              _typeRadio = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 5.0),

                      //Radio 2
                      Container(
                          child: Text('Resale', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '84',
                          groupValue: _typeRadio,
                          onChanged: (val) {
                            setState(() {
                              _typeRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 5.0),

            /*------------------ RERA Status ----------------*/
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RERA Status', style: Palette.title2),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 1
                      Container(
                          child: Text('Registered', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '120',
                          groupValue: _reraRadio,
                          onChanged: (val) {
                            setState(() {
                              _reraRadio = val;
                            });
                          },
                        ),
                      ),

                      //Radio 2
                      Container(
                          child: Text('Applied for Registered',
                              style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '121',
                          groupValue: _reraRadio,
                          onChanged: (val) {
                            setState(() {
                              _reraRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 3
                      Container(
                          child:
                              Text('Not Applicable', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '136',
                          groupValue: _reraRadio,
                          onChanged: (val) {
                            setState(() {
                              _reraRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 5.0),

            /*------------------ Property Stage ----------------*/
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Property Stage', style: Palette.title2),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 1
                      Container(
                          child: Text('Under Construction',
                              style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '85',
                          groupValue: _stageRadio,
                          onChanged: (val) {
                            setState(() {
                              _stageRadio = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 5.0),

                      //Radio 2
                      Container(
                          child:
                              Text('Ready To Move', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '86',
                          groupValue: _stageRadio,
                          onChanged: (val) {
                            setState(() {
                              _stageRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 3
                      Container(
                          child:
                              Text('Newly Launch', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '87',
                          groupValue: _stageRadio,
                          onChanged: (val) {
                            setState(() {
                              _stageRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 5.0),

            /*------------------ Reserved Parking ----------------*/
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reserved Parking', style: Palette.title2),

                  //Radio Groups
                  Row(
                    children: [
                      //Radio 1
                      Container(child: Text('Yes', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '61',
                          groupValue: _reservedRadio,
                          onChanged: (val) {
                            setState(() {
                              _reservedRadio = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 5.0),

                      //Radio 2
                      Container(child: Text('No', style: Palette.subTitle2)),
                      Container(
                        child: Radio(
                          value: '62',
                          groupValue: _reservedRadio,
                          onChanged: (val) {
                            setState(() {
                              _reservedRadio = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editTextContainer() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            /*------------------ Super Build Up Area (Sq.ft) ----------------*/
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 5.0),
              child: TextField(
                controller: _supAreaController,
                keyboardType: TextInputType.number,
                style: Palette.textField,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Super Build Up Area (Sq.ft)',
                  labelStyle: Palette.textFieldLabel,
                ),
              ),
            ),

            /*------------------ Carpet Area (Sq.ft) ----------------*/
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 5.0),
              child: TextField(
                controller: _carpetAreaController,
                keyboardType: TextInputType.number,
                style: Palette.textField,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Carpet Area (Sq.ft)',
                  labelStyle: Palette.textFieldLabel,
                ),
              ),
            ),

            /*------------------ Property On Floors ----------------*/
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 5.0),
              child: TextField(
                controller: _onFloorController,
                keyboardType: TextInputType.number,
                style: Palette.textField,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Property On Floor (Eg. Ground Floor,  1,2,3)',
                  labelStyle: Palette.textFieldLabel,
                ),
              ),
            ),

            /*------------------ Total Floors (Eg.1,2,3) ----------------*/
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 15.0),
              child: TextField(
                controller: _totalFloorController,
                keyboardType: TextInputType.number,
                style: Palette.textField,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Total Floors (Eg.1,2,3)',
                  labelStyle: Palette.textFieldLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkBoxContainer() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            /*------------------ Amenities ----------------*/
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                children: [
                  Text('Amenities', style: Palette.title2),

                  //CheckboxGoup
                  Row(
                    children: [
                      //Checkbox 1
                      Container(
                        child: Checkbox(
                          value: _lift,
                          onChanged: (val) {
                            setState(() {
                              _lift = val;
                              _lift == true
                                  ? _liftValue = '63'
                                  : _liftValue = '';
                            });
                          },
                        ),
                      ),
                      Expanded(
                          child: Text('Lift(s)', style: Palette.subTitle2)),

                      //Checkbox 2
                      Container(
                        child: Checkbox(
                          value: _park,
                          onChanged: (val) {
                            setState(() {
                              _park = val;
                              _park == true
                                  ? _parkValue = '64'
                                  : _parkValue = '';
                            });
                          },
                        ),
                      ),
                      Expanded(child: Text('Park', style: Palette.subTitle2)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDownContainer() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            /*------------------ Bedrooms ----------------*/
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'No. Of Bedrooms',
                    style: Palette.title2,
                  )),
                  Container(
                    child: DropdownButton(
                      underline: SizedBox(),
                      hint: Text(
                        'Nothing Selected',
                        style: Palette.subTitle,
                      ), // Not necessary for Option 1
                      value: _selectBedRoom,
                      onChanged: (newValue) {
                        setState(() {
                          _selectBedRoom = newValue;
                          _selectBedRoom == '1'
                              ? _bedRoomValue = '37'
                              : _selectBedRoom == '2'
                                  ? _bedRoomValue = '38'
                                  : _selectBedRoom == '3'
                                      ? _bedRoomValue = '39'
                                      : _selectBedRoom == '4'
                                          ? _bedRoomValue = '40'
                                          : _selectBedRoom == '5'
                                              ? _bedRoomValue = '41'
                                              : _selectBedRoom == '6'
                                                  ? _bedRoomValue = '81'
                                                  : _selectBedRoom == '7'
                                                      ? _bedRoomValue = '82'
                                                      : _selectBedRoom == '8'
                                                          ? _bedRoomValue = '42'
                                                          : _selectBedRoom ==
                                                                  '9+'
                                                              ? _bedRoomValue =
                                                                  '127'
                                                              : _bedRoomValue =
                                                                  '';

                          print(_bedRoomValue);
                        });
                      },
                      items: _bedRoomDropDown.map((val) {
                        return DropdownMenuItem(
                          child: Text(val),
                          value: val,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            /*------------------ Bathrooms ----------------*/
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'No. Of Bathroom',
                    style: Palette.title2,
                  )),
                  Container(
                    child: DropdownButton(
                      underline: SizedBox(),
                      hint: Text(
                        'Nothing Selected',
                        style: Palette.subTitle,
                      ), // Not necessary for Option 1
                      value: _selectBathRoom,
                      onChanged: (newValue) {
                        setState(() {
                          _selectBathRoom = newValue;
                          _selectBathRoom == '1'
                              ? _bathRoomValue = '43'
                              : _selectBathRoom == '2'
                                  ? _bathRoomValue = '44'
                                  : _selectBathRoom == '3'
                                      ? _bathRoomValue = '45'
                                      : _selectBathRoom == '4'
                                          ? _bathRoomValue = '46'
                                          : _selectBathRoom == '5'
                                              ? _bathRoomValue = '47'
                                              : _selectBathRoom == '6'
                                                  ? _bathRoomValue = '128'
                                                  : _selectBathRoom == '7'
                                                      ? _bathRoomValue = '129'
                                                      : _selectBathRoom == '8'
                                                          ? _bathRoomValue =
                                                              '130'
                                                          : _selectBathRoom ==
                                                                  '9'
                                                              ? _bathRoomValue =
                                                                  '131'
                                                              : _selectBathRoom ==
                                                                      '10+'
                                                                  ? _bathRoomValue =
                                                                      '132'
                                                                  : _bathRoomValue =
                                                                      '';

                          print(_bathRoomValue);
                        });
                      },
                      items: _bathRoomDropDown.map((val) {
                        return DropdownMenuItem(
                          child: Text(val),
                          value: val,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            /*------------------ Balconies ----------------*/
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'No. Of Balconies',
                    style: Palette.title2,
                  )),
                  Container(
                    child: DropdownButton(
                      underline: SizedBox(),
                      hint: Text(
                        'Nothing Selected',
                        style: Palette.subTitle,
                      ), // Not necessary for Option 1
                      value: _selectedBalcony,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBalcony = newValue;
                          _selectedBalcony == '1'
                              ? _balconeyValue = '48'
                              : _selectBedRoom == '2'
                                  ? _balconeyValue = '49'
                                  : _selectBedRoom == '3+'
                                      ? _balconeyValue = '50'
                                      : _balconeyValue = '';

                          print(_balconeyValue);
                        });
                      },
                      items: _balconiesDropDown.map((val) {
                        return DropdownMenuItem(
                          child: Text(val),
                          value: val,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            /*------------------ Furnishing ----------------*/
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Furnishing',
                    style: Palette.title2,
                  )),
                  Container(
                    child: DropdownButton(
                      underline: SizedBox(),
                      hint: Text(
                        'Nothing Selected',
                        style: Palette.subTitle,
                      ), // Not necessary for Option 1
                      value: _selectFurnish,
                      onChanged: (newValue) {
                        setState(() {
                          _selectFurnish = newValue;
                          _selectFurnish == 'Furnished'
                              ? _furnishValue = '58'
                              : _selectFurnish == 'Semi - Furnished'
                                  ? _furnishValue = '59'
                                  : _selectFurnish == 'Unfurnished'
                                      ? _furnishValue = '60'
                                      : _furnishValue = '';

                          print(_furnishValue);
                        });
                      },
                      items: _furnishingDropDown.map((val) {
                        return DropdownMenuItem(
                          child: Text(val),
                          value: val,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            /*------------------ Facing ----------------*/
            Padding(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Facing',
                    style: Palette.title2,
                  )),
                  Container(
                    child: DropdownButton(
                      underline: SizedBox(),
                      hint: Text(
                        'Nothing Selected',
                        style: Palette.subTitle,
                      ), // Not necessary for Option 1
                      value: _selectFacing,
                      onChanged: (newValue) {
                        setState(() {
                          _selectFacing = newValue;
                          _selectFacing == 'East'
                              ? _facingValue = '73'
                              : _selectFacing == 'West'
                                  ? _facingValue = '74'
                                  : _selectFacing == 'North'
                                      ? _facingValue = '75'
                                      : _selectFacing == 'South'
                                          ? _facingValue = '76'
                                          : _selectFacing == 'North East'
                                              ? _facingValue = '77'
                                              : _selectFacing == 'South East'
                                                  ? _facingValue = '78'
                                                  : _selectFacing ==
                                                          'North West'
                                                      ? _facingValue = '79'
                                                      : _selectFacing ==
                                                              'South West'
                                                          ? _facingValue = '80'
                                                          : _facingValue = '';

                          print(_facingValue);
                        });
                      },
                      items: _facingDropDown.map((val) {
                        return DropdownMenuItem(
                          child: Text(val),
                          value: val,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveBtn() {
    return FloatingActionButton.extended(
      onPressed: () {
        _postData();
      }, //color
      backgroundColor: Palette.themeColor,
      //text
      label: Text('Save', style: Palette.textFieldWhite),
      //icon
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
    );
  }

  //get data api calling
  Future<void> _fetchData() async {
    final String url = "${Constants.ADDINOAL_INFO}&catid=1&subcatid=1";

    http.Response response = await http.post(url);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    setState(() {
      _radioData = decode['radio'];
    });

    debugPrint(response.body);
  }

  //post data api calling
  Future<void> _postData() async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    String onFloor = _onFloorController.text;
    String supArea = _supAreaController.text;
    String carpetArea = _carpetAreaController.text;
    String totalFloor = _totalFloorController.text;

    //url
    final String url =
        "${Constants.ADDINOAL_INFO_POST}&catid=$catId&subcatid=$subCatId&custom[26]=$_personalRadio&custom[40]=$_typeRadio&custom[48]=$_reraRadio&custom[41]=$_stageRadio&custom[36]=$_reservedRadio&custom[27]=$supArea&custom[28]=$carpetArea&custom[35]=$onFloor&custom[34]=$totalFloor&custom[29]=$_bedRoomValue&custom[30]=$_bathRoomValue&custom[31]=$_balconeyValue&custom[33]=$_furnishValue&custom[39]=$_facingValue";

    http.Response response = await http.post(url);

    //object response
    //Map<String, dynamic> decode = json.decode(response.body);
    setState(() {
      Navigator.pop(_keyLoader.currentContext);
      var _response2 = json.encode(response.body);
      _responseString = _response2
          .toString()
          .replaceAll(r'\', r'')
          .replaceAll("\"[", "[")
          .replaceAll("]\"", "]");
      print(_responseString);

      var _priceFrom = _priceRange.start.toInt().toString();
      var _priceTo;
      if (oneCrPrice == '10000000') {
        _priceTo = '10000000000';
      } else {
        _priceTo = _priceRange.end.toInt().toString();
      }

      //navigat
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CategoryProducts(catId, catName, subCatId,
      //             subCatName, _responseString, _priceFrom, _priceTo)));
    });
  }
}
