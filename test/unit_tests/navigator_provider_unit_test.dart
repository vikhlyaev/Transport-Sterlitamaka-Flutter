import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

void main() {
  final provider = NavigatorProvider();
  const coords = LatLng(55, 54);
  final route = Route(id: 1, name: 6, descId: 'descId', isFavorite: 0);

  test('check index setter and getter', () async {
    expect(provider.currentIndex, 0);

    provider.setCurrentIndex(2);

    expect(provider.currentIndex, 2);
  });
  test('check toCenter stream and navigate to map widget', () async {
    provider.toCenter.stream.listen((coordsFromStream) {
      expect(coordsFromStream, coords);
    });
    provider.toMapAndCenterByCoords(coords);

    expect(provider.currentIndex, 0);
  });
  test('check definedRoute stream and navigate to map widget', () async {
    provider.definedRoute.stream.listen((routeFromStream) {
      expect(routeFromStream, route.name);
    });
    provider.toMapAndShowDefinedRoute(route);

    expect(provider.currentIndex, 0);
  });
}
