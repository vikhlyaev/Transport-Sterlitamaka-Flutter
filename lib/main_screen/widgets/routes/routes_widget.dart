import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class RoutesWidget extends StatelessWidget {
  const RoutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршруты'),
      ),
      body: Container(
        child: ListView(
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
      ),
    );
  }
}

class RouteButtonWidget extends StatelessWidget {
  const RouteButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: UserColors.blue,
            style: BorderStyle.solid,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4)),
      height: 60,
      width: 60,
      child: const Center(
        child: Text(
          '1',
          style: TextStyle(
            fontSize: 24,
            color: UserColors.blue,
          ),
        ),
      ),
    );
  }
}
