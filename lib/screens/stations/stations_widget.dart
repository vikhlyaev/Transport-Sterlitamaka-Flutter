import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';

class StationsWidget extends StatefulWidget {
  const StationsWidget({super.key});

  @override
  State<StationsWidget> createState() => _StationsWidgetState();
}

class _StationsWidgetState extends State<StationsWidget> {
  final _searchController = TextEditingController();

  late Future<List<Station>> _stations;
  late Future<List<Station>> _filteredStation;

  @override
  void initState() {
    _stations = DBHelper.instance.stations;
    _filteredStation = _stations;
    _searchController.addListener(_searchStation);
    super.initState();
  }

  void _searchStation() async {
    final query = _searchController.text;
    final allStations = await _stations;

    setState(() {
      if (query.isNotEmpty) {
        _filteredStation = Future.value(allStations.where((station) {
          return station.name.toLowerCase().contains(query.toLowerCase());
        }).toList());
      } else {
        _filteredStation = Future.value(allStations);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Остановки'),
      ),
      body: FutureBuilder(
        future: _filteredStation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  ListView.builder(
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
