import 'package:cripto/models/moeda.dart';
import 'package:cripto/pages/moedas_detalhes_page.dart';
import 'package:cripto/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MoedasCard extends StatefulWidget {
  Moeda moeda;

  MoedasCard({super.key, required this.moeda});

  @override
  State<MoedasCard> createState() => _MoedasCardState();
}

class _MoedasCardState extends State<MoedasCard> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  static Map preColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.red,
  };

  abrirDetalhes() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MoedasDetalhePage(
                  moeda: widget.moeda,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => abrirDetalhes(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              Image.network(
                widget.moeda.icone,
                height: 40,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moeda.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.moeda.sigla,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: preColor['down'],
                  border: Border.all(
                    color: preColor['down'],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  real.format(widget.moeda.preco),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: ListTile(
                    title: const Text('Remover dos favoritos'),
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<FavoritosRepository>(context, listen: false)
                          .remove(widget.moeda);
                    },
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
