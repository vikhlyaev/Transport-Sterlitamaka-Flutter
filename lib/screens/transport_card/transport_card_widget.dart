import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/screens/transport_card/widgets/transactions_cell_widget.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class TransportCardWidget extends StatelessWidget {
  const TransportCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Транспортная карта'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'БАЛАНС',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '№ 636F176C',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: UserColors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Column(
                  children: const [
                    Text(
                      '245',
                      style: TextStyle(
                          height: 1,
                          fontSize: 96,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -2,
                          color: Colors.white),
                    ),
                    Text(
                      'рублей',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'ПОСЛЕДНИЕ ТРАНЗАКЦИИ',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const TransactionsCellWidget();
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFFD9D9D9),
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
