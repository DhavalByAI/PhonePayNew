import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialogImg {
  static Future<void> showLoadingDialogImg(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        SizedBox(height: 5),
                        Text(
                          "Hold On..!",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          //decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/img/loadingImg.jpg'))),
                          child: Lottie.asset('assets/img/loading.json'),
                        ),
                        SizedBox(height: 10),
                        LinearProgressIndicator(),
                        SizedBox(height: 12),
                        Text(
                          "WE'RE UPLOAD YOUR PROPERTY TO CLOUD",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
