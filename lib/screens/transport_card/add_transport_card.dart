import 'package:flutter/material.dart';

class AddTransportCardWidget extends StatelessWidget {
  const AddTransportCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Транспортная карта'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/add-card/existing'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_card),
                    SizedBox(height: 4),
                    Text('Добавить существующую карту'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/add-card/new'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_card),
                    SizedBox(height: 4),
                    Text('Заказать новую карту'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
