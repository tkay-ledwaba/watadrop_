import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watadrop/common/style.dart';

class Timeline extends StatelessWidget{
  final int ticks;
  const Timeline(this.ticks, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        tick1(),
        //spacer(),
        line(),
        //spacer(),
        tick2(),
        //spacer(),
        line(),
        //spacer(),
        tick3(),
        //spacer(),
        line(),
        //spacer(),
        tick4(),
      ],
    );
  }

  Widget tick(bool isChecked){
    return isChecked?Icon(Icons.check_circle,color: colorAccent,):Icon(Icons.radio_button_unchecked, color: colorAccent,);
  }

  Widget tick1() {
    return this.ticks>0?tick(true):tick(false);
  }
  Widget tick2() {
    return this.ticks>1?tick(true):tick(false);
  }
  Widget tick3() {
    return this.ticks>2?tick(true):tick(false);
  }
  Widget tick4() {
    return this.ticks>3?tick(true):tick(false);
  }

  Widget line() {
    return Container(
      color: colorAccent,
      height: 2.0,
      width: 32.0,
    );
  }

}