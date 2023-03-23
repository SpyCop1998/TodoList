import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(bool success){
  Fluttertoast.showToast(
      msg: success?"Suceess":"Something Went Wrong",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor:success? Colors.green:Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}