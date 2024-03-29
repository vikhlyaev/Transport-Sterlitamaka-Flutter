import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:transport_sterlitamaka/models/enums.dart';

/// [TrackSymbolOptions] - объект, представляющий конфигурации транспортного символа [TrackSymbol].
class TrackSymbolOptions extends SymbolOptions {
  final int id;
  final String route;
  final VehicleType vehicleType;

  TrackSymbolOptions({
    String? iconImage,
    LatLng? geometry,
    double? iconSize,
    Offset? iconOffset,
    String? iconAnchor,
    List<String>? fontNames,
    String? textField,
    double? textSize,
    double? textMaxWidth,
    double? textLetterSpacing,
    String? textJustify,
    String? textAnchor,
    double? textRotate,
    String? textTransform,
    Offset? textOffset,
    double? iconOpacity,
    double? iconRotate,
    String? iconColor,
    String? iconHaloColor,
    double? iconHaloWidth,
    double? iconHaloBlur,
    double? textOpacity,
    String? textColor,
    String? textHaloColor,
    double? textHaloWidth,
    double? textHaloBlur,
    int? zIndex,
    bool? draggable,
    required this.id,
    required this.route,
    required this.vehicleType,
  }) : super(
          iconSize: iconSize,
          geometry: geometry,
          iconImage: iconImage,
          draggable: draggable,
          fontNames: fontNames,
          iconAnchor: iconAnchor,
          iconColor: iconColor,
          iconHaloBlur: iconHaloBlur,
          iconHaloColor: iconHaloColor,
          iconHaloWidth: iconHaloWidth,
          iconOffset: iconOffset,
          iconOpacity: iconOpacity,
          iconRotate: iconRotate,
          textAnchor: textAnchor,
          textColor: textColor,
          textField: textField,
          textHaloBlur: textHaloBlur,
          textHaloColor: textHaloColor,
          textHaloWidth: textHaloWidth,
          textJustify: textJustify,
          textLetterSpacing: textLetterSpacing,
          textMaxWidth: textMaxWidth,
          textOffset: textOffset,
          textOpacity: textOpacity,
          textRotate: textRotate,
          textSize: textSize,
          textTransform: textTransform,
          zIndex: zIndex,
        );
}
