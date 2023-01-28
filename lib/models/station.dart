class Station {
  Station({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.isFavorite,
  });

  int id;
  double latitude;
  double longitude;
  String name;
  bool isFavorite;
}
