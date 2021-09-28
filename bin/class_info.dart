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

void main(List<String> arguments) async {
  var file = "class.xlsx";
  var log_file = "log.txt";
  var error_file = "error.txt";

  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  Sheet table = excel.tables["Sheet"];
  MySqlConnection con = await getDB();

  var log = File(log_file);
  var error = File(error_file);

  log.writeAsString("FILE LOG\n");

  // table.rows.length - 1
  for (int i = 1; i < table.rows.length - 1; i++) {
    print((i / table.rows.length) * 100);
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

    log.writeAsString("${i} / ${table.rows.length - 1}\n",
        mode: FileMode.append);
  }
}
