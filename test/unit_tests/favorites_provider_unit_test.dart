import 'package:flutter_test/flutter_test.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';

void main() {
  final provider = FavoritesProvider();

  tearDown(() {
    provider.favoriteStations.clear();
    provider.favoriteRoutes.clear();
  });

  test('add list of stations', () async {
    final stations = <Station>[
      Station(
          id: 1,
          latitude: 55,
          longitude: 55,
          name: 'Some station #1',
          desc: '',
          isFavorite: 0),
      Station(
          id: 2,
          latitude: 55,
          longitude: 55,
          name: 'Some station #2',
          desc: '',
          isFavorite: 0),
      Station(
          id: 3,
          latitude: 55,
          longitude: 55,
          name: 'Some station #3',
          desc: '',
          isFavorite: 0),
    ];

    provider.addStations(stations);

    expect(provider.favoriteStations.length, stations.length);
  });
  test('add one station', () async {
    final station = Station(
        id: 1,
        latitude: 55,
        longitude: 55,
        name: 'Some station #1',
        desc: '',
        isFavorite: 0);

    provider.addStation(station);

    expect(provider.favoriteStations.where((e) => e.id == 1).length, 1);
  });
  test('remove station', () async {
    final station = Station(
        id: 1,
        latitude: 55,
        longitude: 55,
        name: 'Some station #1',
        desc: '',
        isFavorite: 0);

    provider.addStation(station);

    expect(provider.favoriteStations.where((e) => e.id == 1).length, 1);

    provider.removeStation(station);

    expect(provider.favoriteStations.where((e) => e.id == 1).length, 0);
  });
  test('add list of routes', () async {
    final routes = <Route>[
      Route(id: 1, name: 6, descId: '', isFavorite: 0),
      Route(id: 2, name: 7, descId: '', isFavorite: 0),
      Route(id: 3, name: 8, descId: '', isFavorite: 0),
    ];

    provider.addRoutes(routes);

    expect(provider.favoriteRoutes.length, routes.length);
  });
  test('add one route', () async {
    final route = Route(id: 1, name: 6, descId: '', isFavorite: 0);

    provider.addRoute(route);

    expect(provider.favoriteRoutes.where((e) => e.id == 1).length, 1);
  });
  test('remove route', () async {
    final route = Route(id: 1, name: 6, descId: '', isFavorite: 0);

    provider.addRoute(route);

    expect(provider.favoriteRoutes.where((e) => e.id == 1).length, 1);

    provider.removeRoute(route);

    expect(provider.favoriteRoutes.where((e) => e.id == 1).length, 0);
  });
}
