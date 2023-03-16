import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/screens/routes/widgets/route_button_widget.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteStations =
        context.watch<FavoritesProvider>().favoriteStations;
    final favoriteRoutes = context.watch<FavoritesProvider>().favoriteRoutes;

    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, crossAxisSpacing: 16, mainAxisSpacing: 16);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: UserColors.blue,
        title: const Text('Избранное'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            'ОСТАНОВКИ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: favoriteStations.length,
            itemBuilder: (context, index) {
              return StationCellWidget(
                station: favoriteStations[index],
              );
              // return Placeholder();
            },
          ),
          const SizedBox(height: 32),
          Text(
            'МАРШРУТЫ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            gridDelegate: delegate,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: favoriteRoutes.length,
            itemBuilder: (context, index) =>
                RouteButtonWidget(route: favoriteRoutes[index]),
          ),
        ],
      ),
    );
  }
}
