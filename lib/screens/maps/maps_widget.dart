import 'dart:async';
import 'dart:convert';
import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:transport_sterlitamaka/extensions/animate_symbol_extension.dart';
import 'package:transport_sterlitamaka/extensions/for_custom_symbols_extension.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/route.dart' as m;
import 'package:transport_sterlitamaka/models/station.dart';
import 'package:transport_sterlitamaka/models/station_symbol.dart';
import 'package:transport_sterlitamaka/models/station_symbol_options.dart';
import 'package:transport_sterlitamaka/models/track.dart';
import 'package:transport_sterlitamaka/models/track_symbol.dart';
import 'package:transport_sterlitamaka/models/track_symbol_options.dart';
import 'package:transport_sterlitamaka/models/tracks.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/screens/maps/widgets/station_bottom_sheet.dart';
import 'package:transport_sterlitamaka/screens/maps/widgets/track_bottom_sheet.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:transport_sterlitamaka/theme/map_style.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:transport_sterlitamaka/utils/apihelper.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';
import 'package:transport_sterlitamaka/utils/favorites_provider.dart';
import 'package:transport_sterlitamaka/utils/navigator_provider.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> with TickerProviderStateMixin {
  Position? currentPosition;
  Symbol? _selectedSymbol;
  String? schemeId;
  late MapboxMapController _controller;

  List<Track> tracks = [];
  List<TrackSymbol> trackSymbols = [];
  List<TrackSymbolOptions> tracksSymbolsOptions = [];
  List<Station> stations = [];
  List<m.Route> routes = [];
  Line? schemeLine;

  final MinMaxZoomPreference _minMaxZoomPreference =
      const MinMaxZoomPreference(15.0, 17.0);
  final _attributionRightBottom = const Point(20, 20);
  final _logoRightTop = const Point(-1000, 0);

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  /// Запрос текущей геолокации пользователя:
  ///
  /// 1. Проверка службы геолокации.
  /// 2. Проверка необходимых разрешений.
  ///    * Если разрешения отсутствуют, то просим пользователя разрешить использовать отслеживание.
  /// 3. Запрос текущей геолокации.
  Future<void> _determinePosition() async {
    // проверка службы геолокации
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      d.log('Location services are disabled.', name: 'GEO');
      return;
    }
    // проверка разрешений
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        d.log('Location permissions are denied.', name: 'GEO');
        return;
      }
    }
    // открытие настроек для включения геолокации
    if (permission == LocationPermission.deniedForever) {
      d.log(
          'Location permissions are permanently denied, we cannot request permissions.',
          name: 'GEO');
      await Geolocator.openLocationSettings();
      return;
    }
    // запрос текущей позиции
    final position = await Geolocator.getCurrentPosition();
    d.log('$position', name: 'GEO');
    setState(() {
      currentPosition = position;
    });
  }

  /// Коллбэк на создание карты, подключение к сокету и добавление обработчика нажатий
  Future<void> _onMapCreated(MapboxMapController controller) async {
    _controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);

    APIHelper.webSocketStream()?.listen((event) {
      try {
        final incomingTracks =
            Tracks.fromMap(jsonDecode(event as String) as Map<String, dynamic>)
                .tracks;
        checkForUpdateTrack(incomingTracks);
      } catch (e, stacktrace) {
        d.log('Exception: $e - $stacktrace', name: 'Socket');
      }
    });

    // Подписка на событие смены позиции камеры - для отцентровки выбранной станции
    context.read<NavigatorProvider>().toCenter.stream.listen((coords) {
      _controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: coords)));
    });

    // Подписка на отображение определенного маршрута
    context.read<NavigatorProvider>().definedRoute.stream.listen((routeName) {
      d.log('$routeName', name: 'DefinedRouteStream');
      if (routeName == 0) {
        _addInitialTrackSymbols(byRoute: 0);
      } else {
        _hideTrackSymbols();
        _addInitialTrackSymbols(byRoute: routeName);
        _showScheme(routes.firstWhere((e) => e.name == routeName));
      }
    });

    // Добавление избранных остановок и маршрутов в массив для их отображения в соответствующей вкладке.
    context.read<FavoritesProvider>()
      ..addStations(await DBHelper.instance.getFavoriteStations())
      ..addRoutes(await DBHelper.instance.getFavoriteRoutes());
  }

  /// Обнаруживает транспорт, метку которого необходимо обновить
  void checkForUpdateTrack(List<Track> incomingTracks) {
    // 1. Проходить по пришедшему массиву и сравнивать транспорт в текущем массиве
    // 2. Если координаты поменялись, то вызываем метод обновления метки,
    //    в противном случае пропускаем
    // 2.1. В методе обновления или до него мы должны присваивать текущему массиву новые координаты.
    // 2.2. Должны менять: ротацию и координаты.
    for (var i = 0; i < incomingTracks.length; i++) {
      if (tracks.where((e) => e.uuid == incomingTracks[i].uuid).isNotEmpty) {
        if (incomingTracks[i] !=
            tracks.where((e) => e.uuid == incomingTracks[i].uuid).first) {
          updateTrackSymbol(incomingTracks[i]);
          tracks[tracks.indexOf(tracks
              .where((e) => e.uuid == incomingTracks[i].uuid)
              .first)] = incomingTracks[i];
        }
      }
    }
  }

  /// Обновляет маркер транспорта
  void updateTrackSymbol(Track incomingTrack) {
    d.log('tracks updated', name: 'Socket');
    if (trackSymbols
        .where((e) => e.trackId == int.parse(incomingTrack.uuid))
        .isNotEmpty) {
      final currentSymbol = trackSymbols
          .where((e) => e.trackId == int.parse(incomingTrack.uuid))
          .first;

      _controller.animateSymbol(
          currentSymbol,
          LatLng(double.parse(incomingTrack.point.latitude),
              double.parse(incomingTrack.point.longitude)),
          double.parse(incomingTrack.point.direction),
          this);
      setState(() {});
    }
  }

  /// Коллбэк на подгрузку стилей, грузит необходимые дополнительные ресурсы, устанавливает пользовательскую локацию
  Future<void> _onStyleLoaded() async {
    await addImageFromAsset('station', Images.iconStation);
    await addImageFromAsset('station-active', Images.iconStationActive);
    await addImageFromAsset('trolleybus-stu', Images.iconTrolleybus);
    await addImageFromAsset('bus-stu', Images.iconBus);
    // Add route schemes to _controller
    await _controller.addGeoJsonSource(
        'scheme-7',
        jsonDecode(await rootBundle.loadString('assets/schemes/7.geojson'))
            as Map<String, dynamic>);
    await _addStationSymbols();
    await _addInitialTrackSymbols();
    routes.addAll(await DBHelper.instance.routes);
  }

  /// Обработчик нажатий на маркеры
  void _onSymbolTapped(Symbol symbol) {
    // Изменения к выбранному символу после выбора другой
    if (_selectedSymbol != null) {
      if (_selectedSymbol is StationSymbol) {
        _controller.updateSymbol(
          _selectedSymbol!,
          const SymbolOptions(iconSize: 1.0, iconImage: 'station'),
        );
      } else {
        _controller.updateSymbol(
          _selectedSymbol!,
          const SymbolOptions(iconSize: 1.0, textSize: 16),
        );
      }
    }
    if (symbol is StationSymbol) {
      final stSymbol = symbol;
      _selectedSymbol = stSymbol;
      _controller.updateSymbol(
          stSymbol,
          symbol.options.copyWith(
              const SymbolOptions(iconSize: 0.7, iconImage: 'station-active')));
      showBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) =>
            StationBottomSheet(stSymbol: stSymbol, stations: stations),
      ).closed.whenComplete(() {
        _controller.updateSymbol(
          _selectedSymbol!,
          const SymbolOptions(iconSize: 1.0, iconImage: 'station'),
        );
      });
    } else if (symbol is TrackSymbol) {
      final trSymbol = symbol;
      final route =
          routes.firstWhere((e) => e.name.toString() == trSymbol.route);
      _selectedSymbol = trSymbol;
      _controller.updateSymbol(
        trSymbol,
        const SymbolOptions(iconSize: 1.5, textSize: 18),
      );
      _showScheme(route);
      showBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) =>
            TrackBottomSheet(trSymbol: trSymbol, routes: routes),
      ).closed.whenComplete(() {
        _controller.updateSymbol(
          _selectedSymbol!,
          const SymbolOptions(iconSize: 1.0, textSize: 16),
        );
      });
    }
  }

  /// Читает картинку и передает ее в контроллер карты в байтовом представлении
  Future<void> addImageFromAsset(String name, String assetName) async {
    final bytes = await rootBundle.load(assetName);
    final list = bytes.buffer.asUint8List();
    return _controller.addImage(name, list);
  }

  /// Метод для отображения схемы определенного маршрута на карте.
  Future<void> _showScheme(m.Route route) async {
    try {
      await _hideScheme();
      schemeId = 'route-scheme';
      await _controller.addLineLayer(
        'scheme-${route.name}',
        schemeId!,
        LineLayerProperties(
            lineColor: Colors.lightBlue.toHexStringRGB(),
            lineWidth: [
              Expressions.interpolate,
              ['linear'],
              [Expressions.zoom],
              11.0,
              2.0,
              20.0,
              10.0
            ]),
      );
    } catch (e, stacktrace) {
      d.log('$e, $stacktrace');
    }
  }

  /// Метод для скрытия схемы.
  Future<void> _hideScheme() async {
    if (schemeId != null) await _controller.removeLayer(schemeId!);
  }

  /// Свойства маркера остановки.
  StationSymbolOptions _getStationSymbolOptions(Station station) =>
      StationSymbolOptions(
        geometry: LatLng(station.latitude, station.longitude),
        iconImage: 'station',
        iconSize: 1,
        id: station.id,
        name: station.name,
        isFavorite: station.isFavorite,
        zIndex: 1000,
      );

  /// Свойства маркера транспорта.
  TrackSymbolOptions _getTrackSymbolOptions(Track track) => TrackSymbolOptions(
      geometry: LatLng(double.parse(track.point.latitude),
          double.parse(track.point.longitude)),
      iconImage: track.vehicleType == VehicleType.TROLLEYBUS
          ? 'trolleybus-stu'
          : 'bus-stu',
      iconSize: 1,
      iconRotate: double.parse(track.point.direction),
      id: int.parse(track.uuid),
      route: track.route,
      textField: track.route,
      textColor: '#ffffff',
      iconAnchor: 'center',
      vehicleType: track.vehicleType,
      zIndex: 1001);

  /// Добавляет символы остановок на карты, забрав необходимую инфу из БД.
  Future<void> _addStationSymbols() async {
    stations = await DBHelper.instance.stations;
    final stationSymbolsOptions =
        stations.map((e) => _getStationSymbolOptions(e)).toList();

    await _controller.addStationSymbols(stationSymbolsOptions);
  }

  /// Добавляет символы транспорта на карты, забрав необходимую инфу с API.
  Future<void> _addInitialTrackSymbols({int? byRoute}) async {
    if (byRoute == null) {
      final tracksObject = await APIHelper.getInitialCoords();
      tracks = tracksObject.tracks;
      tracksSymbolsOptions =
          tracks.map((e) => _getTrackSymbolOptions(e)).toList();
      trackSymbols = await _controller.addTrackSymbols(tracksSymbolsOptions);
    } else {
      if (byRoute == 0) {
        for (final symbol in trackSymbols) {
          unawaited(_controller.updateSymbol(
              symbol,
              symbol.options.copyWith(
                  const SymbolOptions(iconOpacity: 1.0, textOpacity: 1.0))));
        }
      } else {
        final definedSymbols =
            trackSymbols.where((e) => e.route == byRoute.toString()).toList();
        for (final symbol in definedSymbols) {
          unawaited(_controller.updateSymbol(
              symbol,
              symbol.options.copyWith(
                  const SymbolOptions(iconOpacity: 1.0, textOpacity: 1.0))));
        }
      }
    }
    d.log(trackSymbols.length.toString(), name: 'TrackSymbolArray');
  }

  /// Скрытие символов транспорта.
  void _hideTrackSymbols() {
    for (final symbol in trackSymbols) {
      _controller.updateSymbol(
          symbol,
          symbol.options.copyWith(
              const SymbolOptions(iconOpacity: 0.0, textOpacity: 0.0)));
    }
  }

  /// Включение маркера пользовательской позиции.
  void _setUserLocation() {
    _hideScheme();
    if (currentPosition != null) {
      context.read<NavigatorProvider>().toMapAndCenterByCoords(
            LatLng(
              currentPosition!.latitude,
              currentPosition!.longitude,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack - виджет для компоновки экрана.
      // Позволяет размещать дочерние виджет поверх друг друга.
      body: Stack(
        children: [
          // Виджет с картой
          MapboxMap(
            // API-ключ с сайта Mapbox
            accessToken: Secrets.ACCESS_TOKEN,
            // Стиль карты, созданный в Mapbox Studio
            styleString: MapStyle.color,
            // Начальная позиция камеры
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                53.642807,
                55.973226,
              ),
              zoom: 17.0,
            ),
            // Ограничение отдаления и приближения карты
            minMaxZoomPreference: _minMaxZoomPreference,
            // Отключение поворотов карты
            rotateGesturesEnabled: false,
            // Включение определения местоположения пользователя
            myLocationEnabled: true,
            // Тип отслеживания местоположения пользователя
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
            // Расположение кнопки
            // об информации о картографическом провайдере
            attributionButtonMargins: _attributionRightBottom,
            // Расположение логотипа Mapbox
            logoViewMargins: _logoRightTop,
            // Функция-коллбек, которая вызовется,
            // когда карта будет создана
            onMapCreated: _onMapCreated,
            // Функция-коллбек, которая вызовется,
            // когда стили карты будут загружены
            onStyleLoadedCallback: _onStyleLoaded,
          ),
          // Positioned - виджет для компоновки экрана.
          // Позволяет указать конкретное место расположения дочернего виджета.
          Positioned(
            top: 60,
            right: 16,
            child:
                // Кнопка
                ElevatedButton(
              // Функция, которая будет вызвана при нажатии.
              // В данном случае,
              // будет открыт экран с детальной информацией по карте.
              onPressed: () => Navigator.of(context).pushNamed('/add-card'),
              style: ButtonStyle(
                // Фон кнопки
                backgroundColor: MaterialStateProperty.all(Colors.white),
                // Цвет содержимого в кнопке
                foregroundColor: MaterialStateProperty.all(UserColors.blue),
                // Цвет наведения
                overlayColor:
                    MaterialStateProperty.all(UserColors.blue.withAlpha(20)),
                // Отступы
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                // Радиус кнопки
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              child:
                  // Дочерний элемент кнопки состоит из иконки, отступа и текста.
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_card),
                  SizedBox(width: 12),
                  Text('Добавить карту'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: ElevatedButton(
              onPressed: _setUserLocation,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(UserColors.blue),
                overlayColor:
                    MaterialStateProperty.all(UserColors.blue.withAlpha(20)),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
