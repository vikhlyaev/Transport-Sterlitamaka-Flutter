import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/main_screen/widgets/routes/widgets/route_button_widget.dart';

class RoutesWidget extends StatelessWidget {
  const RoutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршруты'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            'ТРОЛЛЕЙБУСЫ',
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
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
              RouteButtonWidget(),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'АВТОБУСЫ',
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
