import 'package:flutter/material.dart';
import 'package:programador/model/meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

//Clase que extiene a CalendarDataSource para obtener los valores de las citas y mostrar en el programador

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
