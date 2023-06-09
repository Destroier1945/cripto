// ignore_for_file: use_build_context_synchronously

import 'package:cripto/models/moeda.dart';
import 'package:cripto/repositories/conta_repository.dart';
import 'package:cripto/widgets/grafico_historico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MoedasDetalhePage extends StatefulWidget {
  Moeda moeda;
  MoedasDetalhePage({super.key, required this.moeda});

  @override
  State<MoedasDetalhePage> createState() => _MoedasDetalhePageState();
}

class _MoedasDetalhePageState extends State<MoedasDetalhePage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;
  Widget grafico = Container();
  bool graficoLoaded = false;

  getgrafico() {
    if (!graficoLoaded) {
      grafico = GraficoHistorico(moeda: widget.moeda);
      graficoLoaded = true;
    }
    return grafico;
  }

  comprar() async {
    if (_form.currentState!.validate()) {
      //salvar a compra
      await conta.comprar(widget.moeda, double.parse(_valor.text));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada com sucesso!!!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    conta = Provider.of<ContaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  widget.moeda.icone,
                  scale: 2.5,
                ),
                Text(
                  real.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            getgrafico(),
            (quantidade > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '$quantidade ${widget.moeda.sigla}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 72),
                  ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _valor,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Preco',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'reais',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'Compra minima e R\$50.00';
                  } else if (double.parse(value) > conta.saldo) {
                    return 'Voce nao tem saldo suficiente';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantidade = (value.isEmpty)
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: comprar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comprar',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
