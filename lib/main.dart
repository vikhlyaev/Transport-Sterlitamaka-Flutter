import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/main_bottom_bar_widget.dart';
import 'package:transport_sterlitamaka/screens/transport_card/add_transport_card.dart';
import 'package:transport_sterlitamaka/screens/transport_card/existing_transport_card.dart';
import 'package:transport_sterlitamaka/screens/transport_card/new_transport_card_widget.dart';
import 'package:transport_sterlitamaka/screens/transport_card/transport_card_widget.dart';
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
        '/': (context) => const MainBottomBarWidget(),
        '/card': (context) => const TransportCardWidget(),
        '/add-card': (context) => const AddTransportCardWidget(),
        '/add-card/new': (context) => const NewTransportCardWidget(),
        '/add-card/existing': (context) => const ExistingTransportCardWidget(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
