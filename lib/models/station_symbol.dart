import 'package:mapbox_gl/mapbox_gl.dart';

class StationSymbol extends Symbol {
  StationSymbol(super.id, super.options, this.stationId, this.name, [this._data]);

  int? stationId;
  String? name;

  final Map? _data;
  Map? get data => _data;
}
