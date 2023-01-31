import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/models/scheme_point.dart';
import 'package:transport_sterlitamaka/models/station.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  static List<Station>? _stations;
  static List<SchemePoint>? _schemes;
  static List<Route>? _routes;

  Future<List<Station>> get stations async =>
      _stations ?? await _getAllStations();

  Future<List<SchemePoint>> get schemes async =>
      _schemes ?? await _getAllSchemes();

  Future<List<Route>> get routes async => _routes ?? await _getAllRoutes();

  Future<Database> get database async => _database ?? await _initDB();

  Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'db.db');
    // Если в директории баз данных приложения (речь идет не про ассеты) есть база, значит открываем ее,
    // в противном случае - копируем из ассетов новую (пустую)
    if (!File.fromUri(Uri(path: path)).existsSync()) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', 'db.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return _database = await openDatabase(
      path,
      version: 1,
    );
  }

  Future<List<Station>> _getAllStations() async {
    final db = await instance.database;
    final query = await db.query('stations');

    _stations = query.isNotEmpty
        ? query.map((station) => Station.fromMap(station)).toList()
        : [];
    print('[DB]: ${_stations?.length ?? "0"} stations fetched');

    return stations;
  }

  Future<List<Station>> getFavoriteStations() async {
    final db = await instance.database;
    final query = await db.query('stations', where: 'isFavorite = 1');

    return query.map((e) => Station.fromMap(e)).toList();
  }

  Future<Station> getDefinedStation(int id) async {
    final db = await instance.database;
    final query = await db.query('stations', where: 'id = ?', whereArgs: [id]);

    return Station.fromMap(query.first);
  }

  Future<void> updateStation(Station station) async {
    final db = await instance.database;
    await db.update('stations', station.toMap(),
        where: 'id = ?', whereArgs: [station.id]);
  }

  Future<List<Route>> _getAllRoutes() async {
    final db = await instance.database;

    final query = await db.query('routes');

    _routes = query.isNotEmpty
        ? query.map((route) => Route.fromMap(route)).toList()
        : [];
    print('[DB]: ${_routes?.length ?? "0"} routes fetched');
    return routes;
  }

  Future<Route> getDefinedRoute(int id) async {
    final db = await instance.database;
    final query = await db.query('routes', where: 'id = ?', whereArgs: [id]);

    return Route.fromMap(query.first);
  }

  Future<void> updateRoute(Route route) async {
    final db = await instance.database;
    await db.update('routes', route.toMap(),
        where: 'id = ?', whereArgs: [route.id]);
  }

  Future<List<Route>> getFavoriteRoutes() async {
    final db = await instance.database;
    final query = await db.query('routes', where: 'isFavorite = 1');

    return query.map((e) => Route.fromMap(e)).toList();
  }

  Future<List<SchemePoint>> _getAllSchemes() async {
    final db = await instance.database;

    final query = await db.query('schemes');

    _schemes = query.isNotEmpty
        ? query.map((scheme) => SchemePoint.fromMap(scheme)).toList()
        : [];
    print('[DB]: ${_schemes?.length ?? "0"} schemes fetched');
    return schemes;
  }

  Future<List<SchemePoint>> getDefinedScheme(int routeName) async {
    final db = await instance.database;
    final query = await db
        .query('stations', where: 'route_name = ?', whereArgs: [routeName]);

    List<SchemePoint> schemes = query.isNotEmpty
        ? query.map((scheme) => SchemePoint.fromMap(scheme)).toList()
        : [];

    return schemes;
  }
}
