// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:developer' as d;
import 'package:dio/dio.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/tracks.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

/// [APIHelperException] - кастомная ошибка для сервиса, работающий с API.
class APIHelperException implements Exception {
  String cause;

  APIHelperException(this.cause);
}

/// [APIHelper] - сервис для взаимодействия с удаленным сервером.
abstract class APIHelper {
  static final _options = BaseOptions(
    baseUrl: 'http://${Secrets.API_IP}:${Secrets.API_PORT}',
    headers: {'Authorization': Secrets.AUTH_SECRET},
  );
  static final _dio = Dio(_options);
  static IOWebSocketChannel? _socket;

  /// Получение начальных координат транспорта с сервера
  static Future<Tracks> getInitialCoords() async {
    final response = await _dio.get(Secrets.REST_ENDPOINT);

    if (response.statusCode == 200) {
      final tracks = Tracks.fromMap(response.data as Map<String, dynamic>);
      d.log(
          '${tracks.tracks.where((element) => element.vehicleType == VehicleType.TROLLEYBUS).length} trolleybuses and ${tracks.tracks.where((element) => element.vehicleType == VehicleType.BUS).length} buses',
          name: 'API');
      return tracks;
    } else {
      throw APIHelperException('Ошибка сервера');
    }
  }

  /// Вебсокет, по которому передается информация по обновлению местоположения транспорта.
  static Stream<dynamic>? webSocketStream() {
    _socket = IOWebSocketChannel.connect(
        'ws://${Secrets.API_IP}:${Secrets.API_PORT}${Secrets.WS_ENDPOINT}',
        headers: {'Authorization': Secrets.AUTH_SECRET});

    return _socket?.stream;
  }

  /// Метод для закрытия сокетного соединения.
  static Future<void> closeConnection() async {
    await _socket?.sink.close(status.goingAway);
  }
}
