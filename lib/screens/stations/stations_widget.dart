import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';

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
      body: FutureBuilder(
        future: DBHelper.instance.stations,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 65),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return StationCellWidget(
                        station: snapshot.data![index],
                      );
                    },
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
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
