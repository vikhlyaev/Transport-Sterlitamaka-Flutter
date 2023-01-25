import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:transport_sterlitamaka/theme/map_style.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';
import 'package:turf/helpers.dart';

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _setLocale();
    _setupMap();
    _getUserLocation();
  }

  void _setLocale() {
    mapboxMap?.style.localizeLabels('ru', null);
  }

  void _getUserLocation() {
    mapboxMap?.location
        .updateSettings(LocationComponentSettings(enabled: true));
  }

  void _setupMap() {
    mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap?.loadStyleURI(MapStyle.color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 53.632400, 55.953775
          MapWidget(
            resourceOptions: ResourceOptions(accessToken: Secrets.ACCESS_TOKEN),
            cameraOptions: CameraOptions(
              center:
                  Point(coordinates: Position(55.953775, 53.632400)).toJson(),
              zoom: 17.0,
            ),
            styleUri: MapboxStyles.LIGHT,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 60,
            right: 16,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/add-card'),
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
