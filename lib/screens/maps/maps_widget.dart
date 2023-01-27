import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:transport_sterlitamaka/theme/map_style.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:turf/helpers.dart' as turf;

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  MapboxMap? mapboxMap;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // проверка доступности локации
  void _determinePosition() async {
    // проверка службы геолокации
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }
    // проверка разрешений
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }
    // открытие настроек для включения геолокации
    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      await Geolocator.openLocationSettings();
      return;
    }
    // запрос текущей позиции
    Position position = await Geolocator.getCurrentPosition();
    print(position);
    setState(() {
      currentPosition = position;
    });
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _setupMap();
    _setUserLocation();
  }

  void _setupMap() {
    // Установка русской локализации
    mapboxMap?.style.localizeLabels('ru', null);
    // Отключение компаса и линии масштаба
    mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    // Кастомный стиль
    mapboxMap?.loadStyleURI(MapStyle.color);
    // Включение маркера пользовательской позиции
    mapboxMap?.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );
  }

  void _setUserLocation() {
    if (currentPosition != null) {
      mapboxMap?.setCamera(CameraOptions(
        center: turf.Point(
          coordinates: turf.Position(
            currentPosition!.longitude,
            currentPosition!.latitude,
          ),
        ).toJson(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            resourceOptions: ResourceOptions(accessToken: Secrets.ACCESS_TOKEN),
            cameraOptions: CameraOptions(zoom: 17.0),
            onMapCreated: _onMapCreated,
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
        ],
      ),
    );
  }
}
