import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/models/station_symbol.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';

class StationCellBottomSheetWidget extends StatefulWidget {
  const StationCellBottomSheetWidget({
    Key? key,
    required this.stSymbol,
  }) : super(key: key);

  final StationSymbol stSymbol;

  @override
  State<StationCellBottomSheetWidget> createState() =>
      _StationCellBottomSheetWidgetState();
}

class _StationCellBottomSheetWidgetState
    extends State<StationCellBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          onPressed: () => print('add favorite'),
          icon: const Icon(Icons.favorite_border),
        )
      ],
    );
  }
}
