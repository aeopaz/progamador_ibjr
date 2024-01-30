import 'package:programador/screens/calendar_page.dart';
import 'package:programador/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:syncfusion_flutter_core/localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: [const Locale('es')],
      locale: const Locale('es'),
      debugShowCheckedModeBanner: false,
      title: 'Programador',
      theme: ThemeData.light().copyWith(extensions: const [
        AppColors(
            accentuated: Colors.blueAccent,
            overlay: Colors.greenAccent,
            hint: Color(0x0091ba9a))
      ]),
      darkTheme: ThemeData.dark().copyWith(extensions: const [
        AppColors(
            accentuated: Colors.blue,
            overlay: Color(0xAF55439E),
            hint: Color(0xFFA2E90B))
      ]),
      themeMode: ThemeMode.system,
      home: const CalendarPage(),
    );
  }
}
