import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/* SE USA UN ICONO DE MARCADOR INTERACTUABLE PARA MOSTRAR LA UBICACION DE LOS RESTAURANTES
  CERCANOS DE ACUERDO A LA UBICACION DEL USUARIO
*/
Marker marcadorPOI(BuildContext context, LatLng position, String nombre) {
  return Marker(
    point: position,
    width: 40,
    height: 40,
    child: GestureDetector(
      onTap: () {
        // Mostramos un diálogo con informacion del restaurante
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Información"),
              content: Text(nombre),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text("Cerrar"),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
    ),
  );
}