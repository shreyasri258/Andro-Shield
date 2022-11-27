import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.37, 0, 0),
            ),
            SpinKitPouringHourGlassRefined(
                color: Colors.lightGreen, size: 50.0),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(0, deviceHeight(context) * 0.05, 0, 0),
            ),
            Text("Analyzing APK ...")
          ],
        )));
  }
}
