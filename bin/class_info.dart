import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:mysql1/mysql1.dart';

import 'class_model.dart';
import 'read_exccel.dart';

const OPTION = {
  "host":
      'database-polarstar-2021-08-08.cwb9qa1qjecy.ap-northeast-2.rds.amazonaws.com',
  "port": 3306, //NEVER CHANGE
  "user": 'root',
  "password": "polarStar317927", //비번 입력 //mysql, redis 비번
  "database": 'polarStar',
  "dateStrings": "date",
};

Future<MySqlConnection> getDB() async {
  var settings = new ConnectionSettings(
      host:
          'database-polarstar-2021-08-08.cwb9qa1qjecy.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      user: 'root',
      password: "polarStar317927", //비번 입력 //mysql, redis 비번
      db: 'polarStar');
  var conn = await MySqlConnection.connect(settings);
  return conn;
}

void insertDB(table, con, log, i) async {
  Map<String, dynamic> data = getMapData(table.rows[i]);

  var a = await con.query(
      " insert into CLASS_INFO (CLASS_NAME, CLASS_SECTOR_1, CLASS_SECTOR_TOTAL, CREDIT, CAMPUS, PROFESSOR, CLASS_TIME, HEAD_COUNT, CLASS_NUMBER, COLLEGE_NAME, COLLEGE_MAJOR, OPEN_TIME)" +
          " values(?,?,?,?,?,?,?,?,?,?,?,?)",
      [
        data["CLASS_NAME"],
        data["CLASS_SECTOR_1"],
        data["CLASS_SECTOR_TOTAL"],
        data["CREDIT"],
        data["CAMPUS"],
        data["PROFESSOR"],
        json.encode(data["CLASS_TIME"]),
        data["HEAD_COUNT"],
        data["CLASS_NUMBER"],
        data["COLLEGE_NAME"],
        data["COLLEGE_MAJOR"],
        [json.encode(data["OPEN_TIME"])]
      ]);
  log.writeAsString("${i} / ${table.rows.length - 1}\n", mode: FileMode.append);
}

void readColdata(table) async {
  ColData data = ColData();
  // table.rows.length - 1
  for (int i = 1; i < table.rows.length - 1; i++) {
    print("${(i / (table.rows.length - 1)) * 100}");
    data.getColData(table.rows[i]);
  }

  var cst = File("CLASS_SECTOR_TOTAL.txt");
  var cs1 = File("CLASS_SECTOR_1.txt");
  var cn = File("COLLEGE_NAME.txt");
  var cm = File("COLLEGE_MAJOR.txt");

  await cst.writeAsString("CLASS_SECTOR_TOTAL\n");
  await cs1.writeAsString("CLASS_SECTOR_1\n");
  await cn.writeAsString("COLLEGE_NAME\n");
  await cm.writeAsString("COLLEGE_MAJOR\n");

  for (var i = 0; i < data.CLASS_SECTOR_TOTAL.length; i++) {
    await cst.writeAsString("${data.CLASS_SECTOR_TOTAL[i]} ${i}\n",
        mode: FileMode.append);
  }

  for (var i = 0; i < data.CLASS_SECTOR_1.length; i++) {
    await cs1.writeAsString("${data.CLASS_SECTOR_1[i]} ${i}\n",
        mode: FileMode.append, encoding: utf8);
  }

  for (var i = 0; i < data.COLLEGE_NAME.length; i++) {
    await cn.writeAsString("${data.COLLEGE_NAME[i]} ${i}\n",
        mode: FileMode.append, encoding: utf8);
  }

  for (var i = 0; i < data.COLLEGE_MAJOR.length; i++) {
    await cm.writeAsString("${data.COLLEGE_MAJOR[i]} ${i}\n",
        mode: FileMode.append, encoding: utf8);
  }

  print("${data.CLASS_SECTOR_TOTAL} :  ${data.CLASS_SECTOR_TOTAL.length}");
  print("${data.CLASS_SECTOR_1} :  ${data.CLASS_SECTOR_1.length}");
  print("${data.COLLEGE_NAME} :  ${data.COLLEGE_NAME.length}");
  print("${data.COLLEGE_MAJOR} :  ${data.COLLEGE_MAJOR.length}");
}

void main(List<String> arguments) async {
  // var file = "class.xlsx";
  // var log_file = "log.txt";
  // var error_file = "error.txt";

  // var bytes = File(file).readAsBytesSync();
  // var excel = Excel.decodeBytes(bytes);
  // Sheet table = excel.tables["Sheet"];

  MySqlConnection con = await getDB();

  var cst_txt = File("CLASS_SECTOR_TOTAL.txt");
  var cs1_txt = File("CLASS_SECTOR_1.txt");
  var cn_txt = File("COLLEGE_NAME.txt");
  var cm_txt = File("COLLEGE_MAJOR.txt");

  var cst = await cst_txt.readAsLines();
  var cs1 = await cs1_txt.readAsLines();
  var cn = await cn_txt.readAsLines();
  var cm = await cm_txt.readAsLines();

  for (var item in cst) {
    String key = item.split(":!:")[0];
    String value = item.split(":!:")[1];
    await con.query(
        "UPDATE polarStar.CLASS_INFO SET INDEX_SECTOR_TOTAL = ? WHERE CLASS_SECTOR_TOTAL = ?",
        [value, key]);
  }

  for (var item in cs1) {
    if (item.isEmpty) {
      break;
    }
    String key = item.split(":!:")[0];
    String value = item.split(":!:")[1];
    await con.query(
        "UPDATE polarStar.CLASS_INFO SET INDEX_SECTOR_1 = ? WHERE CLASS_SECTOR_1 = ?",
        [value, key]);
  }

  for (var item in cn) {
    String key = item.split(":!:")[0];
    String value = item.split(":!:")[1];
    await con.query(
        "UPDATE polarStar.CLASS_INFO SET INDEX_COLLEGE_NAME = ? WHERE COLLEGE_NAME = ?",
        [value, key]);
  }

  for (var item in cm) {
    String key = item.split(":!:")[0];
    String value = item.split(":!:")[1];
    await con.query(
        "UPDATE polarStar.CLASS_INFO SET INDEX_COLLEGE_MAJOR = ? WHERE COLLEGE_MAJOR = ?",
        [value, key]);
  }
  print("finish");
  return;
}
