import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        color: CupertinoColors.white,
        child: Center(
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 15.0,
          ),
        )
      );
  }
}