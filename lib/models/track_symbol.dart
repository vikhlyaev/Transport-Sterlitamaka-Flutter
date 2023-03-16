import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/enums.dart';

/// [TrackSymbol] - символ, представляющий транспорт на карте.
class TrackSymbol extends Symbol {
  TrackSymbol(
      super.id, super.options, this.trackId, this.route, this.vehicleType,
      [this._data]);

  int? trackId;
  String? route;
  VehicleType? vehicleType;

  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data => _data;
}
