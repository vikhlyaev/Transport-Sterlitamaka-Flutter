import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/models/track_symbol.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';

class TrackBottomSheet extends StatefulWidget {
  final TrackSymbol trSymbol;
  final List<m.Route> routes;

  const TrackBottomSheet({super.key, required this.trSymbol, required this.routes});

  @override
  State<TrackBottomSheet> createState() => _TrackBottomSheetState();
}

class _TrackBottomSheetState extends State<TrackBottomSheet> {
  late bool isFavorite;

  void _onTap() {
    if (isFavorite) {
      final updatedRoute = widget.routes.where((e) => e.name.toString() == widget.trSymbol.route).first;
      updatedRoute.isFavorite = 0;
      context.read<FavoritesProvider>().removeRoute(updatedRoute);
    } else {
      final updatedRoute = widget.routes.where((e) => e.name.toString() == widget.trSymbol.route).first;
      updatedRoute.isFavorite = 1;
      context.read<FavoritesProvider>().addRoute(updatedRoute);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    isFavorite = context
        .read<FavoritesProvider>()
        .favoriteRoutes
        .where((e) => e.name.toString() == widget.trSymbol.route)
        .isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(widget.trSymbol.vehicleType == VehicleType.TROLLEYBUS
                    ? Images.iconTrolleybusList
                    : Images.iconBusList),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.trSymbol.vehicleType == VehicleType.TROLLEYBUS ? 'Троллейбус' : 'Маршрутка'} ${widget.trSymbol.route}',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Остановка общ. транспорта',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: _onTap,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              )
            ],
          ),
        ],
      ),
    );
  }
}
