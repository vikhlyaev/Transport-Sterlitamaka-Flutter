import 'package:equatable/equatable.dart';

class TrackPoint extends Equatable {
  String latitude;
  String longitude;
  String avgSpeed;
  String direction;
  String time;

  TrackPoint({
    required this.latitude,
    required this.longitude,
    required this.avgSpeed,
    required this.direction,
    required this.time,
  });

  TrackPoint.fromMap(Map<String, dynamic> map)
      : latitude = map['latitude'],
        longitude = map['longitude'],
        avgSpeed = map['avg_speed'],
        direction = map['direction'],
        time = map['time'];

  Map<String, dynamic> toMap() =>
      {'latitude': latitude, 'longitude': longitude, 'avg_speed': avgSpeed, 'direction': direction, 'time': time};

  @override
  String toString() => '$latitude:$longitude';

  @override
  List<Object?> get props => [latitude, longitude];
}
