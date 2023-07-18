import 'package:flutter/material.dart';
import 'package:phonepeproperty/style/palette.dart';


class Notes extends StatefulWidget {
   var noteList;


   Notes({this.noteList});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  void initState() {
    super.initState();
    print('noteListone:::::::::${widget.noteList}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('demo1',style: Palette.tabTitle,),
      ),
    );
  }
}
