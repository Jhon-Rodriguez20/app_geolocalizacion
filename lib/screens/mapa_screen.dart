import 'package:flutter/material.dart';
import '../widgets/mapa_widget.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurantes cercanos")),
      body: MapaWidget(), // Se carga el widget del mapa para mostrar al usuario
    );
  }
}