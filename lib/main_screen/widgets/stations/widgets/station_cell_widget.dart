import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';

class StationCellWidget extends StatelessWidget {
  const StationCellWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(image: AssetImage(Images.iconStation)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '23 мая',
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
              )
            ],
          )
        ],
      ),
    );
  }
}
