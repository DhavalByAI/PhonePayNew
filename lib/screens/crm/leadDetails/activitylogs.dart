import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';


class ActivityLogs extends StatefulWidget {


  @override
  _ActivityLogsState createState() => _ActivityLogsState();
}

class _ActivityLogsState extends State<ActivityLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('demo2',style: Palette.tabTitle,),
      ),
    );
  }
}
