import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:transport_sterlitamaka/screens/favorites/favorites_widget.dart';
import 'package:transport_sterlitamaka/screens/maps/maps_widget.dart';
import 'package:transport_sterlitamaka/screens/routes/routes_widget.dart';
import 'package:transport_sterlitamaka/screens/stations/stations_widget.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

class MainBottomBarWidget extends StatefulWidget {
  const MainBottomBarWidget({super.key});

  @override
  State<MainBottomBarWidget> createState() => _MainBottomBarWidgetState();
}

class _MainBottomBarWidgetState extends State<MainBottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: context.watch<NavigatorProvider>().currentIndex,
        onTap: (index) =>
            context.read<NavigatorProvider>().setCurrentIndex(index),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.map),
            title: const Text('Карта'),
            selectedColor: UserColors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.directions_bus),
            title: const Text('Остановки'),
            selectedColor: UserColors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.route),
            title: const Text('Маршруты'),
            selectedColor: UserColors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Избранное'),
            selectedColor: UserColors.red,
          ),
        ],
      ),
      body: IndexedStack(
        index: context.watch<NavigatorProvider>().currentIndex,
        children: const <Widget>[
          MapsWidget(),
          StationsWidget(),
          RoutesWidget(),
          FavoritesWidget()
        ],
      ),
    );
  }
}
