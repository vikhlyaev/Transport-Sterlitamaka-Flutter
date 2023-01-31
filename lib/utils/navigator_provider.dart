import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;

class NavigatorProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final toCenter = StreamController<LatLng>();

  void toMapAndCenterByCoords(LatLng coords) {
    setCurrentIndex(0);
    toCenter.add(coords);
  }
}
