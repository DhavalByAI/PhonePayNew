import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/crm/leadDetails/activitylogs.dart';
import 'package:phonepeproperty/screens/crm/leadDetails/adddocument.dart';
import 'package:phonepeproperty/screens/crm/leadDetails/addreminder.dart';
import 'package:phonepeproperty/screens/crm/leadDetails/notes.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/error_dialouge.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class LeadDetails extends StatefulWidget {
  var leadId;

  LeadDetails({this.leadId});

  @override
  _LeadDetailsState createState() => _LeadDetailsState();
}

class _LeadDetailsState extends State<LeadDetails> {
  var notesList = [];
  var logList = [];
  var reminderList = [];
  var docList = [];
  var firstName;

  bool isLoading = true;

  DateTime selectedDate = DateTime.now();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyError = new GlobalKey<State>();

  TextEditingController notesController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLeadDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawerEdgeDragWidth: 0.0,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          //brightness: Brightness.dark,
          backgroundColor: cDarkBlue,
          title: Text('Lead Details', style: Palette.tabTitle),
          centerTitle: true,
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('Notes', style: Palette.productTitle)),
                Tab(child: Text('Activity Logs', style: Palette.productTitle)),
                Tab(child: Text('Reminder', style: Palette.productTitle)),
                Tab(child: Text('Document', style: Palette.productTitle)),
              ],
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        body: TabBarView(
          children: [
            noteList(),
            activityLogList(),
            reminder_List(),
            documentList()
          ],
        ),
      ),
    );
  }

  fetchLeadDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    String url = Constants.LEAD_DETAILS;

    var requestBody = {
      'lead_id': "${widget.leadId}",
    };

    var response = await http.post(
      url,
      body: requestBody,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (response.statusCode == 200) {
      //isLoading =  false;
      var items = json.decode(response.body);
      setState(() {
        isLoading = false;
        notesList = items['notes'];
        logList = items['activity_logs'];
        reminderList = items['lead_reminders'];
        docList = items['document'];
        firstName = items['lead']['first_name'];

        print('notesList::::::::$notesList');
        print('logList::::::::$logList');
        print('reminderList::::::::$reminderList');
        print('docList::::::::$docList');
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<Widget> addNoteApi(String note) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String user_id = _pref.get('userid');
    String url = Constants.ADD_LEAD_BY_TYPE;

    var req = {
      'type': 'notes',
      'text': note,
      'lead_id': "${widget.leadId}",
      'user_id': user_id,
    };

    var response = await http.post(
      url,
      body: req,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if (items['status'] == 'success') {
        fetchLeadDetails();
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  Future<Widget> addActivityApi(String activity) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String user_id = _pref.get('userid');
    String url = Constants.ADD_LEAD_BY_TYPE;

    var req = {
      'type': 'activity',
      'text': activity,
      'lead_id': "${widget.leadId}",
      'user_id': user_id,
    };

    var response = await http.post(
      url,
      body: req,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if (items['status'] == 'success') {
        fetchLeadDetails();
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  Future<Widget> addReminderApi(String description, String date) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String user_id = _pref.get('userid');
    String url = Constants.ADD_LEAD_BY_TYPE;

    var req = {
      'type': 'reminder',
      'text': description,
      'lead_id': "${widget.leadId}",
      'user_id': user_id,
      'date_notified': date,
    };

    var response = await http.post(
      url,
      body: req,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if (items['status'] == 'success') {
        fetchLeadDetails();
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  Future<Widget> noteUpdateApi(String note, int id) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String user_id = _pref.get('userid');
    String url = Constants.UPDATE_LEAD_BY_TYPE;

    var req = {
      'type': 'notes',
      'id': '$id',
      'lead_id': "${widget.leadId}",
      'user_id': user_id,
      'text': note,
    };

    var response = await http.post(
      url,
      body: req,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if (items['status'] == 'success') {
        fetchLeadDetails();
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  Future<Widget> reminderUpdateApi(String description, int id) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String user_id = _pref.get('userid');
    String url = Constants.UPDATE_LEAD_BY_TYPE;

    var req = {
      'type': 'reminder',
      'id': '$id',
      'lead_id': "${widget.leadId}",
      'user_id': user_id,
      'text': description,
    };

    var response = await http.post(
      url,
      body: req,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if (items['status'] == 'success') {
        fetchLeadDetails();
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  Future<void> addNoteDialogue(
      BuildContext context, String notes, int id) async {
    notesController.text = notes;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            //backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      child: Text(
                        'Add lead',
                        style: Palette.whiteTitleone,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: 4,
                        controller: notesController,
                        keyboardType: TextInputType.name,
                        style: Palette.textFieldBlack,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cDarkBlue, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cDarkBlue, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          hintText: 'Enter Notes',
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child: Text('Cancel',
                                    style: Palette.whiteSubTitleB),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  var note = notesController.text;
                                  print('notes::::::::::::::::$notes');
                                  print('id::::::::::::::::$id');
                                  if (notes == '') {
                                    addNoteApi(note);
                                  } else {
                                    noteUpdateApi(note, id);
                                  }
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child:
                                    Text('Save', style: Palette.whiteSubTitleB),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> conformationDialogue(
      BuildContext context, String type, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            //backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      child: Text(
                        'Are you sure you want to delete?',
                        style: Palette.whiteTitleone,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child: Text('Cancel',
                                    style: Palette.whiteSubTitleB),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  deletApi(id, type);
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child:
                                    Text('Save', style: Palette.whiteSubTitleB),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<Widget> deletApi(int id, String type) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String url = Constants.DELET_LEAD_BY_TYPE;

    var req = {
      'type': type,
      'id': '$id',
      'lead_id': "${widget.leadId}",
    };

    var response = await http.post(
      url,
      body: req,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      var items = json.decode(response.body);
      print(items);
      if (items['status'] == 'success') {
        fetchLeadDetails();
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      // setState(() {
      //   subLocationList = [];
      // });
    }
  }

  Future<void> addLogDialogue(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            //backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      child: Text(
                        'Add Activity log',
                        style: Palette.whiteTitleone,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: 4,
                        controller: activityController,
                        keyboardType: TextInputType.name,
                        style: Palette.textFieldBlack,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cDarkBlue, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cDarkBlue, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          hintText: 'Enter Activity',
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child: Text('Cancel',
                                    style: Palette.whiteSubTitleB),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  var log = activityController.text;
                                  addActivityApi(log);
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child:
                                    Text('Save', style: Palette.whiteSubTitleB),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String date;

  Future<void> _selectDateOne(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> addReminderDialogue(
      BuildContext context, String reminder, int id, String date) async {
    descriptionController.text = reminder;
    //String date = '$selectedDate';
    date = '$date';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            //backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                      child: Text(
                        'Add Reminder',
                        style: Palette.whiteTitleone,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectDateOne(context);
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(right: 10.0, left: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: cDarkBlue)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('$selectedDate'),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 17.0,
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: 4,
                        controller: descriptionController,
                        keyboardType: TextInputType.name,
                        style: Palette.textFieldBlack,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cDarkBlue, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: cDarkBlue, width: 1.0),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          hintText: 'Description',
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child: Text('Cancel',
                                    style: Palette.whiteSubTitleB),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  var des = descriptionController.text;
                                  if (reminder == '') {
                                    addReminderApi(des, date);
                                  } else {
                                    reminderUpdateApi(des, id);
                                  }
                                },
                                shape: Palette.btnShape,
                                color: cDarkBlue,
                                child:
                                    Text('Save', style: Palette.whiteSubTitleB),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget noteList() {
    return Stack(
      children: [
        !isLoading
            ? notesList.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.all(10.0),
                    itemCount: notesList.isNotEmpty || notesList != null
                        ? notesList.length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      var note = notesList[index]['note'];
                      var date = notesList[index]['created_at'];

                      return Card(
                          shape: Palette.cardShape,
                          elevation: 10.0,
                          //margin: EdgeInsets.all(5.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '$note',
                                      style: Palette.leadTitle,
                                    )),
                                    InkWell(
                                      onTap: () {
                                        addNoteDialogue(
                                            context,
                                            notesList[index]['note'],
                                            notesList[index]['id']);
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        conformationDialogue(context, 'notes',
                                            notesList[index]['id']);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  '$date',
                                  style: Palette.leadTitle,
                                ),
                              ],
                            ),
                          ));
                    })
                : Container()
            : const SizedBox(
                height: 300.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: cDarkBlue,
                  ),
                ),
              ),
        Container(
          padding: EdgeInsets.all(15.0),
          alignment: Alignment.bottomRight,
          child: MaterialButton(
              color: cDarkBlue,
              shape: Palette.btnShape,
              height: 40,
              elevation: 8,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                addNoteDialogue(context, '', 0);
              }),
        )
      ],
    );
  }

  Widget activityLogList() {
    return Stack(
      children: [
        !isLoading
            ? logList.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.all(10.0),
                    itemCount: logList.isNotEmpty || logList != null
                        ? logList.length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      var activity = logList[index]['activity'];
                      var date = logList[index]['created_at'];

                      return Card(
                          elevation: 10.0,
                          shape: Palette.cardShape,
                          margin: EdgeInsets.all(5.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$firstName',
                                  style: Palette.leadData,
                                ),
                                Text(
                                  '$activity',
                                  style: Palette.leadTitle,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  '$date',
                                  style: Palette.leadTitle,
                                ),
                              ],
                            ),
                          ));
                    })
                : Container()
            : const SizedBox(
                height: 300.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: cDarkBlue,
                  ),
                ),
              ),
        Container(
          padding: EdgeInsets.all(15.0),
          alignment: Alignment.bottomRight,
          child: MaterialButton(
              color: cDarkBlue,
              shape: Palette.btnShape,
              height: 40,
              elevation: 8,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                addLogDialogue(context);
              }),
        )
      ],
    );
  }

  Widget documentList() {
    return Stack(
      children: [
        !isLoading
            ? docList.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.all(10.0),
                    itemCount: docList.isNotEmpty || docList != null
                        ? docList.length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 10.0,
                          shape: Palette.cardShape,
                          margin: EdgeInsets.all(5.0),
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        //color: Colors.black,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/img/file.png'))),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        conformationDialogue(context,
                                            'document', docList[index]['key']);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ))
                                ],
                              )));
                    })
                : Container()
            : const SizedBox(
                height: 300.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: cDarkBlue,
                  ),
                ),
              ),
        Container(
          padding: EdgeInsets.all(15.0),
          alignment: Alignment.bottomRight,
          child: MaterialButton(
              color: cDarkBlue,
              shape: Palette.btnShape,
              height: 40,
              elevation: 8,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDocument(
                      leadId: widget.leadId.toString(),
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    fetchLeadDetails();
                  });
                });
              }),
        )
      ],
    );
  }

  Widget reminder_List() {
    return Stack(
      children: [
        !isLoading
            ? reminderList.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.all(10.0),
                    itemCount: reminderList.isNotEmpty || reminderList != null
                        ? reminderList.length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      var description = reminderList[index]['description'];
                      var date = reminderList[index]['date_notified'];

                      return Card(
                          shape: Palette.cardShape,
                          elevation: 10.0,
                          margin: EdgeInsets.all(5.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '$description',
                                        style: Palette.leadTitle,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddReminder(
                                              leadId: widget.leadId.toString(),
                                              isUpdate: true,
                                              dateTime: reminderList[index]
                                                  ['date_notified'],
                                              desc: reminderList[index]
                                                  ['description'],
                                              reminderId: reminderList[index]
                                                      ['id']
                                                  .toString(),
                                            ),
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            fetchLeadDetails();
                                          });
                                        });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        conformationDialogue(
                                            context,
                                            'reminder',
                                            reminderList[index]['id']);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  '$date',
                                  style: Palette.leadTitle,
                                ),
                              ],
                            ),
                          ));
                    })
                : Container()
            : const SizedBox(
                height: 300.0,
                child: Center(
                  child: CircularProgressIndicator(
                    color: cDarkBlue,
                  ),
                ),
              ),
        Container(
          padding: EdgeInsets.all(15.0),
          alignment: Alignment.bottomRight,
          child: MaterialButton(
              color: cDarkBlue,
              shape: Palette.btnShape,
              height: 40,
              elevation: 8,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReminder(
                      leadId: widget.leadId.toString(),
                      isUpdate: false,
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    fetchLeadDetails();
                  });
                });
              }),
        )
      ],
    );
  }
}
