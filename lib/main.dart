import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/main_screen/main_screen_widget.dart';
import 'package:transport_sterlitamaka/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Транспорт Стерлитамака',
      theme: AppTheme().light,
      routes: {
        '/': (context) => const MainScreenWidget(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
