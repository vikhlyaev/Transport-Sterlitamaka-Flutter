import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class RouteButtonWidget extends StatelessWidget {
  const RouteButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: UserColors.blue,
            style: BorderStyle.solid,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4)),
      height: 60,
      width: 60,
      child: const Center(
        child: Text(
          '1',
          style: TextStyle(
            fontSize: 24,
            color: UserColors.blue,
          ),
        ),
      ),
    );
  }
}
