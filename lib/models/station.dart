/// [Station] - объектное представление транспортной остановки.
class Station {
  int id;
  double latitude;
  double longitude;
  String name;
  String desc;
  int isFavorite;

  Station({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.desc,
    required this.isFavorite,
  });

  Station.fromMap(Map<String, dynamic> station)
      : id = station['id'] as int,
        latitude = station['latitude'] as double,
        longitude = station['longitude'] as double,
        name = station['name'] as String,
        desc = station['desc'] as String,
        isFavorite = station['isFavorite'] as int;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'desc': desc,
      'isFavorite': isFavorite,
    };
  }
}
