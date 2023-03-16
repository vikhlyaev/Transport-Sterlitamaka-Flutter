import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_sterlitamaka/main_bottom_bar_widget.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

import 'utils.dart';

void main() {
  final mapBarTitleFinder = find.byIcon(Icons.map);
  final stationsBarTitleFinder = find.byIcon(Icons.directions_bus);
  final routesBarTitleFinder = find.byIcon(Icons.route);
  final favoritesBarTitleFinder = find.byIcon(Icons.favorite);

  testWidgets('check visibility', (tester) async {
    final navProvider = NavigatorProvider();
    final favProvider = FavoritesProvider();
    await tester.pumpWidget(
      widgetWithMaterialWithFavProvider(
        child: const MainBottomBarWidget(),
        favProvider: favProvider,
        navProvider: navProvider,
      ),
    );
    await tester.pump();

    expect(mapBarTitleFinder, findsOneWidget);
    expect(stationsBarTitleFinder, findsOneWidget);
    expect(routesBarTitleFinder, findsOneWidget);
    expect(favoritesBarTitleFinder, findsOneWidget);
  });

  testWidgets('check onTap callback', (tester) async {
    final navProvider = NavigatorProvider();
    final favProvider = FavoritesProvider();
    await tester.pumpWidget(
      widgetWithMaterialWithFavProvider(
        child: const MainBottomBarWidget(),
        favProvider: favProvider,
        navProvider: navProvider,
      ),
    );
    await tester.pump();

    expect(navProvider.currentIndex, 0);

    await tester.tap(stationsBarTitleFinder);
    await tester.pump();

    expect(navProvider.currentIndex, 1);

    await tester.tap(routesBarTitleFinder);
    await tester.pump();

    expect(navProvider.currentIndex, 2);

    await tester.tap(favoritesBarTitleFinder);
    await tester.pump();

    expect(navProvider.currentIndex, 3);

    await tester.tap(mapBarTitleFinder);
    await tester.pump();

    expect(navProvider.currentIndex, 0);
  });
}
