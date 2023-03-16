import 'package:cripto/models/moeda.dart';
import 'package:flutter/material.dart';

class MoedasDetalhePage extends StatefulWidget {
  Moeda moeda;
  MoedasDetalhePage({super.key, required this.moeda});

  @override
  State<MoedasDetalhePage> createState() => _MoedasDetalhePageState();
}

class _MoedasDetalhePageState extends State<MoedasDetalhePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
    );
  }
}
