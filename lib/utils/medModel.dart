import 'package:flutter/material.dart';

class MedModel {
  int id;

  int startDateD;
  int startDateM;
  int startDateY;

  int endDateD;
  int endDateM;
  int endDateY;

  int freqDay;
  int freqTime;
  int unit;

  String instructions;

  MedModel({
    this.id = 4004,
    this.startDateD = 1,
    this.startDateM = 1,
    this.startDateY = 2000,
    this.endDateD = 1,
    this.endDateM = 1,
    this.endDateY = 3000,
    this.freqDay = 0,
    this.freqTime = 0,
    this.unit = 3,
    this.instructions = "",
  });
}

class DoesTime {
  int id;
  int timeH;
  int timeM;

  DoesTime({this.id = 4004, this.timeH = 8, this.timeM = 0});
}
