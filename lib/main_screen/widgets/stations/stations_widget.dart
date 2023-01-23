import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/main_screen/widgets/stations/widgets/station_cell_widget.dart';

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
              padding: const EdgeInsets.only(top: 90),
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
              padding: EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Укажите название остановки',
                  labelText: 'Поиск',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
