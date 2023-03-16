import 'package:flutter/material.dart';

class NewTransportCardWidget extends StatelessWidget {
  const NewTransportCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказать транспортную карту'),
      ),
    );
  }
}
