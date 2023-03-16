import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

class StationCellWidget extends StatelessWidget {
  final Station station;
  bool isBottomSheet;

  StationCellWidget({
    required this.station,
    this.isBottomSheet = false,
    Key? key,
  }) : super(key: key);

  StationCellWidget.bottomSheet(
      {required this.station, this.isBottomSheet = true, Key? key})
      : super(key: key);

  Widget get leading {
    if (isBottomSheet) {
      return const SizedBox(width: 10);
    } else {
      return const Image(image: AssetImage(Images.iconStationList));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.read<NavigatorProvider>().setCurrentIndex(0);
            context.read<NavigatorProvider>().toMapAndCenterByCoords(
                LatLng(station.latitude, station.longitude));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                leading,
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
                      station.desc,
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
        const Divider(
          color: Color(0xFFD9D9D9),
          height: 1,
        ),
      ],
    );
  }
}
