import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/theme/app_theme.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

Widget widgetWithMaterial({required Widget child}) {
  return MaterialApp(
    locale: const Locale('ru'),
    theme: AppTheme().light,
    home: Scaffold(
      body: child,
    ),
  );
}

Widget widgetWithMaterialWithFavProvider<T>(
    {required Widget child,
    required FavoritesProvider favProvider,
    required NavigatorProvider navProvider}) {
  return ChangeNotifierProvider(
    create: (context) => navProvider,
    child: ChangeNotifierProvider(
      create: (context) => favProvider,
      child: MaterialApp(
        locale: const Locale('ru'),
        theme: AppTheme().light,
        home: Scaffold(
          body: child,
        ),
      ),
    ),
  );
}
