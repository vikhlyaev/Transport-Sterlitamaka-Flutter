import 'package:mapbox_gl/mapbox_gl.dart';

class TrackSymbol extends Symbol {
  TrackSymbol(super.id, super.options, this.trackId, this.route, [this._data]);

  int? trackId;
  String? route;

  final Map? _data;
  Map? get data => _data;
}
