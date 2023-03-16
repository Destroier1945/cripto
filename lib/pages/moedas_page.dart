import 'package:cripto/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';

class MoedasPage extends StatelessWidget {
  final tabela = MoedaRepository.tabela;
  MoedasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cripto moedas'),
        ),
        body: ListView.separated(
            itemBuilder: (BuildContext context, int moeda) {
              return ListTile(
                leading: SizedBox(
                    width: 40, child: Image.asset(tabela[moeda].icone)),
                title: Text(
                  tabela[moeda].nome,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                trailing: Text(tabela[moeda].preco.toString()),
              );
            },
            padding: EdgeInsets.all(16),
            separatorBuilder: (_, __) => Divider(),
            itemCount: tabela.length));
  }
}
