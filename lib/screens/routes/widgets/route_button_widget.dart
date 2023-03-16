import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

class RouteButtonWidget extends StatelessWidget {
  final m.Route route;

  const RouteButtonWidget({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
            backgroundColor: MaterialStatePropertyAll(
                context.watch<NavigatorProvider>().currentRoute == route.name
                    ? UserColors.blue.withOpacity(0.7)
                    : Colors.white),
          ),
      onPressed: () =>
          context.read<NavigatorProvider>().toMapAndShowDefinedRoute(route),
      child: Text(
        route.name.toString(),
        style: const TextStyle(
          fontSize: 18,
          color: UserColors.blue,
        ),
      ),
    );
  }
}
