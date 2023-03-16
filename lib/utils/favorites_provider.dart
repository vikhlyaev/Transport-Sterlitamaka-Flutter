import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';

/// [FavoritesProvider] - провайдер, который помогает с добавлением/удаление остановок/маршрутов в избранные.
/// Добавляет/удаляет как в UI, так и в БД.
class FavoritesProvider with ChangeNotifier {
  final List<Station> favoriteStations = [];
  final List<m.Route> favoriteRoutes = [];

  final DBHelper? db;

  FavoritesProvider({this.db});

  /// Изначальное добавление в список при загрузки приложения.
  void addStations(List<Station> stations) {
    favoriteStations.addAll(stations);
    notifyListeners();
  }

  /// Добавление остановки в избранные (UI+БД).
  void addStation(Station station) {
    favoriteStations.add(station);
    d.log('stationList: ${favoriteStations.length}', name: 'FavoritesProvider');
    notifyListeners();
    db?.updateStation(station);
  }

  /// Удаление остановки из избранных (UI+БД).
  void removeStation(Station station) {
    favoriteStations.removeWhere((e) => e == station);
    db?.updateStation(station);
    notifyListeners();
  }

  /// Добавление маршрута в избранные (UI+БД).
  void addRoute(m.Route route) {
    favoriteRoutes.add(route);
    d.log('routeList: ${favoriteRoutes.length}', name: 'FavoritesProvider');
    db?.updateRoute(route);
    notifyListeners();
  }

  /// Удаление маршрута из избранных (UI+БД).
  void removeRoute(m.Route route) {
    favoriteRoutes.removeWhere((e) => e == route);
    db?.updateRoute(route);
    notifyListeners();
  }

  void addRoutes(List<m.Route> route) {
    favoriteRoutes.addAll(route);
    notifyListeners();
  }
}
