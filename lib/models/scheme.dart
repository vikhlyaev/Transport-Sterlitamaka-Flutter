class Scheme {
  int routeName;
  double pointLatitude;
  double pointLongitude;

  Scheme({
    required this.routeName,
    required this.pointLatitude,
    required this.pointLongitude,
  });

  Scheme.fromMap(Map<String, dynamic> scheme)
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
