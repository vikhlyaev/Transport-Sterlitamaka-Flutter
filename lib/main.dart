import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/main_bottom_bar_widget.dart';
import 'package:transport_sterlitamaka/screens/transport_card/add_transport_card.dart';
import 'package:transport_sterlitamaka/screens/transport_card/existing_transport_card.dart';
import 'package:transport_sterlitamaka/screens/transport_card/new_transport_card_widget.dart';
import 'package:transport_sterlitamaka/screens/transport_card/transport_card_widget.dart';
import 'package:transport_sterlitamaka/theme/app_theme.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.stations;
  await DBHelper.instance.routes;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigatorProvider(),
      child: ChangeNotifierProvider(
        create: (context) => FavoritesProvider(),
        child: MaterialApp(
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
        ),
      ),
    );
  }
}
