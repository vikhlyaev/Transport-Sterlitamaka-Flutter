import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/track_symbol.dart';

extension AnimateSymbol on MapboxMapController {
  /// Метод для плавного передвижения маркеров. Необходимо передать символ и свойства,
  /// которые будем менять на протяжении анимации.
  ///
  /// Также необходимо указать стейт виджета, который содержит миксин `TickerProviderStateMixin`.
  void animateSymbol(
      TrackSymbol symbol, LatLng to, double iconRotate, TickerProvider state) {
    final aController = AnimationController(
        vsync: state, duration: const Duration(seconds: 15));

    final animation = LatLngTween(begin: symbol.options.geometry!, end: to)
        .animate(aController);
    animation.addListener(() {
      updateSymbol(symbol,
          SymbolOptions(geometry: animation.value, iconRotate: iconRotate));
    });
    aController.forward();
  }
}

/// [LatLngTween] - класс для корректной работы анимации с парой координат.
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
      : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) => LatLng(
        begin!.latitude + (end!.latitude - begin!.latitude) * t,
        begin!.longitude + (end!.longitude - begin!.longitude) * t,
      );
}
