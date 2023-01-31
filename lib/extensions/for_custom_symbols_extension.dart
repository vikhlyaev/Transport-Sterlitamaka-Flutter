import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/station_symbol.dart';
import 'package:transport_sterlitamaka/models/station_symbol_options.dart';
import 'package:transport_sterlitamaka/models/track_symbol.dart';
import 'package:transport_sterlitamaka/models/track_symbol_options.dart';

/// Расширение класса `MapboxMapController` - добавили отдельные методы для кастомных маркеров.
/// Маркер забирает в себя необходимый свойства из `SymbolOptions`, например id остановки и ее название
extension forCustomSymbols on MapboxMapController {
  Future<List<StationSymbol>> addStationSymbols(
      List<StationSymbolOptions> options,
      [List<Map>? data]) async {
    final symbols = [
      for (var i = 0; i < options.length; i++)
        StationSymbol(
            getRandomString(),
            SymbolOptions.defaultOptions.copyWith(options[i]),
            options[i].id,
            options[i].name,
            options[i].isFavorite,
            data?[i])
    ];
    await symbolManager!.addAll(symbols);

    notifyListeners();
    return symbols;
  }

  Future<List<TrackSymbol>> addTrackSymbols(List<TrackSymbolOptions> options,
      [List<Map>? data]) async {
    final symbols = [
      for (var i = 0; i < options.length; i++)
        TrackSymbol(
            getRandomString(),
            SymbolOptions.defaultOptions.copyWith(options[i]),
            options[i].id,
            options[i].route,
            options[i].vehicleType,
            data?[i])
    ];
    await symbolManager!.addAll(symbols);

    notifyListeners();
    return symbols;
  }
}
