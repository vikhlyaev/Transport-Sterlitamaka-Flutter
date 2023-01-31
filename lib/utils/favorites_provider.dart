import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/utils/dbhelper.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Station> favoriteStations = [];
  final List<m.Route> favoriteRoutes = [];

  void addStations(List<Station> stations) {
    favoriteStations.addAll(stations);
    notifyListeners();
  }

  void addStation(Station station) {
    favoriteStations.add(station);
    print('[FavoritesProvider] stationList: ${favoriteStations.length}');
    notifyListeners();
    DBHelper.instance.updateStation(station);
  }

  void removeStation(Station station) {
    favoriteStations.removeWhere((e) => e == station);
    DBHelper.instance.updateStation(station);
    notifyListeners();
  }

  void addRoute(m.Route route) {
    favoriteRoutes.add(route);
    print('[FavoritesProvider] routeList: ${favoriteRoutes.length}');
    DBHelper.instance.updateRoute(route);
    notifyListeners();
  }

  void removeRoute(m.Route route) {
    favoriteRoutes.removeWhere((e) => e == route);
    DBHelper.instance.updateRoute(route);
    notifyListeners();
  }

  void addRoutes(List<m.Route> route) {
    favoriteRoutes.addAll(route);
    notifyListeners();
  }

  void saveDataToDB() {}
}
