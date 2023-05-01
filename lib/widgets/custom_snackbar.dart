import 'package:flutter/material.dart';

showCustomSnackBar(context, msg, color){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(msg)));
}