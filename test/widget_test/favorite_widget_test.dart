import 'package:flutter_test/flutter_test.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/screens/favorites/favorites_widget.dart';
import 'package:transport_sterlitamaka/screens/routes/widgets/route_button_widget.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

import 'utils.dart';

void main() {
  final stationTitleFinder = find.text('ОСТАНОВКИ');
  final routesTitleFinder = find.text('МАРШРУТЫ');
  final routeButtonWidgetFinder = find.byType(RouteButtonWidget);
  final stationCellWidgetFinder = find.byType(StationCellWidget);

  final provider = FavoritesProvider();

  final favStations = <Station>[
    Station(
        id: 1,
        latitude: 55,
        longitude: 55,
        name: 'Some station #1',
        desc: '',
        isFavorite: 1),
    Station(
        id: 2,
        latitude: 55,
        longitude: 55,
        name: 'Some station #2',
        desc: '',
        isFavorite: 1),
    Station(
        id: 3,
        latitude: 55,
        longitude: 55,
        name: 'Some station #3',
        desc: '',
        isFavorite: 1),
  ];
  final favRoutes = <Route>[
    Route(id: 1, name: 6, descId: '', isFavorite: 1),
    Route(id: 2, name: 7, descId: '', isFavorite: 1),
    Route(id: 3, name: 8, descId: '', isFavorite: 1),
  ];
  testWidgets('favorite_widget_test', (tester) async {
    await tester.pumpWidget(
      widgetWithMaterialWithFavProvider(
          child: const FavoritesWidget(),
          favProvider: provider,
          navProvider: NavigatorProvider()),
    );
    await tester.pumpAndSettle();

    expect(stationTitleFinder, findsOneWidget);
    expect(routesTitleFinder, findsOneWidget);
    expect(stationCellWidgetFinder, findsNothing);
    expect(routeButtonWidgetFinder, findsNothing);

    provider.addStations(favStations);
    provider.addRoutes(favRoutes);

    await tester.pump();

    expect(stationCellWidgetFinder, findsWidgets);
    expect(routeButtonWidgetFinder, findsWidgets);
  });
}
