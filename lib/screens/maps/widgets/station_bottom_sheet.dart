import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/models/station_symbol.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/screens/maps/widgets/route_button_bottom_sheet_widget.dart';
import 'package:transport_sterlitamaka/screens/routes/widgets/route_button_widget.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';

class StationBottomSheet extends StatefulWidget {
  final StationSymbol stSymbol;
  final List<Station> stations;

  const StationBottomSheet(
      {super.key, required this.stSymbol, required this.stations});

  @override
  State<StationBottomSheet> createState() => _StationBottomSheetState();
}

class _StationBottomSheetState extends State<StationBottomSheet> {
  late bool isFavorite;
  void _onTap() {
    if (isFavorite) {
      final updatedStation =
          widget.stations.where((e) => e.id == widget.stSymbol.stationId).first;
      updatedStation.isFavorite = 0;
      context.read<FavoritesProvider>().removeStation(updatedStation);
    } else {
      final updatedStation =
          widget.stations.where((e) => e.id == widget.stSymbol.stationId).first;
      updatedStation.isFavorite = 1;
      context.read<FavoritesProvider>().addStation(updatedStation);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<List<RouteButtonBottomSheetWidget>> getRoutes() async {
    var definedRoutes = await DBHelper.instance.routes;
    definedRoutes = definedRoutes
        .where((e) => e.desc.contains(widget.stSymbol.stationId.toString()))
        .toList();

    return definedRoutes
        .map((e) => RouteButtonBottomSheetWidget(route: e))
        .toList();
  }

  @override
  void initState() {
    isFavorite = context
        .read<FavoritesProvider>()
        .favoriteStations
        .where((e) => e.id == widget.stSymbol.stationId)
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Image(image: AssetImage(Images.iconStationList)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stSymbol.name ?? 'Безымянная',
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
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'МАРШРУТЫ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: FutureBuilder(
                future: getRoutes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8, crossAxisSpacing: 16),
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
