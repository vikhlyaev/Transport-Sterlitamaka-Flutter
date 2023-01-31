import 'package:transport_sterlitamaka/models/station.dart';

class Route {
  int id;
  int name;
  String descId;
  bool isFavorite;

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
        isFavorite = route['isFavorite'] == 1 ? true : false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc_id': descId,
      'isFavorite': isFavorite,
    };
  }

  List<String> get desc => descId.split(' - ');
}
