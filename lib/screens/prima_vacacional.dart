import 'package:flutter/cupertino.dart';
import 'package:flutter_prima_vacacional/models/prima_vacacional_item.dart';
import 'package:flutter_prima_vacacional/screens/agregar_prima_vacacional.dart';
import 'package:intl/intl.dart';

class PrimaVacacional extends StatelessWidget {
  const PrimaVacacional({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: HomePrimaVacacional(),
      title: 'Prima Vacacional',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemOrange,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*
* Widget con el listado de items de primas vacacionales
*/
class HomePrimaVacacional extends StatefulWidget {
  const HomePrimaVacacional({super.key});

  @override
  State<HomePrimaVacacional> createState() => _HomePrimaVacacionalState();
}

class _HomePrimaVacacionalState extends State<HomePrimaVacacional> {
  final List<PrimaVacacionalItem> _items = [];

  @override
  void initState() {
    super.initState();

    PrimaVacacionalItem item1 = PrimaVacacionalItem(
        nombreCompleto: "Fabían Muñoz",
        sueldoMensualBruto: 25000,
        diasVacaciones: 10,
        porcentajePrima: 30,
        primaVacacionalBruta: 0);
    item1.calcularPrimaVacacional();

    PrimaVacacionalItem item2 = PrimaVacacionalItem(
        nombreCompleto: "Jorge Ávila",
        sueldoMensualBruto: 22500,
        diasVacaciones: 10,
        porcentajePrima: 25,
        primaVacacionalBruta: 0);
    item2.calcularPrimaVacacional();

    _items.add(item1);
    _items.add(item2);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Listado'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<void>(
                builder: (BuildContext context) => AgregarPrimaVacacional(
                  onAgregarItem: (item) {
                    setState(() {
                      _items.add(item);
                    });

                    Navigator.of(context).pop();
                  },
                  itemToUpdate: null,
                ),
              ),
            );
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
          child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return CupertinoListTile(
            title: Text(_items[index].nombreCompleto),
            subtitle: Text(
                'Id:${_items[index].id}  Prima: ${NumberFormat.currency(symbol: '\$')
                .format(_items[index].primaVacacionalBruta)}'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.arrow_right_circle),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) => AgregarPrimaVacacional(
                      onAgregarItem: (item) {
                        setState(() {
                          _items[index] = item;
                        });
                        Navigator.of(context).pop();
                      },
                      //Envío de item a widget AgregarPrimaVacacional
                      itemToUpdate: _items[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      )),
    );
  }
}
