class ClassModel {
  OpenTimeModel OPEN_TIME;
  String CLASS_NUMBER;
  String COLLEGE_NAME;
  String COLLEGE_MAJOR;
  String CLASS_NAME;
  String CLASS_SECTOR_1;
  String CLASS_SECTOR_TOTAL;
  double CREDIT;
  String CAMPUS;
  String PROFESSOR;
  List<ClassTimeModel> CLASS_TIME;
  int HEAD_COUNT;

  ClassModel(
      {this.CAMPUS,
      this.CLASS_NAME,
      this.CLASS_NUMBER,
      this.CLASS_SECTOR_1,
      this.CLASS_SECTOR_TOTAL,
      this.CLASS_TIME,
      this.COLLEGE_MAJOR,
      this.COLLEGE_NAME,
      this.CREDIT,
      this.HEAD_COUNT,
      this.OPEN_TIME,
      this.PROFESSOR});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["CAMPUS"] = this.CAMPUS;
    data["CLASS_NAME"] = this.CLASS_NAME;
    data["CLASS_NUMBER"] = this.CLASS_NUMBER;
    data["CLASS_SECTOR_1"] = this.CLASS_SECTOR_1;
    data["CLASS_SECTOR_TOTAL"] = this.CLASS_SECTOR_TOTAL;
    data["CLASS_TIME"] = this.CLASS_TIME.map((e) => e.toJson()).toList();
    data["COLLEGE_MAJOR"] = this.COLLEGE_MAJOR;
    data["COLLEGE_NAME"] = this.COLLEGE_NAME;
    data["CREDIT"] = this.CREDIT;
    data["HEAD_COUNT"] = this.HEAD_COUNT;
    data["OPEN_TIME"] = this.OPEN_TIME.toJson();
    data["PROFESSOR"] = this.PROFESSOR;
    return data;
  }
}

class OpenTimeModel {
  String YEAR;
  String SEMESTER;

  OpenTimeModel({this.SEMESTER, this.YEAR});

  OpenTimeModel.fromJson(String YEAR, String SEMESTER) {
    this.YEAR = YEAR;
    this.SEMESTER = SEMESTER[0];
  }

  Map<String, String> toJson() {
    Map<String, String> data = {};

    data["YEAR"] = this.YEAR;
    data["SEMESTER"] = this.SEMESTER;

    return data;
  }
}

class ClassTimeModel {
  String day;
  String start_time;
  String end_time;
  String class_room;

  ClassTimeModel({this.day, this.start_time, this.end_time, this.class_room});

  ClassTimeModel.fromJson(String timeString) {
    timeString = timeString.trim();

    if (timeString == "미지정" || timeString == null) {
      this.day = "미지정";
      this.start_time = "미지정";
      this.end_time = "미지정";
      this.class_room = "미지정";
    } else if (timeString.trim() == "【iCampus 수업】".trim()) {
      this.day = "【iCampus 수업】";
      this.start_time = "【iCampus 수업】";
      this.end_time = "【iCampus 수업】";
      this.class_room = "【iCampus 수업】";
    } else {
      this.day = timeString[0];
      this.start_time = timeString.substring(1, 6);
      this.end_time = timeString.substring(7, 12);
      if (timeString[13] == "미") {
        this.class_room = "미지정";
      } else {
        this.class_room = timeString.substring(13, 18);
      }
    }
  }

  Map<String, String> toJson() {
    Map<String, String> data = {};
    data["day"] = this.day;
    data["start_time"] = this.start_time;
    data["end_time"] = this.end_time;
    data["class_room"] = this.class_room;
    return data;
  }
}
