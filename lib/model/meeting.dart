import 'package:flutter/material.dart';

//Clase para crear cada una de las citas

class Meeting {
  Meeting(
      {this.eventName = '',
      required this.from,
      required this.to,
      this.background,
      this.recurrenceRule,
      this.typeEvent,
      this.isAllDay = false});

  String? eventName;
  DateTime? from;
  DateTime? to;
  String? typeEvent;
  bool? isAllDay;
  Color? background;
  String? recurrenceRule;

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'from': from,
      'to': to,
      'typeEvent': typeEvent,
      'background': background,
    };
  }
}
