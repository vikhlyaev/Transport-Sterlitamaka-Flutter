import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/enums.dart';

class TrackSymbol extends Symbol {
  TrackSymbol(
      super.id, super.options, this.trackId, this.route, this.vehicleType,
      [this._data]);

  int? trackId;
  String? route;
  VehicleType? vehicleType;

  final Map? _data;
  Map? get data => _data;
}
