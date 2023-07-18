import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:phonepeproperty/widgets/error_dialouge.dart';
import 'package:phonepeproperty/widgets/loadingDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddReminder extends StatefulWidget {
  final String leadId, desc, dateTime, reminderId;
  final bool isUpdate;

  AddReminder(
      {@required this.leadId,
      @required this.isUpdate,
      this.desc,
      this.dateTime,
      this.reminderId});

  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<State> _keyError = new GlobalKey<State>();

  TextEditingController descConroller = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  var timeHourFormate;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      descConroller.text = widget.desc;
    }
    var toTimeHr;
    var toTimeMin;
    if (time.hour > 9) {
      toTimeHr = time.hour.toString();
    } else {
      toTimeHr = '0' + time.hour.toString();
    }

    if (time.minute > 9) {
      toTimeMin = time.minute.toString();
    } else {
      toTimeMin = '0' + time.minute.toString();
    }

    timeHourFormate = '$toTimeHr:$toTimeMin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        //brightness: Brightness.dark,
        backgroundColor: cDarkBlue,
        title: !widget.isUpdate
            ? Text('Add Reminder', style: Palette.tabTitle)
            : Text('Update Reminder', style: Palette.tabTitle),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          datePicker(),
          descriptionWidget(),
          nextBtn(),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectTime(context);
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: time);

    if (picked != null) {
      setState(() {
        time = picked;
        var toTimeHr;
        var toTimeMin;
        if (time.hour > 9) {
          toTimeHr = time.hour.toString();
        } else {
          toTimeHr = '0' + time.hour.toString();
        }

        if (time.minute > 9) {
          toTimeMin = time.minute.toString();
        } else {
          toTimeMin = '0' + time.minute.toString();
        }

        timeHourFormate = '$toTimeHr:$toTimeMin';
      });
    }
  }

  Widget descriptionWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(' Description :', style: Palette.title2),
          const SizedBox(height: 8),
          TextField(
            controller: descConroller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: const TextStyle(
              color: kdarkgrey,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              fillColor: Colors.indigo[50],
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo[50], width: 2.0),
                borderRadius: BorderRadius.circular(7.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo[50], width: 2.0),
                borderRadius: BorderRadius.circular(7.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo[50], width: 2.0),
                borderRadius: BorderRadius.circular(7.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo[50], width: 2.0),
                borderRadius: BorderRadius.circular(7.0),
              ),
              contentPadding: const EdgeInsets.all(15.0),
              hintText: "Write here...",
              labelStyle: const TextStyle(color: kGreyone),
            ),
          ),
        ],
      ),
    );
  }

  Widget datePicker() {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
          margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(' Date - Time for Reminder:', style: Palette.title2),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$selectedDate".split(' ')[0] + " $timeHourFormate",
                          style: const TextStyle(
                              color: kdarkgrey, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: cDarkBlue,
                        size: 17.0,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget nextBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 30),
      width: 150,
      decoration: const BoxDecoration(
          color: cDarkBlue,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Save',
                style: Palette.whiteBtnText,
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
        onTap: () {
          setState(() {
            var _selected =
                "${selectedDate.year}/${selectedDate.day}/${selectedDate.month} $timeHourFormate";
            if (widget.isUpdate) {
              updateReminderApi(descConroller.text, _selected);
            } else {
              addReminderApi(descConroller.text, _selected);
            }
          });
        },
      ),
    );
  }

  Future<void> addReminderApi(String description, String date) async {
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
        //fetchLeadDetails();
        Navigator.pop(context);
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      ErrorDialouge.showErrorDialogue(
          context, _keyError, "Something went wrong, Please try again..!");
    }
  }

  Future<void> updateReminderApi(String description, String date) async {
    LoadingDialog.showLoadingDialog(context, _keyLoader);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String token = _pref.getString('token');
    String user_id = _pref.get('userid');
    String url = Constants.UPDATE_LEAD_BY_TYPE;

    var req = {
      'type': 'reminder',
      'id': widget.reminderId,
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
        //fetchLeadDetails();
        Navigator.pop(context);
      } else {
        ErrorDialouge.showErrorDialogue(context, _keyError, items['message']);
      }
    } else {
      ErrorDialouge.showErrorDialogue(
          context, _keyError, "Something went wrong, Please try again..!");
    }
  }
}
