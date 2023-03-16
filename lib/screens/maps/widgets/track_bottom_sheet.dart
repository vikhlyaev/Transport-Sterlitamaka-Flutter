import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/models/track_symbol.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/screens/maps/widgets/station_cell_bottom_sheet_widget.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';

class TrackBottomSheet extends StatefulWidget {
  final TrackSymbol trSymbol;
  final List<m.Route> routes;

  const TrackBottomSheet(
      {super.key, required this.trSymbol, required this.routes});

  @override
  State<TrackBottomSheet> createState() => _TrackBottomSheetState();
}

class _TrackBottomSheetState extends State<TrackBottomSheet> {
  late bool isFavorite;
  late m.Route currentRoute;
  late List<ListTile> tiles;

  @override
  void initState() {
    isFavorite = context
        .read<FavoritesProvider>()
        .favoriteRoutes
        .where((e) => e.name.toString() == widget.trSymbol.route)
        .isNotEmpty;
    currentRoute = widget.routes
        .where((e) => e.name.toString() == widget.trSymbol.route)
        .first;
    super.initState();
  }

  Future<List<Widget>> getStations() async {
    final stations = <Station>[];

    for (final uuid in currentRoute.desc) {
      stations.add(await DBHelper.instance.getDefinedStation(int.parse(uuid)));
    }

    return stations
        .map((e) => StationCellBottomSheetWidget.bottomSheet(station: e))
        .toList();
  }

  void _onTap() {
    if (isFavorite) {
      currentRoute.isFavorite = 0;
      context.read<FavoritesProvider>().removeRoute(currentRoute);
    } else {
      currentRoute.isFavorite = 1;
      context.read<FavoritesProvider>().addRoute(currentRoute);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(
                    widget.trSymbol.vehicleType == VehicleType.TROLLEYBUS
                        ? Images.iconTrolleybusList
                        : Images.iconBusList),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.trSymbol.route ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.trSymbol.vehicleType == VehicleType.TROLLEYBUS
                          ? 'Троллейбус'
                          : 'Маршрутка',
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
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'ОСТАНОВКИ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: FutureBuilder(
                future: getStations(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => snapshot.data![index],
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
