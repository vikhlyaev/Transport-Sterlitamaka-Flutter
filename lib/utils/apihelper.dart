import 'package:dio/dio.dart';
import 'package:transport_sterlitamaka/models/tracks.dart';
import 'package:transport_sterlitamaka/secrets.dart';

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

  static Future<Tracks> getInitialCoords() async {
    final response = await _dio.get('/start');

    if (response.statusCode == 200) {
      final tracks = Tracks.fromMap(response.data);
      print('[API]: ${tracks.tracks.length} tracks fetched');
      return tracks;
    } else {
      throw APIHelperException('Ошибка сервера');
    }
  }
}
