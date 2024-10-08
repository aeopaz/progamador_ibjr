import 'package:programador/helpers/pusher_client.dart';
import 'package:programador/model/meeting.dart';
import 'package:programador/model/my_appointment.dart';
import 'package:programador/model/meeting_data_source.dart';
import 'package:programador/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:programador/helpers/notifications.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String dataSearch = '';
  MyAppointment myAppointment = MyAppointment();
  CalendarView calendarView = CalendarView.schedule;
  CalendarController calendarController = CalendarController();
  MyPusherClient myPusherClient =
      MyPusherClient(channelName: 'ibjr', eventName: 'ibjr');
  TextStyle styleTextCalendar = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.black,
        offset: Offset(1.0, 1.0),
        blurRadius: 5.0,
      ),
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _conectPusher();
    _loadNotifications();
  }

  void _conectPusher() async {
    myPusherClient.onConnect();
  }

  void _loadNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Aquí inicializamos la instancia de notificaciones
    await initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.accentuated,
        title: const Text(
          'IBJR Programador',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationName: 'Programador',
                    // applicationVersion: '1',
                    applicationLegalese:
                        'Creado por: aeosoft. Info: aeopaz@gmail.com');
              },
              icon: const Icon(Icons.info_outline))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          inputSearch(),
          viewsCalendar(),
          Expanded(child: programador())
        ],
      )),
    );
  }

  TextField inputSearch() {
    return TextField(
      onChanged: (value) {
        setState(() {
          dataSearch = value;
        });
        setState(() {});
      },
      decoration: InputDecoration(icon: Icon(Icons.search), hintText: 'Buscar'),
    );
  }

  Row viewsCalendar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
            onPressed: () {
              setState(() {
                calendarView = CalendarView.month;
                calendarController.view = calendarView;
              });
            },
            child: Text('Mes')),
        OutlinedButton(
            onPressed: () {
              setState(() {
                calendarView = CalendarView.week;
                calendarController.view = calendarView;
              });
            },
            child: Text('Semana')),
        OutlinedButton(
            onPressed: () {
              setState(() {
                calendarView = CalendarView.day;
                calendarController.view = calendarView;
              });
            },
            child: Text('Día')),
        OutlinedButton(
            onPressed: () {
              setState(() {
                calendarView = CalendarView.schedule;
                calendarController.view = calendarView;
              });
            },
            child: Text('Cronograma')),
      ],
    );
  }

  FutureBuilder<List<Meeting>> programador() {
    return FutureBuilder(
      future: myAppointment.getOrganizeData(dataSearch),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Container(
            child: const Center(
                child: Text('Ocurrió un error al cargar el programador')),
          );
        } else {
          return Container(
            child: SfCalendar(
                view: calendarView,
                controller: calendarController,
                appointmentTextStyle: styleTextCalendar,
                timeZone: 'America/Bogota',
                scheduleViewSettings: ScheduleViewSettings(
                    appointmentTextStyle: styleTextCalendar),
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  agendaStyle: AgendaStyle(
                    appointmentTextStyle: styleTextCalendar,
                  ),
                ),
                dataSource: MeetingDataSource(snapshot.data),
                initialDisplayDate: DateTime.now() //snapshot.data[0].from,
                ),
          );
        }
      },
    );
  }
}
