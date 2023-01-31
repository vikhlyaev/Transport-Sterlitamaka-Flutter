import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/track_symbol.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';

class TrackCellBottomSheetWidget extends StatefulWidget {
  const TrackCellBottomSheetWidget({
    Key? key,
    required this.trSymbol,
  }) : super(key: key);

  final TrackSymbol trSymbol;

  @override
  State<TrackCellBottomSheetWidget> createState() =>
      _TrackCellBottomSheetWidgetState();
}

class _TrackCellBottomSheetWidgetState
    extends State<TrackCellBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          onPressed: () => print('add favorite'),
          icon: const Icon(Icons.favorite_border),
        )
      ],
    );
  }
}
