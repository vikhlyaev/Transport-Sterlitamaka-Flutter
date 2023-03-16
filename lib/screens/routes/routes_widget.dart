import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/screens/routes/widgets/route_button_widget.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';

class RoutesWidget extends StatelessWidget {
  const RoutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, crossAxisSpacing: 16, mainAxisSpacing: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршруты'),
      ),
      body: FutureBuilder(
        future: DBHelper.instance.routes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final trolleybuses =
                snapshot.data!.where((e) => e.name < 30).toList();
            final buses = snapshot.data!.where((e) => e.name > 30).toList();
            return ListView(
              padding: const EdgeInsets.all(16.0),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Text(
                  'ТРОЛЛЕЙБУСЫ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: delegate,
                  itemCount: trolleybuses.length,
                  itemBuilder: (context, index) =>
                      RouteButtonWidget(route: trolleybuses[index]),
                ),
                const SizedBox(height: 32),
                Text(
                  'АВТОБУСЫ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: delegate,
                  itemCount: buses.length,
                  itemBuilder: (context, index) =>
                      RouteButtonWidget(route: buses[index]),
                ),
              ],
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
