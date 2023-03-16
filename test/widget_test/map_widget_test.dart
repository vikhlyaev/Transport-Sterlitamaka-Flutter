import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/screens/maps/maps_widget.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

import 'utils.dart';

void main() {
  testWidgets('mapbox map widget test', (tester) async {
    await tester.pumpWidget(widgetWithMaterialWithFavProvider(
        child: const MapsWidget(),
        favProvider: FavoritesProvider(),
        navProvider: NavigatorProvider()));

    await tester.pumpAndSettle();

    expect(find.byType(MapboxMap), findsOneWidget);
  });
}
