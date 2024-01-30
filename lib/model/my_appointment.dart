import 'dart:convert';
import 'package:programador/model/meeting.dart';
import 'package:programador/utilities/constants.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:programador/helpers/db.dart';

// Clase que realiza la consulta a la api (Google Sheet)
const String _localVersion = 'localVersion';

class MyAppointment {
  Future<List<Meeting>> getOrganizeData() async {
    print('comienza');
    // DB.dropTable();
    dynamic data;
    List<Meeting> appointmentData = [];
    try {
      String checkVersionUrl = await getCheckCalendarVersion();
      if (checkVersionUrl == _localVersion) {
        data = await getDataDB();
      } else {
        data = await getDataFromGoogleSheet(checkVersionUrl);
      }

      dynamic jsonAppData = data;
      for (var data in jsonAppData) {
        Meeting meetingData = Meeting(
            eventName: data['subject'],
            from: _convertDateFromString(data['startTime']),
            to: _convertDateFromString(data['endTime']),
            typeEvent: data['typeEvent'],
            recurrenceRule: data['recurrenceRule'],
            isAllDay: data['typeEvent'] == 'cumpleanos' ? true : false,
            background: kColorsByEvent[data['typeEvent']] ?? Colors.blue);
        appointmentData.add(meetingData);
        checkVersionUrl != _localVersion ? DB.insert(meetingData) : '';
      }
    } catch (e) {
      print("Error al organizar la data $e");
    }
    return appointmentData;
  }

  Future getDataDB() async {
    dynamic data = await DB.dbMeeting();
    return data;
  }

  Future getDataFromGoogleSheet(url) async {
    DB.deleteAllTableMeeting();
    Response data = await get(Uri.parse(url));
    return jsonDecode(data.body);
  }

  Future<String> getCheckCalendarVersion() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response data = await get(Uri.parse(kUrlVersionamiento));
      dynamic jsonVersionData = jsonDecode(data.body);

      dynamic cloudDateVersion =
          jsonVersionData[jsonVersionData.length - 1]['version'];
      String url = jsonVersionData[jsonVersionData.length - 1]['url'];

      dynamic localDateVersion = await prefs.getInt('localVersion');
      print(
          "Fecha version cronograma $localDateVersion desde getCheckCalendarVersion");

      if (localDateVersion == null) {
        print('Desde la nube por null');
        await prefs.setInt(_localVersion, cloudDateVersion);
        return url;
      } else if (localDateVersion == cloudDateVersion) {
        print('Desde localVersion por version igual');
        return _localVersion;
      } else {
        print('Desde la nube por version diferente');
        await prefs.setInt(_localVersion, cloudDateVersion);
        return url;
      }
    } catch (e) {
      print("Error en la conexión del archivo en la nube $e");
      return _localVersion;
    }
  }

  DateTime _convertDateFromString(String date) {
    return DateTime.parse(date);
  }
}
