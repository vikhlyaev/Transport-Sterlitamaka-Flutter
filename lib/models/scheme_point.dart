/// [SchemePoint] - объектное представление точки маршрута,
/// которые в будущем объединятся в схему определенного маршрута [Route].
class SchemePoint {
  int routeName;
  double pointLatitude;
  double pointLongitude;

  SchemePoint({
    required this.routeName,
    required this.pointLatitude,
    required this.pointLongitude,
  });

  SchemePoint.fromMap(Map<String, dynamic> scheme)
      : routeName = scheme['route_name'] as int,
        pointLatitude = scheme['point_latitude'] as double,
        pointLongitude = scheme['point_longitude'] as double;

  Map<String, dynamic> toMap() {
    return {
      'route_name': routeName,
      'point_latitude': pointLatitude,
      'point_longitude': pointLongitude,
    };
  }
}
