import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:http/http.dart' as http;
import 'package:phonepeproperty/widgets/error_dialouge.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLead extends StatefulWidget {
  @override
  _AddLeadState createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  List statusList = [];
  List sourceList = [];
  List propertyNameList = [];
  List propertyTypeList = [];
  List budget = [
    '5 Lac',
    '10 Lac',
    '15 Lac',
    '20 Lac',
    '25 Lac',
    '30 Lac',
    '35 Lac',
    '40 Lac',
    '45 Lac',
    '50 Lac',
    '55 Lac',
    '60 Lac',
    '65 Lac',
    '70 Lac',
    '75 Lac',
    '80 Lac',
    '85 Lac',
    '90 Lac',
    '95 Lac',
    '1 Cr'
  ];

  bool statusdropdownVisibility = true;
  bool sourcedropdownVisibility = true;
  bool pNamedropdownVisibility = true;
  bool pTypedropdownVisibility = true;

  bool statusVisibility = false;
  bool sourceVisibility = false;
  bool propertyNameVisibility = false;
  bool propertyTypeVisibility = false;

  bool statusOpen = true;
  bool statusClose =  false;

  bool sourceOpen = true;
  bool sourceClose = false;

  bool pNameOpen = true;
  bool pNameClose = false;

  bool pTypeOpen = true;
  bool pTypeClose = false;


  var _status = 'Select Status';
  var _statusId;

  var _source = 'Select Source';
  var _sourceId;

  var _propertyName = 'Select Property Name';
  var _propertyType = 'Select Property Type';

  var statusField = '';
  var sourceField;
  var propertyName;
  var propertyType;

  TextEditingController statusController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pNameController = TextEditingController();
  TextEditingController pAddressController = TextEditingController();
  TextEditingController pTypeController = TextEditingController();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyError = new GlobalKey<State>();

  var statusValue;
  var sourceValue;
  var propertyNameValue;
  var propertyTypeValue;
  var budgetValue;
  var fistName = '';
  var lastName = '';
  var clientRef = '';
  var phone = '';
  var email = '';
  var pAddress = '';

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
        title: Text('Add New Lead', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: _newLead(),
      ),
    );
  }

  Widget _newLead() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusDropdown(),
          SizedBox(
            height: 15.0,
          ),
          _sourceDropdown(),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'First Name',
                      style: Palette.textLeadStyle,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
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
                ],
              )),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Last Name',
                      style: Palette.textLeadStyle,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    elevation: 10.0,
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      style: Palette.textFieldBlack,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Enter Last Name',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Client Reference By',
                      style: Palette.textLeadStyle,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    elevation: 10.0,
                    child: TextField(
                      controller: refController,
                      keyboardType: TextInputType.name,
                      style: Palette.textFieldBlack,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Client Reference By',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                ],
              )),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Phone Number',
                      style: Palette.textLeadStyle,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    elevation: 10.0,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: Palette.textFieldBlack,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Enter Phone Number',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Email Addres',
              style: Palette.textLeadStyle,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            elevation: 10.0,
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: Palette.textFieldBlack,
              onChanged: (value) {},
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Enter your Email Addres',
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          _propertyNameDropdown(),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Property Address',
              style: Palette.textLeadStyle,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            elevation: 10.0,
            child: TextField(
              maxLines: 4,
              controller: pAddressController,
              keyboardType: TextInputType.name,
              style: Palette.textFieldBlack,
              onChanged: (value) {},
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Enter Property Address',
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Budget',
              style: Palette.textLeadStyle,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _budgetDropdown(),
          SizedBox(
            height: 15.0,
          ),
          _propertyTypeNameDropdown(),
          SizedBox(
            height: 20.0,
          ),
          _addButton(),
          // SizedBox(
          //   height: 15.0,
          // ),
        ],
      ),
    );
  }

  Widget _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Status',
            style: Palette.textLeadStyle,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            elevation: 10.0,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Visibility(
                        visible: statusdropdownVisibility,
                        child: InkWell(
                          onTap: () {
                            _statusBottomSheet();
                          },
                          child: Container(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                      child:  Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('$_status'),
                                      )
                                  ),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              )
                          ),
                        )
                      ),
                      Visibility(
                        visible: statusVisibility,
                        child: TextField(
                          controller: statusController,
                          keyboardType: TextInputType.name,
                          style: Palette.textFieldBlack,
                          onChanged: (value) {

                          },
                          decoration: InputDecoration(
                            enabledBorder:InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            hintText: 'Enter Status',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
               Column(
                 children: [
                  Visibility(
                    visible: statusOpen,
                    child:  IconButton(
                      onPressed: () {
                        setState(() {
                          statusdropdownVisibility = false;
                          statusVisibility = true;
                          statusClose = true;
                          statusOpen = false;
                          _statusId = 0;
                          _status = "Select status";

                        });
                      },
                      icon: Icon(Icons.add)),),
                   Visibility(
                     visible: statusClose,
                       child: IconButton(
                           onPressed: () {
                             setState(() {
                               statusdropdownVisibility = true;
                               statusVisibility = false;
                               statusClose = false;
                               statusOpen = true;
                               statusField = "";

                             });
                           },
                           icon: Icon(Icons.check_outlined ))
                   )
                 ],
               )
              ],
            )
        )
      ],
    );
  }

  Widget _sourceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Source',
            style: Palette.textLeadStyle,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            elevation: 10.0,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: sourcedropdownVisibility,
                          child: InkWell(
                            onTap: () {
                              _sourceBottomSheet();
                            },
                            child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:  Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('$_source'),
                                        )
                                    ),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                )
                            ),
                          )
                        ),
                        Visibility(
                          visible: sourceVisibility,
                          child: TextField(
                            controller: sourceController,
                            keyboardType: TextInputType.name,
                            style: Palette.textFieldBlack,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder:InputBorder.none,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              hintText: 'Enter Source',
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          ),
                        )
                      ],
                    )),
                Column(
                  children: [
                    Visibility(
                      visible: sourceOpen,
                      child:  IconButton(
                          onPressed: () {
                            setState(() {
                              sourcedropdownVisibility = false;
                              sourceVisibility = true;
                              sourceClose = true;
                              sourceOpen = false;
                              _sourceId = 0;
                              sourceField = "Select source";

                            });
                          },
                          icon: Icon(Icons.add)),),
                    Visibility(
                        visible: sourceClose,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                sourcedropdownVisibility = true;
                                sourceVisibility = false;
                                sourceClose = false;
                                sourceOpen = true;
                                sourceField = "";
                              });
                            },
                            icon: Icon(Icons.check_outlined ))
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget _propertyNameDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Property Name',
            style: Palette.textLeadStyle,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            elevation: 10.0,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: pNamedropdownVisibility,
                          child: InkWell(
                            onTap: () {
                              _propertyNameBottomSheet();
                            },
                            child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:  Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('$_propertyName'),
                                        )
                                    ),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                )
                            ),
                          )
                        ),
                        Visibility(
                          visible: propertyNameVisibility,
                          child: TextField(
                            controller: pNameController,
                            keyboardType: TextInputType.name,
                            style: Palette.textFieldBlack,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              hintText: 'Enter Property Name',
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          ),
                        )
                      ],
                    )),
                Column(
                  children: [
                    Visibility(
                      visible: pNameOpen,
                      child:  IconButton(
                          onPressed: () {
                            setState(() {
                              pNamedropdownVisibility = false;
                              propertyNameVisibility = true;
                              pNameClose = true;
                              pNameOpen = false;
                              _propertyName = "Select Property name";

                            });
                          },
                          icon: Icon(Icons.add)),),
                    Visibility(
                        visible: pNameClose,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                pNamedropdownVisibility = true;
                                propertyNameVisibility = false;
                                pNameClose = false;
                                pNameOpen = true;
                                propertyName = "";
                              });
                            },
                            icon: Icon(Icons.check_outlined ))
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget _propertyTypeNameDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Interested In Property Type',
            style: Palette.textLeadStyle,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            elevation: 10.0,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: pTypedropdownVisibility,
                          child: InkWell(
                            onTap: () {
                              _propertyTypeBottomSheet();
                            },
                            child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:  Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text('$_propertyType'),
                                        )
                                    ),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                )
                            ),
                          )
                        ),
                        Visibility(
                          visible: propertyTypeVisibility,
                          child: TextField(
                            controller: pTypeController,
                            keyboardType: TextInputType.name,
                            style: Palette.textFieldBlack,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              hintText: 'Enter Property Type',
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          ),
                        )
                      ],
                    )),
                Column(
                  children: [
                    Visibility(
                      visible: pTypeOpen,
                      child:  IconButton(
                          onPressed: () {
                            setState(() {
                              pTypedropdownVisibility = false;
                              propertyTypeVisibility = true;
                              pTypeClose = true;
                              pTypeOpen = false;
                              _propertyType = "Select Property type";

                            });
                          },
                          icon: Icon(Icons.add)),),
                    Visibility(
                        visible: pTypeClose,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                pTypedropdownVisibility = true;
                                propertyTypeVisibility = false;
                                pTypeClose = false;
                                pTypeOpen = true;
                                propertyType = "";
                              });
                            },
                            icon: Icon(Icons.check_outlined ))
                    )
                  ],
                ),

              ],
            ))
      ],
    );
  }

  Widget _budgetDropdown() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      elevation: 10.0,
      child: Container(
        height: 50,
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
          value: budgetValue,
          hint: Text('Select Budget'),
          items: budget.map((item) {
            return new DropdownMenuItem(
              child: new Text(item),
              value: item,
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
              budgetValue = newValue;
              print('budgetValue:::::::$budgetValue');
            });
          },
        ),
      ),
    );
  }

  Widget _addButton() {
    return Center(
      child: InkWell(
        onTap: () {
          //TODO api call
           statusField = statusController.text;
           sourceField = sourceController.text;
          fistName = firstNameController.text;
          lastName = lastNameController.text;
          clientRef = refController.text;
          phone = phoneController.text;
          email = emailController.text;
           propertyName = pNameController.text;
           propertyType = pTypeController.text;
          pAddress = pAddressController.text;
           var statusTotal;
           var sourceTotal;
           var pNameTotal;
           var pTypeTotal;

           //Status
           if(_statusId == 0 && statusField != '')
             {
               statusTotal = statusField;
             }
           else
             {
               statusTotal = _statusId;
             }

           //Source
           if(_sourceId == 0 && sourceField != "")
             {
               sourceTotal = sourceField;
             }
           else
             {
               sourceTotal = _sourceId;
             }

           //Property Name
           if(_propertyName == "" && propertyName != "")
             {
               pNameTotal = propertyName;
             }
           else
             {
               pNameTotal = _propertyName;
             }
           print('pNameTotal:::::::$pNameTotal');


           //Property Type
           if(_propertyType == "" && propertyType != "")
           {
             pTypeTotal = propertyType;
           }
           else
           {
             pTypeTotal = _propertyType;
           }



          LoadingDialog.showLoadingDialog(context, _keyLoader);
          addLead(statusTotal, sourceTotal, fistName, lastName, clientRef, phone, email, pNameTotal, pAddress, budgetValue, pTypeTotal);
        },
        child: Container(
          width: 200,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: cDarkBlue,
          ),
          child: Center(
            child: Text('Save',style: Palette.addButton,),
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
        propertyNameList = items['property_name'];
        propertyTypeList = items['property_type'];
        print('statusList::::::::::::::$statusList');
        print('sourceList::::::::::::::$sourceList');
        print('propertyNameList::::::::::::::$propertyNameList');
        print('propertyTypeList::::::::::::::$propertyTypeList');
      });
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  void _statusBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        useRootNavigator: true,
        builder: (builder) {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:  Row(
                        children: [
                          Expanded(
                            child: Text('Select Status'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.only(right: 15.0, left: 15.0),
                        itemCount: statusList.isNotEmpty || statusList != null
                            ? statusList.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {

                          var status = statusList[index]['name'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                _status = statusList[index]['name'];
                                _statusId = statusList[index]['id'].toString();
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    //border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child:  Text('$status',),
                                )
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  void _sourceBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        useRootNavigator: true,
        builder: (builder) {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:  Row(
                        children: [
                          Expanded(
                            child: Text('Select Source'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.only(right: 15.0, left: 15.0),
                        itemCount: sourceList.isNotEmpty || sourceList != null
                            ? sourceList.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {

                          var source = sourceList[index]['name'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                _source = sourceList[index]['name'];
                                _sourceId = sourceList[index]['id'].toString();

                                print('id::::::$_sourceId');
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    //border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child:  Text('$source',),
                                )
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  void _propertyNameBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        useRootNavigator: true,
        builder: (builder) {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:  Row(
                        children: [
                          Expanded(
                            child: Text('Select Property Name'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.only(right: 15.0, left: 15.0),
                        itemCount: propertyNameList.isNotEmpty || propertyNameList != null
                            ? propertyNameList.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {

                          var name = propertyNameList[index]['property_name'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                _propertyName = propertyNameList[index]['property_name'];

                                print('id::::::$_propertyName');
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    //border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child:  Text('$name',),
                                )
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  void _propertyTypeBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        context: context,
        useRootNavigator: true,
        builder: (builder) {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:  Row(
                        children: [
                          Expanded(
                            child: Text('Select Property Type'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.only(right: 15.0, left: 15.0),
                        itemCount: propertyTypeList.isNotEmpty || propertyTypeList != null
                            ? propertyTypeList.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {

                          var name = propertyTypeList[index]['property_type'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                                _propertyType = propertyTypeList[index]['property_type'];
                                print('id::::::$_propertyType');
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    //border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child:  Text('$name',),
                                )
                            ),
                          );
                        }
                    ),
                  ],
                )
            ),
          );
        }
    );
  }


  addLead(var status,var source,String fName,String lName,String ref,String phone,String email,String pName,String pAdd,String budget,String pType) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.getString('userid');
    String token = pref.getString('token');
    String url = Constants.ADD_LEAD;

    var requestBody = {
      'user_id': userid,
      'status_id': status,
      'source_id': source,
      'first_name': fName,
      'last_name': lName,
      'email': email,
      'phonre_number': phone,
      'property_name': pName,
      'property_location': pAdd,
      'budget': budget,
      'property_type': pType,
      'client_reference_by': ref,
    };

    var response = await http.post(
      url,
      body: requestBody,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if(items['status'] == 'success')
        {
          Navigator.pop(context);
        }
      else
        {
          ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
        }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }
}
