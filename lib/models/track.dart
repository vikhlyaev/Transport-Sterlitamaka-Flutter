import 'package:equatable/equatable.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/track_point.dart';

class Track extends Equatable {
  String uuid;
  Category category;
  String route;
  VehicleType vehicleType;
  TrackPoint point;

  Track({
    required this.uuid,
    required this.category,
    required this.route,
    required this.vehicleType,
    required this.point,
  });

  Track.fromMap(Map<String, dynamic> map)
      : uuid = map['uuid'],
        category = Category.S,
        route = map['route'] == '433' ? '43' : map['route'],
        vehicleType = map['vehicle_type'] == 'trolleybus' ? VehicleType.TROLLEYBUS : VehicleType.BUS,
        point = TrackPoint.fromMap(map['point']);

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'category': 's',
        'route': route,
        'vehicleType': vehicleType == VehicleType.TROLLEYBUS ? 'trolleybus' : 'bus',
        'point': point.toMap()
      };

  @override
  String toString() => 'Транспорт №$route (ID: $uuid): ${point.toString()}';

  @override
  List<Object?> get props => [uuid, category, route, vehicleType, point];
}
