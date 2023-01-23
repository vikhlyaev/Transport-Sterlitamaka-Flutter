import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';

class StationsWidget extends StatefulWidget {
  const StationsWidget({super.key});

  @override
  State<StationsWidget> createState() => _StationsWidgetState();
}

class _StationsWidgetState extends State<StationsWidget> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Остановки'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            ListView.separated(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 65),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              itemBuilder: (context, index) {
                return const StationCellWidget();
              },
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFD9D9D9),
                height: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Укажите название остановки',
                  labelText: 'Поиск',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
