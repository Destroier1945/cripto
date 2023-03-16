import 'package:cripto/models/moeda.dart';
import 'package:cripto/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {
  MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;

  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  List<Moeda> selecionadas = [];

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(title: Text("Cripto"));
    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear_all),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: (selecionadas.contains(tabela[moeda]))
                  ? CircleAvatar(child: Icon(Icons.check))
                  : SizedBox(
                      width: 40, child: Image.asset(tabela[moeda].icone)),
              title: Text(
                tabela[moeda].nome,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              trailing: Text(
                real.format(tabela[moeda].preco),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              selected: selecionadas.contains(tabela[moeda]),
              selectedTileColor: Theme.of(context).primaryColorLight,
              onLongPress: () {
                print('pressionou');
                setState(() {
                  (selecionadas.contains(tabela[moeda]))
                      ? selecionadas.remove(tabela[moeda])
                      : selecionadas.add(tabela[moeda]);
                });
              },
              onTap: () {
                mostrarDetalhes(tabela[moeda]);
              },
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(),
          itemCount: tabela.length),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.star),
              label: Text(
                'Favoritar',
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ))
          : null,
    );
  }
}
