import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

class StationCellWidget extends StatelessWidget {
  final Station station;

  const StationCellWidget({
    required this.station,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Color(0xFFD9D9D9),
          height: 1,
        ),
        InkWell(
          onTap: () {
            context.read<NavigatorProvider>().setCurrentIndex(0);
            context.read<NavigatorProvider>().toMapAndCenterByCoords(LatLng(station.latitude, station.longitude));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(image: AssetImage(Images.iconStationList)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'в сторону ул. Гоголя',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
