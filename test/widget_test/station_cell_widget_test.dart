import 'package:flutter_test/flutter_test.dart';
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/screens/stations/widgets/station_cell_widget.dart';

import 'utils.dart';

void main() {
  group('station cell widget tests', () {
    const nameOfStation = 'пр. Октября';
    final station = Station(
        id: 0,
        latitude: 55,
        longitude: 54,
        name: nameOfStation,
        desc: '',
        isFavorite: 0);
    final nameOfStationFinder = find.text(nameOfStation);

    testWidgets('simple cell', (tester) async {
      await tester.pumpWidget(
        widgetWithMaterial(
          child: StationCellWidget(station: station),
        ),
      );
      await tester.pumpAndSettle();

      expect(nameOfStationFinder, findsOneWidget);
    });

    testWidgets('cell for bottomsheet', (tester) async {
      await tester.pumpWidget(
        widgetWithMaterial(
          child: StationCellWidget.bottomSheet(station: station),
        ),
      );
      await tester.pumpAndSettle();

      expect(nameOfStationFinder, findsOneWidget);
    });
  });
}
