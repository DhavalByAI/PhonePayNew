import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/model/DropdownModel.dart';
import 'package:phonepeproperty/screens/AddProducts/AddProductSTwo.dart';
import 'dart:convert';

import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';

class DynamicAdditionalInfo extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final String subCatId;
  final String subCatName;
  final String adTitle;
  final String price;
  final String mobileNo;
  final String desc;
  final List images;
  final String stateCode;
  final String stateName;
  final String cityCode;
  final String cityName;
  final String localityCode;
  final String localityName;
  final double latitudeValue;
  final double longitudeValue;
  final String address;

  DynamicAdditionalInfo(
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
    this.latitudeValue,
    this.longitudeValue,
    this.address,
  );

  @override
  _DynamicAdditionalInfoState createState() => _DynamicAdditionalInfoState(
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
        this.latitudeValue,
        this.longitudeValue,
        this.address,
      );
}

class _DynamicAdditionalInfoState extends State<DynamicAdditionalInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String categoryId;
  String categoryName;
  String categoryImg;
  String subCatId;
  String subCatName;
  String adTitle;
  String price;
  String mobileNo;
  String desc;
  List images;
  String stateCode;
  String stateName;
  String cityCode;
  String cityName;
  String localityCode;
  String localityName;
  double latitudeValue;
  double longitudeValue;
  String address;

  _DynamicAdditionalInfoState(
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
    this.latitudeValue,
    this.longitudeValue,
    this.address,
  );

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

  String _postedImgs;
  List addImagesRepsone = [];
  String _itemScreen;

  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isError = false;
    // if (images.length != 0) {
    //   print('Image of Ads uploading..!');
    //   print('upload image lenght : ${images.length}');
    //   isWaiting = true;
    //   for (var i = 0; i < images.length; i++) {
    //     _postedImgs = images[i];
    //     _postImgApi(_postedImgs);
    //   }
    // }
    _fetchCustomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('Addition Info', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
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
              activeColor: cDarkBlue,
              contentPadding: EdgeInsets.zero,
              title: Text("$_radioBtnSubTitle", style: Palette.title2),
              value: index,
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
                activeColor: cDarkBlue,
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

        // if (!isWaiting) {
        //   sendCustomFieldApi(_finalDoneList);
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('Image is uploading please wait a seconds :)'),
        //     duration: Duration(seconds: 3),
        //   ));
        // }
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
      "catid": categoryId,
      "subcatid": subCatId,
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

  /*--------------- Send Image Api Calling -------------*/
  _postImgApi(String _postedImages) async {
    //LoadingDialog.showLoadingDialog(context, _keyLoader);
    //_waitBtn = true;

    final String url = "${Constants.POST_IMG}";

    var request = http.MultipartRequest("POST", Uri.parse(url));

    if (images == null) {
      images = null;
    } else {
      var _postImgs =
          await http.MultipartFile.fromPath("fileToUpload", _postedImages);
      request.files.add(_postImgs);
    }

    var response = await request.send();
    print(response.statusCode);

    //listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Map<String, dynamic> decode = json.decode(value);
      setState(() {
        var responseMsg = decode['status'];
        var responseImg = decode['picture'];
        print(responseImg);

        if (response.statusCode == 200) {
          addImagesRepsone.add(responseImg);
          print('repsone Imgs == $addImagesRepsone');

          _itemScreen = addImagesRepsone
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '');

          if (images.length == addImagesRepsone.length) {
            print('ready to send img == $_itemScreen');
            isWaiting = false;
          } else {
            isWaiting = true;
            print('images not send, Please try again..!');
          }
        }
        //error in api
        else if (response.statusCode != 200) {
          Navigator.pop(_keyLoader.currentContext);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$responseMsg'),
            duration: Duration(seconds: 3),
          ));
        }
      });
    });
  }

  Future<void> sendCustomFieldApi(List allSelectedValueList) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);
    final String url =
        "${Constants.ADDINOAL_INFO_POST}?catid=$categoryId&subcatid=$subCatId";

    var _modifiedList =
        allSelectedValueList.toString().replaceAll('{', '').replaceAll('}', '');

    var _removeList = _modifiedList.substring(1, _modifiedList.length - 1);
    var _jsonList = "{$_removeList}";

    var reqBody = json.decode(_jsonList) as Map;

    http.Response response = await http.post(url, body: reqBody);
    var decodeRes = json.decode(response.body);
    var additionalInfoRes = response.body;
    setState(() {
      Navigator.pop(_keyLoader.currentContext);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddProductSTwo(
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
                    cityCode,
                    cityName,
                    localityCode,
                    localityName,
                    latitudeValue,
                    longitudeValue,
                    address,
                    additionalInfoRes.toString(),
                    _itemScreen,
                  )),
        );
      }
    });
    print(decodeRes);
  }
}
