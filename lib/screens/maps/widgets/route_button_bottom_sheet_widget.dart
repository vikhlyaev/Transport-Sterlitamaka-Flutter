import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

class RouteButtonBottomSheetWidget extends StatelessWidget {
  final m.Route route;

  bool isBus(m.Route route) {
    if (route.name == 40 || route.name == 41 || route.name == 43) {
      return true;
    }
    return false;
  }

  const RouteButtonBottomSheetWidget({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              isBus(route) ? UserColors.green : UserColors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(20)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(5),
          )),
      onPressed: () =>
          context.read<NavigatorProvider>().toMapAndShowDefinedRoute(route),
      child: Center(
        child: Text(
          route.name.toString(),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
