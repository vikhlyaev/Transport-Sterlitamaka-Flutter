import 'package:mapbox_gl/mapbox_gl.dart';

/// [StationSymbol] - объектное представление символа остановки.
class StationSymbol extends Symbol {
  StationSymbol(
      super.id, super.options, this.stationId, this.name, this.isFavorite,
      [this._data]);

  int? stationId;
  String? name;
  int? isFavorite;

  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data => _data;
}
