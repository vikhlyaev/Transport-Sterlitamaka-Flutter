import 'package:flutter_test/flutter_test.dart';
import 'package:transport_sterlitamaka/models/route.dart';
import 'package:transport_sterlitamaka/screens/routes/widgets/route_button_widget.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

import 'utils.dart';

void main() {
  final route = Route(id: 0, name: 6, descId: '', isFavorite: 0);
  final routeNameFinder = find.text('6');

  testWidgets('route_button_widget test', (tester) async {
    await tester.pumpWidget(
      widgetWithMaterialWithFavProvider(
          child: RouteButtonWidget(route: route),
          favProvider: FavoritesProvider(),
          navProvider: NavigatorProvider()),
    );
    await tester.pumpAndSettle();

    expect(routeNameFinder, findsOneWidget);
  });
}
