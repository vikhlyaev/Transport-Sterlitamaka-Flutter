import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;

/// [NavigatorProvider] - провайдер для программного переключения нижнего меню,
/// отцентровки карты по определенным координатам и отображения определенного маршрута
///
/// Для отцентровки и отображения определенных маршрутов провайдер и карта взаимодействуют со стримом:
/// 1. На странице изубранных остановок нажимаем на остановку, вызывая метод `toMapAndCenterByCoords()`,
/// который переключает вкладку на карту и пробрасывает в стрим значение `LatLng`.
/// 1. Виджет карты `MapsWidget` получает событие с координатами и отцентровывает карту.
class NavigatorProvider with ChangeNotifier {
  int _currentIndex = 0;
  int _currentRoute = 0;

  int get currentIndex => _currentIndex;
  int get currentRoute => _currentRoute;

  final toCenter = StreamController<LatLng>();

  final definedRoute = StreamController<int>();

  /// Установить определенный индекс для нижнего меню (переключение вкладки)
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Переключение на карту и отцентровка по координатам.
  void toMapAndCenterByCoords(LatLng coords) {
    if (_currentIndex != 0) {
      setCurrentIndex(0);
    }
    toCenter.add(coords);
  }

  /// Если переданное значение равно нулю, то переключает на карту и показывает все маршруты, в противном случае,
  /// открывает карту и показывает только те транспортные символы, чей маршрут равен переданному.
  void toMapAndShowDefinedRoute(m.Route route) {
    if (_currentRoute != route.name) {
      if (_currentIndex != 0) {
        setCurrentIndex(0);
      }
      _currentRoute = route.name;
      definedRoute.add(route.name);
    } else {
      if (_currentIndex != 0) {
        setCurrentIndex(0);
      }
      _currentRoute = 0;
      definedRoute.add(0);
    }
    notifyListeners();
  }
}
