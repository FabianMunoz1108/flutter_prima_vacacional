import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prima_vacacional/models/prima_vacacional_item.dart';
import 'package:intl/intl.dart';

class AgregarPrimaVacacional extends StatefulWidget {
  //Item especifico para edición
  final PrimaVacacionalItem? itemToUpdate;
  final Function(PrimaVacacionalItem) onAgregarItem;

  const AgregarPrimaVacacional(
      {super.key, required this.onAgregarItem, required this.itemToUpdate});

  @override
  State<AgregarPrimaVacacional> createState() => _AgregarPrimavacacionalState();
}

class _AgregarPrimavacacionalState extends State<AgregarPrimaVacacional> {
  final _nombreController = TextEditingController(text: "");
  final _apellidoController = TextEditingController(text: "");
  final _sueldoMensualController = TextEditingController(text: "0".toString());
  final _diasVacacionesController = TextEditingController(text: "0".toString());
  final _porcentajePrimaController =
      TextEditingController(text: "0".toString());
  double _primaVacacionalBruta = 0.0;

  @override
  void initState() {
    //La llamada a super debe ser la primera en el método
    super.initState();

    if (widget.itemToUpdate != null) {
      _nombreController.text =
          widget.itemToUpdate!.nombreCompleto.split(" ").first;
      _apellidoController.text =
          widget.itemToUpdate!.nombreCompleto.split(" ").last;
      _sueldoMensualController.text =
          widget.itemToUpdate!.sueldoMensualBruto.toString();
      _diasVacacionesController.text =
          widget.itemToUpdate!.diasVacaciones.toString();
      _porcentajePrimaController.text =
          widget.itemToUpdate!.porcentajePrima.toString();
      _primaVacacionalBruta = widget.itemToUpdate!.primaVacacionalBruta;
    }

    _nombreController.addListener(_calcularPrimaVacacional);
    _apellidoController.addListener(_calcularPrimaVacacional);
    _sueldoMensualController.addListener(_calcularPrimaVacacional);
    _diasVacacionesController.addListener(_calcularPrimaVacacional);
    _porcentajePrimaController.addListener(_calcularPrimaVacacional);
  }

  void _calcularPrimaVacacional() {
    setState(() {
      _primaVacacionalBruta =
          ((double.tryParse(_sueldoMensualController.text)! / 30) *
                  int.tryParse(_diasVacacionesController.text)!) *
              (double.tryParse(_porcentajePrimaController.text)! / 100);
      print(_primaVacacionalBruta);
    });
  }

  @override
  void dispose() {
    _nombreController.removeListener(_calcularPrimaVacacional);
    _apellidoController.removeListener(_calcularPrimaVacacional);
    _sueldoMensualController.removeListener(_calcularPrimaVacacional);
    _diasVacacionesController.removeListener(_calcularPrimaVacacional);
    _porcentajePrimaController.removeListener(_calcularPrimaVacacional);

    //Se llama al método dispose de la clase padre hasta el final, para liberar los recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
            widget.itemToUpdate == null ? 'Agregar Prima' : 'Actualizar Prima'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            //Se verifica si el item ya existe para no remplazarlo con uno nuevo
            if (widget.itemToUpdate == null) {
              print("Nuevo item");

              widget.onAgregarItem(
                PrimaVacacionalItem(
                  nombreCompleto:
                      "${_nombreController.text} ${_apellidoController.text}",
                  sueldoMensualBruto:
                      double.tryParse(_sueldoMensualController.text)!,
                  diasVacaciones: int.tryParse(_diasVacacionesController.text)!,
                  porcentajePrima:
                      int.tryParse(_porcentajePrimaController.text)!,
                  primaVacacionalBruta: _primaVacacionalBruta,
                ),
              );
            } else {
              print("Actualizar sin duplicar");

              // Update existing item
              widget.itemToUpdate!.nombreCompleto =
                  "${_nombreController.text} ${_apellidoController.text}";
              widget.itemToUpdate!.sueldoMensualBruto =
                  double.tryParse(_sueldoMensualController.text)!;
              widget.itemToUpdate!.diasVacaciones =
                  int.tryParse(_diasVacacionesController.text)!;
              widget.itemToUpdate!.porcentajePrima =
                  int.tryParse(_porcentajePrimaController.text)!;
              widget.itemToUpdate!.primaVacacionalBruta = _primaVacacionalBruta;
              widget.onAgregarItem(widget.itemToUpdate!);
            }
          },
          child: Icon(widget.itemToUpdate == null
              ? CupertinoIcons.add_circled
              : CupertinoIcons.check_mark_circled),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre + Apellido
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nombre:'),
                        CupertinoTextField(
                          controller: _nombreController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Apellido:'),
                        CupertinoTextField(
                          controller: _apellidoController,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Text("Sueldo mensual bruto:"),
              CupertinoTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                ],
                controller: _sueldoMensualController,
              ),
              const SizedBox(height: 8),
              const Text("Días de vacaciones:"),
              CupertinoTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _diasVacacionesController,
              ),
              const SizedBox(height: 8),
              const Text("Porcentaje de prima vacacional:"),
              CupertinoTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _porcentajePrimaController,
              ),
              const SizedBox(height: 30),
              const Divider(height: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 30),
              const Text(
                'Prima Vacacional',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Empleado:'),
                  Text("${_nombreController.text} ${_apellidoController.text}")
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Prima vacacional:'),
                  Text(NumberFormat.currency(symbol: '\$')
                      .format(_primaVacacionalBruta))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
