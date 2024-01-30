import 'package:programador/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:programador/model/meeting.dart';
import 'package:path/path.dart';

const _table = "meeting";

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'appointment.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE $_table (subject TEXT, startTime TEXT, endTime TEXT, typeEvent TEXT, recurrenceRule TEXT, isAllDay TEXT)",
      );
    }, version: 1);
  }

  static Future insert(Meeting meeting) async {
    Database database = await _openDB();
    return database.insert(_table, {
      'subject': meeting.eventName,
      'startTime': meeting.from.toString(),
      'endTime': meeting.to.toString(),
      'typeEvent': meeting.typeEvent,
      'recurrenceRule': meeting.recurrenceRule,
      'isAllDay': 'false'
    });
  }

  static Future deleteAllTableMeeting() async {
    Database database = await _openDB();
    return database.delete(_table);
  }

  static Future dbMeeting() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> meetingMap = await database.query(_table);
    return meetingMap;

    // return List.generate(
    //     meetingMap.length,
    //     (i) => Meeting(
    //           eventName: meetingMap[i]['eventName'],
    //           from: DateTime.parse(meetingMap[i]['startTime']),
    //           to: DateTime.parse(meetingMap[i]['endTime']),
    //           background:
    //               kColorsByEvent[meetingMap[i]['typeEvent']] ?? Colors.blue,
    //           isAllDay: false,
    //         ));
  }

  static Future dropTable() async {
    Database database = await _openDB();
    await database.execute('DROP TABLE IF EXISTS $_table');
  }
}
