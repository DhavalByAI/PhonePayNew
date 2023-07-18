import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phonepeproperty/config/constant.dart';
import 'package:phonepeproperty/screens/Auth/login.dart';
import 'package:phonepeproperty/screens/crm/addlead.dart';
import 'package:phonepeproperty/screens/crm/filterscreen.dart';
import 'package:phonepeproperty/screens/crm/leadDetails/leaddetails.dart';
import 'package:phonepeproperty/style/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CRM extends StatefulWidget {
  final String name;
  var sourceId,statusId,start,end;
  CRM({Key key, @required this.name,@required this.sourceId,@required this.statusId,@required this.start,@required this.end}) : super(key: key);

  @override
  _CRMState createState() => _CRMState();
}

class _CRMState extends State<CRM> {
  bool isLoading = true;

  var lead_List = [];

  final GlobalKey<dynamic> _refreshIndicatorKey = GlobalKey();

  String fname;
  var sourceId;
  var statusId;
  var budgetFrom;
  var budgetTo;

  @override
  void initState() {
    super.initState();

    fname = widget.name ?? '';
    sourceId = widget.sourceId ?? '';
    statusId = widget.statusId ?? '';
    budgetFrom = widget.start ?? '';
    budgetTo = widget.end ?? '';

    fetchLeadList(fname,sourceId,statusId,budgetFrom,budgetTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cDarkBlue,
        title: Text('CRM', style: Palette.whiteTitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FilterScreen()));
              },
              icon: Icon(Icons.filter_alt_outlined)),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddLead())).then(
                (value) => setState(
                  () {
                    _leadList();
                  },
                ),
              );
            },
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: _leadList(),
    );
  }

  fetchLeadList(String firstName , var sourceId , var statusId,var budgetFrom,var budgetTo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userid = pref.getString('userid');
    String token = pref.getString('token');
    String url = Constants.LEAD_LIST;

    var requestBody = {
      'user_id': userid,
      'first_name': firstName,
      'source_id': sourceId,
      'status_id': statusId,
      'budget_from': budgetFrom,
      'budget_to': budgetTo,
    };

    print(url);

    try {
      var response = await http.post(
        url,
        body: requestBody,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );

      var items = json.decode(response.body);
      print(items);

      if (response.statusCode == 200) {
        //isLoading =  false;
        setState(() {
          isLoading = false;
          lead_List = items;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _leadList() {
    return !isLoading
        ? lead_List.length > 0
            ? ListView.builder(
                key: _refreshIndicatorKey,
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.all(15.0),
                itemCount: lead_List.isNotEmpty || lead_List != null
                    ? lead_List.length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  var id = lead_List[index]['id'];
                  var firstName = lead_List[index]['first_name'] ?? '-';
                  var phonre_number = lead_List[index]['phonre_number'] ?? '-';
                  var budget = lead_List[index]['budget'] ?? '-';
                  var client_reference_by =
                      lead_List[index]['client_reference_by'] ?? '-';
                  var property_type = lead_List[index]['property_type'] ?? '-';
                  var property_name = lead_List[index]['property_name'] ?? '-';
                  var email = lead_List[index]['email'] ?? '-';
                  var source_id = lead_List[index]['source_id'] ?? '-';
                  var created_date = lead_List[index]['created_date'] ?? '-';

                  return InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadDetails(
                              leadId: lead_List[index]['id'],
                            ),
                          ),
                        ).then((value) => fetchLeadList(fname,sourceId,statusId,budgetFrom,budgetTo));
                      });
                    },
                    child: Card(
                        elevation: 10.0,
                        shape: Palette.cardShape,
                        margin: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              shape: Palette.cardShape,
                              color: Colors.black12,
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 20,
                                      child: Text(
                                        "$id",
                                        style: Palette.subTitleBold,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "$firstName",
                                            style: Palette.title2,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "$phonre_number",
                                            style: Palette.subTitle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Card(
                                      elevation: 0,
                                      shape: Palette.cardShape,
                                      color: cDarkBlue,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 4, 8, 4),
                                        child: Text(
                                          '\u{20B9} $budget',
                                          style: Palette.whiteSubTitleB,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Property Details :'),
                                  SizedBox(height: 6),
                                  Text(
                                    '$property_name ($property_type)',
                                    style: Palette.title2,
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 8, 15, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Referance :'),
                                  SizedBox(height: 6),
                                  Text(
                                    '$client_reference_by',
                                    style: Palette.title2,
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '$source_id',
                                    style: Palette.leadData,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  '$created_date',
                                  style: Palette.subTitle2,
                                ),
                              ),
                            )
                          ],
                        )),
                  );
                })
            : Container()
        : const SizedBox(
            height: 300.0,
            child: Center(
              child: CircularProgressIndicator(
                color: cDarkBlue,
              ),
            ),
          );
  }
}
