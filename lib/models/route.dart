import 'package:transport_sterlitamaka/models/scheme_point.dart';

/// [Route] - объектное представление маршрута.
class Route {
  int id;
  int name;
  String descId;
  List<SchemePoint>? schemePoints;
  int isFavorite;

  Route({
    required this.id,
    required this.name,
    required this.descId,
    required this.isFavorite,
  });

  Route.fromMap(Map<String, dynamic> route)
      : id = route['id'] as int,
        name = route['name'] as int,
        descId = route['desc_id'] as String,
        isFavorite = route['isFavorite'] as int;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc_id': descId,
      'isFavorite': isFavorite,
    };
  }

  List<String> get desc => descId.split(' - ');

  @override
  String toString() => '$name: $id';
}
