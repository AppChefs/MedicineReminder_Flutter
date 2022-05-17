import 'package:flutter/material.dart';

class CurrDate extends StatefulWidget {
  CurrDate({Key? key}) : super(key: key);

  @override
  State<CurrDate> createState() => _CurrDateState();
}

class _CurrDateState extends State<CurrDate> {
  @override
  void initState() {
    dateTime = DateTime.now();
    int switchCase = dateTime.weekday;
    printDate = "";

    if ((dateTime.month - 1) < 13 && (dateTime.month - 1) > 0) {
      if ((dateTime.weekday - 1) < 8 && (dateTime.weekday - 1) > 0) {
        printDate +=
            "${day[dateTime.weekday - 1]} \n${dateTime.day} ${month[dateTime.month - 1]}";
      }
    } else {
      printDate = "print date Error";
    }
  }

  List month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List day = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  DateTime dateTime = DateTime.now();

  String printDate = "printDate";

  // String
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  printDate,
                  style: const TextStyle(fontSize: 35, color: Colors.white),
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          const Expanded(
              flex: 2,
              child: Text("Next Medicine on\nDate - Time",
                  style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
