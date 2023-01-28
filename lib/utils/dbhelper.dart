import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/models/scheme.dart';
import 'package:transport_sterlitamaka/models/station.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ?? await _initDB();

  Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'db.db');

// delete existing if any
    await deleteDatabase(path);

// Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

// Copy from asset
    ByteData data = await rootBundle.load(join('assets', 'db.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    return _database = await openDatabase(
      path,
      version: 1,
    );
  }

  Future<List<Station>> getAllStations() async {
    final db = await instance.database;

    final query = await db.query('stations');

    List<Station> stations = query.isNotEmpty ? query.map((station) => Station.fromMap(station)).toList() : [];
    print('[DB]: ${stations.length} stations fetched');
    return stations;
  }

  Future<Station> getDefinedStation(int id) async {
    final db = await instance.database;
    final query = await db.query('stations', where: 'id = ?', whereArgs: [id]);

    return Station.fromMap(query.first);
  }

  Future<List<Route>> getAllRoutes() async {
    final db = await instance.database;

    final query = await db.query('routes');

    List<Route> routes = query.isNotEmpty ? query.map((route) => Route.fromMap(route)).toList() : [];
    print('[DB]: ${routes.length} routes fetched');
    return routes;
  }

  Future<Route> getDefinedRoute(int id) async {
    final db = await instance.database;
    final query = await db.query('routes', where: 'id = ?', whereArgs: [id]);

    return Route.fromMap(query.first);
  }

  Future<List<Scheme>> getAllSchemes() async {
    final db = await instance.database;

    final query = await db.query('schemes');

    List<Scheme> schemes = query.isNotEmpty ? query.map((scheme) => Scheme.fromMap(scheme)).toList() : [];
    print('[DB]: ${schemes.length} schemes fetched');
    return schemes;
  }

  Future<List<Scheme>> getDefinedScheme(int routeName) async {
    final db = await instance.database;
    final query = await db.query('stations', where: 'route_name = ?', whereArgs: [routeName]);

    List<Scheme> schemes = query.isNotEmpty ? query.map((scheme) => Scheme.fromMap(scheme)).toList() : [];

    return schemes;
  }
}
