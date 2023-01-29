import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/tracks.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class APIHelperException implements Exception {
  String cause;

  APIHelperException(this.cause);
}

abstract class APIHelper {
  static final _options = BaseOptions(
    baseUrl: 'http://${Secrets.API_IP}:${Secrets.API_PORT}',
    headers: {'Authorization': Secrets.AUTH_SECRET},
  );
  static final _dio = Dio(_options);
  static IOWebSocketChannel? _socket;

  static Future<Tracks> getInitialCoords() async {
    final response = await _dio.get(Secrets.REST_ENDPOINT);

    if (response.statusCode == 200) {
      final tracks = Tracks.fromMap(response.data);
      await connectToServer();
      print(
          '[API]: ${tracks.tracks.where((element) => element.vehicleType == VehicleType.TROLLEYBUS).length} trolleybuses and ${tracks.tracks.where((element) => element.vehicleType == VehicleType.BUS).length} buses');
      return tracks;
    } else {
      throw APIHelperException('Ошибка сервера');
    }
  }

  static Future<void> connectToServer() async {
    _socket = IOWebSocketChannel.connect('ws://${Secrets.API_IP}:${Secrets.API_PORT}${Secrets.WS_ENDPOINT}',
        headers: {'Authorization': Secrets.AUTH_SECRET});

    _socket?.stream.listen((event) {
      // print(event);
      final tracks = Tracks.fromMap(jsonDecode(event));

      print('[Socket]: ${tracks.tracks.first.toString()}');
    });
  }

  static Future<void> closeConnection() async {
    _socket?.sink.close(status.goingAway);
  }
}
