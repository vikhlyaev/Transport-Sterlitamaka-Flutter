// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

/// [TrackPoint] - объектное представление координатной точки транспорта.
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
      : latitude = map['latitude'] as String,
        longitude = map['longitude'] as String,
        avgSpeed = map['avg_speed'] as String,
        direction = map['direction'] as String,
        time = map['time'] as String;

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'avg_speed': avgSpeed,
        'direction': direction,
        'time': time
      };

  @override
  String toString() => '$latitude:$longitude';

  @override
  List<Object?> get props => [latitude, longitude];
}
