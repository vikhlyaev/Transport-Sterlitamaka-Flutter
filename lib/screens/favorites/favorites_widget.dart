import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/screens/routes/widgets/route_button_widget.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UserColors.blue,
        title: const Text('Избранное'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            'ОСТАНОВКИ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ListView.separated(
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              // return const StationCellWidget();
              return Placeholder();
            },
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFD9D9D9),
              height: 1,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'МАРШРУТЫ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            crossAxisCount: 5,
            children: const [
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
