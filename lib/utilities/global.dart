import 'dart:core';
import 'package:flutter/material.dart';

const Color gradient1 = Color(0xff000000);
const Color gradient2 = Color(0xff00324C);
const Color badPerformanceColor = Color(0xffFF5F5F);
const Color averagePerformanceColor = Color(0xffFFB041);
const Color goodPerformanceColor = Color(0xffA1FF58);

String apiLink = "https://172.36.0.75:7291/api/";
String errorMessage = "";

//Used to assign colors based on Overall Equipment Effectiveness(OEE)
Color selectPerformanceColor(int oee) {
  return oee < 60
      ? badPerformanceColor
      : oee <= 78
          ? averagePerformanceColor
          : goodPerformanceColor;
}
