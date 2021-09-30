import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';

import 'class_model.dart';

const List<String> convertToDBColumn = [
  "OPEN_TIME",
  "OPEN_TIME",
  "CLASS_NUMBER",
  "COLLEGE_NAME",
  "COLLEGE_MAJOR",
  "CLASS_NAME",
  "CLASS_SECTOR_1",
  "CLASS_SECTOR_2",
  "CLASS_SECTOR_TOTAL",
  "CREDIT",
  "CAMPUS",
  "PROFESSOR",
  "CLASS_TIME",
  "HEAD_COUNT"
];

String getClassSector(String CLASS_SECTOR_1, String CLASS_SECTOR_2) {
  return CLASS_SECTOR_2.trim().isEmpty ? CLASS_SECTOR_1 : CLASS_SECTOR_2;
}

OpenTimeModel getOpenTime(String YEAR, String SEMESTER) {
  OpenTimeModel open_time = OpenTimeModel.fromJson(YEAR, SEMESTER);
  return open_time;
}

List<ClassTimeModel> getClassTime(String classTime) {
  List<String> classTimeString = classTime.split(",");
  classTimeString.removeWhere((element) => element.isEmpty);

  List<ClassTimeModel> class_time_list =
      classTimeString.map((e) => ClassTimeModel.fromJson(e)).toList();

  return class_time_list;
}

Map<String, dynamic> getMapData(List<dynamic> rows) {
  OpenTimeModel OPEN_TIME = getOpenTime(rows[0], rows[1]);
  String CLASS_NUMBER = rows[2];
  String COLLEGE_NAME = rows[3];
  String COLLEGE_MAJOR = rows[4];
  String CLASS_NAME = rows[5];
  String CLASS_SECTOR_1 = getClassSector(rows[6], rows[7]);
  String CLASS_SECTOR_TOTAL = rows[8];
  double CREDIT = rows[9].toDouble();
  String CAMPUS = rows[10];
  String PROFESSOR = rows[11];
  List<ClassTimeModel> CLASS_TIME = getClassTime(rows[12]);
  int HEAD_COUNT = rows[13];

  ClassModel classModel = ClassModel(
      OPEN_TIME: OPEN_TIME,
      CLASS_NUMBER: CLASS_NUMBER,
      COLLEGE_NAME: COLLEGE_NAME,
      COLLEGE_MAJOR: COLLEGE_MAJOR,
      CLASS_NAME: CLASS_NAME,
      CLASS_SECTOR_1: CLASS_SECTOR_1,
      CLASS_SECTOR_TOTAL: CLASS_SECTOR_TOTAL,
      CREDIT: CREDIT,
      CAMPUS: CAMPUS,
      PROFESSOR: PROFESSOR,
      CLASS_TIME: CLASS_TIME,
      HEAD_COUNT: HEAD_COUNT);

  return classModel.toJson();
}

class ColData {
  List<String> CLASS_SECTOR_TOTAL = [];
  List<String> CLASS_SECTOR_1 = [];
  List<String> COLLEGE_NAME = [];
  List<String> COLLEGE_MAJOR = [];

  ColData();

  void getColData(List<dynamic> rows) {
    checkSectorTotal(rows[3], COLLEGE_NAME);
    checkSectorTotal(rows[4], COLLEGE_MAJOR);

    String CLASS_SECTOR = getClassSector(rows[6], rows[7]);
    checkSectorTotal(CLASS_SECTOR, CLASS_SECTOR_1);
    checkSectorTotal(rows[8], CLASS_SECTOR_TOTAL);
  }

  void checkSectorTotal(String item, List<String> CLASS_SECTOR_TOTAL) {
    bool tag = true;
    for (var i in CLASS_SECTOR_TOTAL) {
      if (i == item) {
        tag = false;
        break;
      }
    }

    if (tag) {
      CLASS_SECTOR_TOTAL.add(item);
    }
  }
}
