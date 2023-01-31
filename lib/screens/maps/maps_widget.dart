import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/extensions/for_custom_symbols_extension.dart';
import 'package:transport_sterlitamaka/models/enums.dart';
import 'package:transport_sterlitamaka/models/station_symbol.dart';
import 'package:transport_sterlitamaka/models/station_symbol_options.dart';
import 'package:transport_sterlitamaka/models/track.dart';
import 'package:transport_sterlitamaka/models/track_symbol.dart';
import 'package:transport_sterlitamaka/models/track_symbol_options.dart';
import 'package:transport_sterlitamaka/models/tracks.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/screens/maps/widgets/station_cell_bottom_sheet_widget.dart';
import 'package:transport_sterlitamaka/screens/maps/widgets/track_cell_bottom_sheet_widget.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:transport_sterlitamaka/theme/map_style.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:transport_sterlitamaka/utils/apihelper.dart';
import 'package:transport_sterlitamaka/utils/dbhelper.dart';
import 'package:transport_sterlitamaka/models/station.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  Position? currentPosition;
  Symbol? _selectedSymbol;

  late MapboxMapController _controller;
  final MinMaxZoomPreference _minMaxZoomPreference =
      const MinMaxZoomPreference(14.0, 17.0);
  final _attributionRightBottom = const Point(20, 20);
  final _logoRightTop = const Point(-1000, 0);

  List<Track> tracks = [];
  List<TrackSymbol> trackSymbols = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // запрос локации
  void _determinePosition() async {
    // проверка службы геолокации
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('[GEO]: Location services are disabled.');
      return;
    }
    // проверка разрешений
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('[GEO]: Location permissions are denied.');
        return;
      }
    }
    // открытие настроек для включения геолокации
    if (permission == LocationPermission.deniedForever) {
      print(
          '[GEO]: Location permissions are permanently denied, we cannot request permissions.');
      await Geolocator.openLocationSettings();
      return;
    }
    // запрос текущей позиции
    Position position = await Geolocator.getCurrentPosition();
    print('[GEO]: $position');
    setState(() {
      currentPosition = position;
    });
  }

  /// Коллбэк на создание карты, подключение к сокету и добавление обработчика нажатий
  void _onMapCreated(MapboxMapController controller) {
    _controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);

    APIHelper.webSocketStream()?.listen((event) {
      final incomingTracks = Tracks.fromMap(jsonDecode(event)).tracks;
      checkForUpdateTrack(incomingTracks);
    });
  }

  /// Обнаруживает транспорт, метку которого необходимо обновить
  void checkForUpdateTrack(List<Track> incomingTracks) {
    // 1. Проходить по пришедшему массиву и сравнивать транспорт в текущем массиве
    // 2. Если координаты поменялись, то вызываем метод обновления метки,
    //    в противном случае пропускаем
    // 2.1. В методе обновления или до него мы должны присваивать текущему массиву новые координаты.
    // 2.2. Должны менять: ротацию и координаты.
    // 3. После этого подумать над плавностью.
    for (int i = 0; i < incomingTracks.length; i++) {
      if (incomingTracks[i] !=
          tracks.where((e) => e.uuid == incomingTracks[i].uuid).first) {
        updateTrackSymbol(incomingTracks[i]);
        tracks[tracks.indexOf(
                tracks.where((e) => e.uuid == incomingTracks[i].uuid).first)] =
            incomingTracks[i];
      }
    }
  }

  /// Обновляет маркер транспорта
  void updateTrackSymbol(Track incomingTrack) {
    print('[TrackUpdater]: update $incomingTrack');
    final currentSymbol = trackSymbols
        .where((e) => e.trackId == int.parse(incomingTrack.uuid))
        .first;
    _controller.updateSymbol(
      currentSymbol,
      currentSymbol.options.copyWith(
        SymbolOptions(
          geometry: LatLng(double.parse(incomingTrack.point.latitude),
              double.parse(incomingTrack.point.longitude)),
          iconRotate: double.parse(incomingTrack.point.direction),
        ),
      ),
    );
    setState(() {});
  }

  /// Коллбэк на подгрузку стилей, грузит необходимые дополнительные ресурсы, устанавливает пользовательскую локацию
  void _onStyleLoaded() async {
    await addImageFromAsset('station', 'assets/images/3.0x/icon_station.png');
    await addImageFromAsset(
        'station-active', 'assets/images/3.0x/icon_station_active.png');
    await addImageFromAsset(
        'trolleybus-stu', 'assets/images/3.0x/icon_trolleybus.png');
    await addImageFromAsset('bus-stu', 'assets/images/3.0x/icon_bus.png');
    _setUserLocation();
    _addStationSymbols();
    _addInitialTrackSymbols();
  }

  /// Обработчик нажатий на маркеры
  void _onSymbolTapped(Symbol symbol) {
    // TODO: make bottomsheet better
    if (symbol is StationSymbol) {
      final stSymbol = symbol as StationSymbol;
      showBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StationCellBottomSheetWidget(stSymbol: stSymbol),
            ],
          ),
        ),
      );
    } else if (symbol is TrackSymbol) {
      final trSymbol = symbol as TrackSymbol;
      showBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrackCellBottomSheetWidget(trSymbol: trSymbol),
            ],
          ),
        ),
      );
    }
  }

  /// Читает картинку и передает ее в контроллер карты в байтовом представлении
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _controller.addImage(name, list);
  }

  /// Свойства маркера остановки
  StationSymbolOptions _getStationSymbolOptions(Station station) =>
      StationSymbolOptions(
          geometry: LatLng(station.latitude, station.longitude),
          iconImage: 'station',
          iconSize: 1,
          id: station.id,
          name: station.name);

  /// Свойства маркера транспорта
  TrackSymbolOptions _getTrackSymbolOptions(Track track) => TrackSymbolOptions(
      geometry: LatLng(double.parse(track.point.latitude),
          double.parse(track.point.longitude)),
      iconImage: track.vehicleType == VehicleType.TROLLEYBUS
          ? 'trolleybus-stu'
          : 'bus-stu',
      iconSize: 1,
      iconRotate: double.parse(track.point.direction),
      id: int.parse(track.uuid),
      route: track.route);

  /// Добавляет символы остановок на карты, забрав необходимую инфу из БД
  void _addStationSymbols() async {
    final stations = await DBHelper.instance.getAllStations();
    final stationSymbolsOptions =
        stations.map((e) => _getStationSymbolOptions(e)).toList();
    _controller.addStationSymbols(stationSymbolsOptions);
  }

  /// Добавляет символы транспорта на карты, забрав необходимую инфу с API
  void _addInitialTrackSymbols() async {
    final tracksObject = await APIHelper.getInitialCoords();
    tracks = tracksObject.tracks;
    final tracksSymbolsOptions =
        tracks.map((e) => _getTrackSymbolOptions(e)).toList();
    trackSymbols = await _controller.addTrackSymbols(tracksSymbolsOptions);
  }

  /// Включение маркера пользовательской позиции
  void _setUserLocation() {
    if (currentPosition != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          zoom: 17,
        ),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            accessToken: Secrets.ACCESS_TOKEN,
            styleString: MapStyle.color,
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                53.630403,
                55.930825,
              ),
              zoom: 17.0,
            ),
            minMaxZoomPreference: _minMaxZoomPreference,
            rotateGesturesEnabled: false,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
            attributionButtonMargins: _attributionRightBottom,
            logoViewMargins: _logoRightTop,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,
          ),
          Positioned(
            top: 60,
            right: 16,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/card'),
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
              child: Row(
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
