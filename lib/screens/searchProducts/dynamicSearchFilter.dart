import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/model/DropdownModel.dart';
import 'package:phonepeproperty/screens/searchProducts/categoryProducts.dart';
import 'package:phonepeproperty/screens/searchProducts/location/serachSelectState.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/widgets/NumberFormatter.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';

class DynamicSearchFilter extends StatefulWidget {
  final String catId;
  final String catName;
  final String subCatId;
  final String subCatName;
  final String additionalInfo;
  final String priceFrom;
  final String priceTo;
  final String stateId;
  final String stateName;
  final String cityId;
  final String cityName;
  final String localityId;
  final String localityName;

  DynamicSearchFilter({
    this.catId,
    this.catName,
    this.subCatId,
    this.subCatName,
    this.additionalInfo,
    this.priceFrom,
    this.priceTo,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.localityId,
    this.localityName,
  });

  @override
  _DynamicSearchFilterState createState() => _DynamicSearchFilterState();
}

class _DynamicSearchFilterState extends State<DynamicSearchFilter> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  int value;

  /*------------------ price ----------------*/
  RangeValues _priceRange = RangeValues(10000, 2000000);
  String oneCrPrice;

  bool _isLoading;
  bool _isError;
  List _radioList = [];
  List _selectedRadioList = [];

  List _checkboxList = [];
  List _selectedCheckBoxList = [];

  List _dropdownList = [];
  List _selectedDropdownList = [];

  var _editTextList;
  List _selectedEditTextList = [];

  List _finalDoneList = [];

  bool _locationVisisble = false;

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    _isError = false;
    widget.stateName != ''
        ? _locationVisisble = true
        : _locationVisisble = false;
    _fetchCustomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('Addition Info', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      /*------------------ body ----------------*/
      body: !_isLoading
          ? SingleChildScrollView(
              /*------------------ Main Listview ----------------*/
              child: Column(
                children: <Widget>[
                  _priceRangeWidget(),
                  _location(),
                  _radioList.length != 0 ? _radioWidget() : Container(),
                  _editTextList != null ? _editTextWidget() : Container(),
                  _dropdownList.length != 0 ? _dropdownWidget() : Container(),
                  _checkboxList.length != 0 ? _checkboxWidget() : Container(),
                  _doneBtnWidget(),
                  SizedBox(height: 30.0),
                ],
              ),
            )
          : _isError
              ? Center(
                  child: Text(
                    'Service unavailble, Please try again later..!',
                    style: Palette.title,
                  ),
                )
              : Center(child: CircularProgressIndicator()),
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
                  activeColor: cDarkBlue,
                  inactiveColor: Colors.grey,
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

  Widget _location() {
    var _priceFrom = _priceRange.start.toInt().toString();
    var _priceTo;
    if (oneCrPrice == '10000000') {
      _priceTo = '10000000000';
    } else {
      _priceTo = _priceRange.end.toInt().toString();
    }

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 12.0,
        shadowColor: Colors.black26,
        shape: Palette.topCardShape,
        child: Column(
          children: [
            ListTile(
              title: Text('Location Area', style: Palette.title2),
              trailing: Icon(Icons.arrow_forward_ios, size: 20.0),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchSelectState(
                    catId: widget.catId,
                    subCatId: widget.subCatId,
                    catName: widget.catName,
                    subCatName: widget.subCatName,
                    additionalInfo: widget.additionalInfo,
                    priceFrom: _priceFrom,
                    priceTo: _priceTo,
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _locationVisisble,
                child: Column(
                  children: [
                    Divider(height: 5.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 30.0, child: Icon(Icons.my_location)),
                          SizedBox(width: 10.0),
                          Container(
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white24,
                              shape: Palette.cardShape,
                              child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  child: Text('${widget.stateName}',
                                      style: Palette.subTitleBold)),
                            ),
                          ),
                          Text(' > ', style: Palette.title),
                          Expanded(
                            child: Card(
                              elevation: 0.0,
                              color: Colors.white24,
                              shape: Palette.cardShape,
                              child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  child: Text('${widget.cityName}',
                                      style: Palette.subTitleBold)),
                            ),
                          ),
                          widget.localityName != ''
                              ? Expanded(
                                  child: Card(
                                    elevation: 0.0,
                                    color: Colors.blueGrey[50],
                                    shape: Palette.cardShape,
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 5.0, 10.0, 5.0),
                                        child: Text('${widget.localityName}',
                                            style: Palette.subTitleBold)),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _radioWidget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Card(
        elevation: 8.0,
        shape: Palette.topCardShape,
        child: _radioListWidget(),
      ),
    );
  }

  Widget _editTextWidget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Card(
        elevation: 8.0,
        shape: Palette.topCardShape,
        child: _editTextListWidget(),
      ),
    );
  }

  Widget _dropdownWidget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Card(
        elevation: 8.0,
        shape: Palette.topCardShape,
        child: _dropdownListWidget(),
      ),
    );
  }

  Widget _checkboxWidget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Card(
        elevation: 8.0,
        shape: Palette.topCardShape,
        child: _checkboxListWidget(),
      ),
    );
  }

  //
  /*------------------ Radio Buttons ----------------*/
  Widget _radioListWidget() {
    return ListView.builder(
      padding: Palette.fiveMargin * 2,
      shrinkWrap: true,
      primary: false,
      itemCount: _radioList.length,
      itemBuilder: (BuildContext context, int index) {
        String _radioBtnName = _radioList[index]['title'];
        List _radioBtnSubList = _radioList[index]['name'];

        return Container(
          margin: Palette.standardMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$_radioBtnName', style: Palette.themeBtnText),
              _radioBtnSubFieldListViewWidget(_radioBtnSubList),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  //
  /*------------------ Edit text ----------------*/
  Widget _editTextListWidget() {
    return ListView.builder(
      padding: Palette.fiveMargin * 2,
      shrinkWrap: true,
      primary: false,
      itemCount: _editTextList.length,
      itemBuilder: (BuildContext context, int index) {
        var keys = _editTextList.keys.toList();
        String _editTextIndex = keys[index];
        String _editTextTitle = _editTextList[_editTextIndex]['title'];
        String _editTextName = _editTextList[_editTextIndex]['name']['name'];

        return Container(
          margin: Palette.standardMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$_editTextTitle', style: Palette.themeBtnText),
              _editTextSubFieldWidget(_editTextTitle, _editTextName),
              SizedBox(height: 5.0),
            ],
          ),
        );
      },
    );
  }

  //
  /*------------------ Radio Buttons ----------------*/
  Widget _dropdownListWidget() {
    return ListView.builder(
      padding: Palette.fiveMargin * 2,
      shrinkWrap: true,
      primary: false,
      itemCount: _dropdownList.length,
      itemBuilder: (BuildContext context, int index) {
        String _dropdownTitle = _dropdownList[index]['title'];
        String _dropdownName = _dropdownList[index]['name']['name'];
        List _dropdownSubList = _dropdownList[index]['name']['value'];

        return Container(
          margin: Palette.standardMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$_dropdownTitle', style: Palette.themeBtnText),
              _dropdownSubFieldListViewWidget(_dropdownName, _dropdownSubList),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  //
  /*------------------ Checkboxes ----------------*/
  Widget _checkboxListWidget() {
    return ListView.builder(
      padding: Palette.fiveMargin * 2,
      shrinkWrap: true,
      primary: false,
      itemCount: _checkboxList.length,
      itemBuilder: (BuildContext context, int index) {
        String _checkboxName = _checkboxList[index]['title'];
        List _checkboxSubList = _checkboxList[index]['name'];

        return Container(
          margin: Palette.standardMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$_checkboxName', style: Palette.themeBtnText),
              _checkboxSubFieldListViewWidget(_checkboxSubList),
              SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  //
  /*------------------ Radio Buttons Listing Logic ----------------*/
  Widget _radioBtnSubFieldListViewWidget(List radioBtnList) {
    int _group;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: radioBtnList.length,
        itemBuilder: (BuildContext context, int index) {
          String _radioBtnSubTitle = radioBtnList[index]['title'];
          String _radioBtnSubName = radioBtnList[index]['name'];
          String _radioBtnSubValue = radioBtnList[index]['value'];

          return SizedBox(
            height: 35.0,
            child: RadioListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("$_radioBtnSubTitle", style: Palette.title2),
              value: index,
              activeColor: cDarkBlue,
              groupValue: _group,
              onChanged: (val) {
                setState(() {
                  _group = val;

                  var selectedObject =
                      {_radioBtnSubName: '"$_radioBtnSubValue"'}.toString();

                  List<String> _splitSelectedObj = selectedObject.split(":");
                  String _finalSelectedObj =
                      _splitSelectedObj[0].replaceAll('{', '');

                  if (_selectedRadioList.length == 0) {
                    _selectedRadioList.add(selectedObject);
                  } else {
                    for (var i = 0; i < _selectedRadioList.length; i++) {
                      if (_selectedRadioList[i].contains(_finalSelectedObj)) {
                        _selectedRadioList.remove(_selectedRadioList[i]);
                        _selectedRadioList.removeWhere((item) {
                          return item == selectedObject;
                        });
                        _selectedRadioList.add(selectedObject);
                      } else {
                        _selectedRadioList.removeWhere((item) {
                          return item == selectedObject;
                        });
                        _selectedRadioList.add(selectedObject);
                      }
                    }
                  }
                });
              },
            ),
          );
        },
      );
    });
  }

  //
  /*---------------------- EditText logic ---------------------*/
  Widget _editTextSubFieldWidget(String etTitle, String etName) {
    TextEditingController _valueController = TextEditingController();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextField(
          controller: _valueController,
          keyboardType: TextInputType.name,
          style: Palette.textField,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            isDense: true,
          ),
          onChanged: (value) {
            setState(() {
              String _selectedObj =
                  {etName: '"${_valueController.text}"'}.toString();
              List<String> _splitSelectedObj = _selectedObj.split(":");
              String _finalObj = _splitSelectedObj[0].replaceAll('{', '');

              if (_selectedEditTextList.length == 0) {
                _selectedEditTextList.add(_selectedObj);
              } else {
                for (var i = 0; i < _selectedEditTextList.length; i++) {
                  if (_selectedEditTextList[i].contains(_finalObj)) {
                    _selectedEditTextList.remove(_selectedEditTextList[i]);
                    _selectedEditTextList.removeWhere((item) {
                      return item == _selectedObj;
                    });
                    if (_valueController.text.length != 0) {
                      _selectedEditTextList.add(_selectedObj);
                    }
                  } else {
                    _selectedEditTextList.add(_selectedObj);
                  }
                }
              }
            });
          },
        );
      },
    );
  }

  //
  /*------------------ Dropdown  Logic ----------------*/
  Widget _dropdownSubFieldListViewWidget(
      String _dropdownName, List dropdownSubList) {
    List<DropdownModel> _makedropdownObjList = [];

    for (var i = 0; i < dropdownSubList.length; i++) {
      String _name = dropdownSubList[i]['name'];
      String _value = dropdownSubList[i]['value'];
      _makedropdownObjList.add(new DropdownModel(_name, _value));
    }

    DropdownModel _selectedDropdownModelValue;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return DropdownButton<DropdownModel>(
        value: _selectedDropdownModelValue,
        items: _makedropdownObjList
            .map((DropdownModel _makedropdownObjList) =>
                DropdownMenuItem<DropdownModel>(
                  child: Text(_makedropdownObjList.name),
                  value: _makedropdownObjList,
                ))
            .toList(),
        onChanged: (DropdownModel newValue) {
          setState(() {
            _selectedDropdownModelValue = newValue;

            String _selectedObj = {
              _dropdownName: '"${_selectedDropdownModelValue.value}"'
            }.toString();

            List<String> _splitSelectedObj = _selectedObj.split(":");
            String _finalObj = _splitSelectedObj[0].replaceAll('{', '');

            if (_selectedDropdownList.length == 0) {
              _selectedDropdownList.add(_selectedObj);
            } else {
              for (var i = 0; i < _selectedDropdownList.length; i++) {
                if (_selectedDropdownList[i].contains(_finalObj)) {
                  _selectedDropdownList.remove(_selectedDropdownList[i]);
                  _selectedDropdownList.removeWhere((item) {
                    return item == _selectedObj;
                  });
                  _selectedDropdownList.add(_selectedObj);
                } else {
                  _selectedDropdownList.add(_selectedObj);
                }
              }
            }
          });
        },
      );
    });
  }

  //
  /*------------------ Checkbox Listing Logic ----------------*/
  Widget _checkboxSubFieldListViewWidget(List checkboxList) {
    List<bool> checkboxInput = <bool>[];
    List _selectedValueList = [];

    List _newCheckboxSubList = [];
    for (var i = 0; i < checkboxList.length; i++) {
      _newCheckboxSubList.add(checkboxList[i]['value']);
      checkboxInput.add(false);
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: checkboxList.length,
          itemBuilder: (BuildContext context, int index) {
            String _checkboxSubTitle = checkboxList[index]['title'];
            String _checkboxSubName = checkboxList[index]['name'];
            String _checkboxSubValue = checkboxList[index]['value'];

            return SizedBox(
              height: 35.0,
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('$_checkboxSubTitle', style: Palette.title2),
                value: checkboxInput[index],
                onChanged: (bool newValue) {
                  setState(() {
                    checkboxInput[index] = newValue;

                    var selectedObject =
                        {_checkboxSubName: _checkboxSubValue}.toString();

                    List<String> _spitSelectedObj = selectedObject.split(":");
                    String _finalSelectedObj =
                        _spitSelectedObj[0].replaceAll('{', '');

                    if (_selectedCheckBoxList.length == 0) {
                      var _firstCheckbox =
                          {_checkboxSubName: '"$_checkboxSubValue"'}.toString();
                      _selectedCheckBoxList.add(_firstCheckbox);
                    } else {
                      //on checkbox selected
                      if (newValue) {
                        for (var i = 0; i < _selectedCheckBoxList.length; i++) {
                          if (_selectedCheckBoxList[i]
                              .contains(_finalSelectedObj)) {
                            String _modifiedObj = _selectedCheckBoxList[i];
                            String _valueOfObjects =
                                _modifiedObj.split(": ")[1].replaceAll('}', '');
                            List _valueList = [];

                            if (_valueOfObjects != _checkboxSubValue) {
                              _valueList.add(_valueOfObjects);
                              _valueList.add(_checkboxSubValue);
                            } else {
                              _valueList.add(_checkboxSubValue);
                            }

                            _selectedCheckBoxList
                                .remove(_selectedCheckBoxList[i]);
                            _selectedCheckBoxList.removeWhere((item) {
                              return item == selectedObject;
                            });

                            String _finalValue = _valueList
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .replaceAll('"', '');

                            var _newSelectedObj =
                                {_checkboxSubName: '"$_finalValue"'}.toString();
                            _selectedCheckBoxList.add(_newSelectedObj);
                          } else {
                            _selectedCheckBoxList.add(selectedObject);
                          }
                        }
                      }
                      //on checkbox un-selected
                      else {
                        newValue = false;
                        // for (var i = 0; i < checkboxList.length; i++) {
                        //   checkboxInput.add(false);
                        // }
                        List _valuelist = [];

                        for (var i = 0; i < _selectedCheckBoxList.length; i++) {
                          String _modifiedObj = _selectedCheckBoxList[i];
                          String _valueOfObjects = _modifiedObj
                              .split(": ")[1]
                              .replaceAll('}', '')
                              .replaceAll('"', '');
                          _valuelist = _valueOfObjects.split(", ");

                          if (_valuelist.contains(_checkboxSubValue)) {
                            //_valuelist.remove(_valuelist[i]);
                            _valuelist.removeWhere((item) {
                              return item == _checkboxSubValue;
                            });
                          }
                          _selectedCheckBoxList
                              .remove(_selectedCheckBoxList[i]);
                          _selectedCheckBoxList.removeWhere((item) {
                            return item == selectedObject;
                          });

                          String _finalValue = _valuelist
                              .toString()
                              .replaceAll('[', '')
                              .replaceAll(']', '')
                              .replaceAll('"', '');

                          var _newSelectedObj =
                              {_checkboxSubName: '"$_finalValue"'}.toString();
                          if (_valuelist.length != 0) {
                            _selectedCheckBoxList.add(_newSelectedObj);
                          }
                        }
                      }
                    }
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _doneBtnWidget() {
    return MaterialButton(
      onPressed: () {
        if (_selectedRadioList.length != 0) {
          _finalDoneList.addAll(_selectedRadioList);
        }
        if (_selectedEditTextList.length != 0) {
          _finalDoneList.addAll(_selectedEditTextList);
        }
        if (_selectedDropdownList.length != 0) {
          _finalDoneList.addAll(_selectedDropdownList);
        }
        if (_selectedCheckBoxList.length != 0) {
          _finalDoneList.addAll(_selectedCheckBoxList);
        }
        sendCustomFieldApi(_finalDoneList);
      },
      color: cDarkBlue,
      shape: Palette.buttonShape,
      elevation: 8.0,
      minWidth: 120.0,
      height: 40.0,
      child: Text('Done', style: Palette.whiteBtnText),
    );
  }

  Future<void> _fetchCustomData() async {
    final String url = Constants.ADDINOAL_INFO;

    var req = {
      "catid": widget.catId,
      "subcatid": widget.subCatId,
      "additionalinfo": widget.additionalInfo,
    };

    http.Response response = await http.post(url, body: req);

    //object response
    Map<String, dynamic> decode = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _radioList = decode['radio'];
        _editTextList = decode['textfield'];
        _checkboxList = decode['checkboxes'];
        _dropdownList = decode['dropdown'];
      });
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  Future<void> sendCustomFieldApi(List allSelectedValueList) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    var _priceFrom = _priceRange.start.toInt().toString();
    var _priceTo;
    if (oneCrPrice == '10000000') {
      _priceTo = '10000000000';
    } else {
      _priceTo = _priceRange.end.toInt().toString();
    }

    final String url = Constants.ADDINOAL_INFO_POST;

    var _modifiedList =
        allSelectedValueList.toString().replaceAll('{', '').replaceAll('}', '');

    var _removeList = _modifiedList.substring(1, _modifiedList.length - 1);
    var _jsonList = "{$_removeList}";

    var reqBody = json.decode(_jsonList) as Map;

    http.Response response = await http.post(url, body: reqBody);
    //var decodeRes = json.decode(response.body);
    var additionalInfoRes = response.body;
    print(additionalInfoRes);
    setState(() {
      Navigator.pop(_keyLoader.currentContext);

      if (response.statusCode == 200) {
        //navigat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProducts(
              catId: widget.catId,
              catName: widget.catName,
              subCatId: widget.subCatId,
              subCatName: widget.subCatName,
              additionalInfo: additionalInfoRes,
              priceFrom: _priceFrom,
              priceTo: _priceTo,
              stateId: widget.stateId,
              stateName: widget.stateName,
              cityId: widget.cityId,
              cityName: widget.cityName,
              localityId: widget.localityId,
              localityName: widget.localityName,
            ),
          ),
        );
      }
    });
  }
}
