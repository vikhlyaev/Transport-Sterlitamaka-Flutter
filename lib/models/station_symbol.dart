import 'package:mapbox_gl/mapbox_gl.dart';

class StationSymbol extends Symbol {
  StationSymbol(
      super.id, super.options, this.stationId, this.name, this.isFavorite,
      [this._data]);

  int? stationId;
  String? name;
  int? isFavorite;

  final Map? _data;
  Map? get data => _data;
}
