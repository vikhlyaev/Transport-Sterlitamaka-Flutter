import 'dart:developer' as d;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/models/scheme_point.dart';
import 'package:transport_sterlitamaka/models/station.dart';

/// [DBHelper] - сервис для работы с базой данных.
class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;
  static List<Station>? _stations;
  static List<SchemePoint>? _schemes;
  static List<Route>? _routes;

  /// Возвращает список станции, если запрос первый, то сервис достает их из БД с помощью query-запроса.
  Future<List<Station>> get stations async =>
      _stations ?? await _getAllStations();

  /// Возвращает список схем, если запрос первый, то сервис достает их из БД с помощью query-запроса.
  Future<List<SchemePoint>> get schemes async =>
      _schemes ?? await _getAllSchemes();

  /// Возвращает список маршрутов, если запрос первый, то сервис достает их из БД с помощью query-запроса.
  Future<List<Route>> get routes async => _routes ?? await _getAllRoutes();

  /// При вызове геттера `database`, инициализирует базу данных:
  /// 1. Если не была инициализирована и БД нет во внутренних файлах приложения, то он копирует новую из директории `assets/`.
  /// 1. Если не была инициализирована, но БД присутствует во внутренних файлах приложения, то сервис продолжает работать с ней.
  /// 1. Если БД была инициализирована, то сервис вернет ее.
  Future<Database> get database async => _database ?? await _initDB();

  Future<Database> _initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'db.db');
    // Если в директории баз данных приложения (речь идет не про ассеты) есть база, значит открываем ее,
    // в противном случае - копируем из ассетов новую (пустую)
    if (!File.fromUri(Uri(path: path)).existsSync()) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      final data = await rootBundle.load(join('assets', 'db.db'));
      final bytes =
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
    d.log('${_stations?.length ?? "0"} stations fetched', name: 'DB');

    return stations;
  }

  /// Запрос на список остановок из БД, которые имеют флаг `isFavorite` со значением `1`.
  Future<List<Station>> getFavoriteStations() async {
    final db = await instance.database;
    final query = await db.query('stations', where: 'isFavorite = 1');

    return query.map((e) => Station.fromMap(e)).toList();
  }

  /// Запрос на определенную остановку по ее уникальному идентификатору.
  Future<Station> getDefinedStation(int id) async {
    final db = await instance.database;
    final query = await db.query('stations', where: 'id = ?', whereArgs: [id]);

    return Station.fromMap(query.first);
  }

  /// Обновление остановки в БД
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
    d.log('${_routes?.length ?? "0"} routes fetched', name: 'DB');
    return routes;
  }

  /// Запрос на определенный маршрут по его уникальному идентификатору.
  Future<Route> getDefinedRoute(int id) async {
    final db = await instance.database;
    final query = await db.query('routes', where: 'id = ?', whereArgs: [id]);

    return Route.fromMap(query.first);
  }

  /// Обновление маршрута в БД.
  Future<void> updateRoute(Route route) async {
    final db = await instance.database;
    await db.update('routes', route.toMap(),
        where: 'id = ?', whereArgs: [route.id]);
  }

  /// Запрос на список маршрутов из БД, которые имеют флаг `isFavorite` со значением `1`.
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
    d.log('${_schemes?.length ?? "0"} schemes fetched', name: 'DB');
    return schemes;
  }

  /// Запрос на список точек схемы маршрута по названию маршрута.
  Future<List<SchemePoint>> getDefinedScheme(int routeName) async {
    final db = await instance.database;
    final query = await db
        .query('schemes', where: 'route_name = ?', whereArgs: [routeName]);
    var schemes = <SchemePoint>[];
    schemes = query.isNotEmpty
        ? query.map((scheme) => SchemePoint.fromMap(scheme)).toList()
        : [];

    return schemes;
  }
}
