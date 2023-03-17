import 'package:cripto/configs/app_settings.dart';
import 'package:cripto/models/moeda.dart';
import 'package:cripto/pages/moedas_detalhes_page.dart';
import 'package:cripto/repositories/favoritos_repository.dart';
import 'package:cripto/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;

  late NumberFormat real;
  late Map<String, String> loc;

  List<Moeda> selecionadas = [];
  late FavoritosRepository favoritos;

  readnumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';
    return PopupMenuButton(
      icon: Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
          actions: [changeLanguageButton()], title: const Text("Cripto"));
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoedasDetalhePage(moeda: moeda),
        ));
  }

  @override
  Widget build(BuildContext context) {
    favoritos = context.watch<FavoritosRepository>();

    readnumberFormat();
    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: (selecionadas.contains(tabela[moeda]))
                  ? const CircleAvatar(child: Icon(Icons.check))
                  : SizedBox(
                      width: 40, child: Image.asset(tabela[moeda].icone)),
              title: Row(
                children: [
                  Text(
                    tabela[moeda].nome,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  if (favoritos.lista.contains(tabela[moeda]))
                    Icon(Icons.circle, color: Colors.amber, size: 8),
                ],
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
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: tabela.length),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favoritos.saveAll(selecionadas);
                limparSelecionadas();
              },
              icon: const Icon(Icons.star),
              label: const Text(
                'Favoritar',
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ))
          : null,
    );
  }
}
