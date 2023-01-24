import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class MapsWidget extends StatelessWidget {
  const MapsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: UserColors.green,
          ),
          Positioned(
            top: 60,
            right: 16,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/add-card'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(UserColors.blue),
                overlayColor:
                    MaterialStateProperty.all(UserColors.blue.withAlpha(20)),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_card),
                  SizedBox(width: 12),
                  Text('Добавить карту'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 16,
            child: ElevatedButton(
              onPressed: () => print('tap'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(UserColors.blue),
                overlayColor:
                    MaterialStateProperty.all(UserColors.blue.withAlpha(20)),
                minimumSize: MaterialStateProperty.all(
                  const Size(44, 44),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              child: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}
