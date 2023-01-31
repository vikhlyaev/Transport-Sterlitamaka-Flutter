class Station {
  int id;
  double latitude;
  double longitude;
  String name;
  int isFavorite;

  Station({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.isFavorite,
  });

  Station.fromMap(Map<String, dynamic> station)
      : id = station['id'] as int,
        latitude = station['latitude'] as double,
        longitude = station['longitude'] as double,
        name = station['name'] as String,
        isFavorite = station['isFavorite'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'isFavorite': isFavorite,
    };
  }
}
