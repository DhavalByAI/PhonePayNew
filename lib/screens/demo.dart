import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Appbar'),
      ),
      body: ListView(
        children: [
         ListTile(
           title: Text('name'),
           subtitle: Text('lastname'),
           leading: Icon(Icons.access_time),
           trailing: Icon(Icons.ac_unit),
         ),
          ListTile(
            title: Text('name'),
            subtitle: Text('lastname'),
            leading: Icon(Icons.access_time),
            trailing: Icon(Icons.ac_unit),
          ),
          ListTile(
            isThreeLine: true,
            title: Text('name'),
            subtitle: Text('lastname'),
            leading: Icon(Icons.access_time),
            trailing: Icon(Icons.ac_unit),
          ),
          Divider(),
          Card(
            child: ListTile(
              isThreeLine: true,
              title: Text('name'),
              subtitle: Column(
                children: [
                  Text('lastname'),
                  Text('lastname'),
                ],
              ),
              leading: Icon(Icons.access_time),
              trailing: Icon(Icons.ac_unit),
            ),
          )
        ],
      ),
    );
  }
  
}