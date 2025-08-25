import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'marcador_usuario.dart';
import 'marcador_poi.dart';

class MapaWidget extends StatefulWidget {
  const MapaWidget({super.key});

  @override
  State<MapaWidget> createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget> {
  LatLng? _ubicacionActual;
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getUbicacionActual();
  }

  // AQUI SE PIDE PERMISO AL USUARIO DE ACCEDER A SU UBICACION ACTUAL
  Future<void> _getUbicacionActual() async {
    bool servicioConcedido = await Geolocator.isLocationServiceEnabled();
    if (!servicioConcedido) return;

    LocationPermission permisos = await Geolocator.checkPermission();
    if (permisos == LocationPermission.denied) {
      permisos = await Geolocator.requestPermission();
      if (permisos == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _ubicacionActual = LatLng(position.latitude, position.longitude);
      _markers.add(marcadorUsuario(_ubicacionActual!));
    });

    _getRestaurantesCercanos(_ubicacionActual!);
  }
  // ____________________________________________________________________________________

  // SE OBTIENE LOS RESTAURANTES CERCANOS SEGUN LA UBICACION ACTUAL USANDO LA API DE NOMINATIM
  Future<void> _getRestaurantesCercanos(LatLng location) async {
    final url =
      "https://nominatim.openstreetmap.org/search?format=json&q=restaurant&limit=10&viewbox=${location.longitude - 0.01},${location.latitude + 0.01},${location.longitude + 0.01},${location.latitude - 0.01}&bounded=1";

    /* HACEMOS UNA PETICION GET AL SERVIDOR, TOMAMOS LA URL DE TIPO STRING
      PARA CONVERTIRLA EN UN OBJETO URI EN UN ENCABEZADO CON DATOS NO GENERICOS
      PARA IDENTIFICAR NUESTRO DISPOSITIVO CON EL SERVIDOR PARA ACCEDER AL SERVICIO
     */
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent": "app_geolocalizacion_sencilla/1.0 (developjarz@gmail.com)"
      },
    );
    
    /* SI LA RESPUESTA ES CORRECTA, TRAE LOS DATOS EN FORMATO JSON
      PARA LUEGO CONVERTIR LOS DATOS EN MARCADORES DIBUJADOS EN EL MAPA Y
      ACTUALIZAMOS EL ESTADO DE LA APP CON LOS RESTAURANTES ENCONTRADOS
     */
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<Marker> poiMarkers = data.map((place) {
        double lat = double.parse(place['lat']);
        double lon = double.parse(place['lon']);
        String nombre = place['display_name'] ?? "Restaurante sin nombre";
        return marcadorPOI(context, LatLng(lat, lon), nombre);
      }).toList();

      setState(() {
        _markers.addAll(poiMarkers);
      });
    }
  }
// ____________________________________________________________________________________

  @override
  Widget build(BuildContext context) {
    if (_ubicacionActual == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: _ubicacionActual!,
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.app_geolocalizacion.app',
        ),
        MarkerLayer(markers: _markers),
      ],
    );
  }
}