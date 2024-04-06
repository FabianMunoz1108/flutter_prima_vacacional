import 'package:flutter/cupertino.dart';

class PrimaVacacionalItem {
  final String id;
  String nombreCompleto;
  double sueldoMensualBruto;
  int diasVacaciones;
  int porcentajePrima;
  double primaVacacionalBruta;

  PrimaVacacionalItem({
    required this.nombreCompleto,
    required this.sueldoMensualBruto,
    required this.diasVacaciones,
    required this.porcentajePrima,
    required this.primaVacacionalBruta,
  }) : id = UniqueKey().toString();

    // Método para calcular la prima vacacional
  void calcularPrimaVacacional() {
    primaVacacionalBruta = ((sueldoMensualBruto / 30) * diasVacaciones) * (porcentajePrima / 100);
  }
}