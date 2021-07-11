import 'package:flutter/material.dart';

extension ExString on String {
  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(this)));
  }

  String? phoneNumberValidator() {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    final regex = RegExp(pattern.toString());
    if (!regex.hasMatch(this)) {
      return 'Enter Valid Phone Number';
    } else {
      return null;
    }
  }
}

String transformMilliSeconds(int milliseconds) {
  int hundreds = (milliseconds / 10).truncate();
  int seconds = (hundreds / 100).truncate();
  int minutes = (seconds / 60).truncate();
  int hours = (minutes / 60).truncate();
  String hoursStr = (hours % 60).toString().padLeft(2, '0');
  String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');
  return "$hoursStr:$minutesStr:$secondsStr";
}

extension IntExtension on int {
  String timeFormatter() {
    var minutes = (this / 60).round().toString();
    var seconds = (this % 60).round().toString();
    if (seconds.length == 1) {
      seconds = "0$seconds";
    }
    if (minutes.length == 1) {
      minutes = "0$minutes";
    }
    return "$minutes:$seconds";
  }
}
