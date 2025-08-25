import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// SE USA UN ICONO DE MARCADOR PARA MOSTRAR LA UBICACION ACTUAL DEL USUARIO O DISPOSITIVO
Marker marcadorUsuario(LatLng position) {
  return Marker(
    point: position,
    width: 80,
    height: 60,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          "Mi ubicación",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Icon(
          Icons.my_location,
          color: Colors.blue,
          size: 40,
        ),
      ],
    ),
  );
}