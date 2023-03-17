import 'package:cripto/models/moeda.dart';
import 'package:cripto/pages/moedas_detalhes_page.dart';
import 'package:cripto/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      margin: EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => abrirDetalhes(),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              Image.asset(
                widget.moeda.icone,
                height: 40,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moeda.nome,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.moeda.sigla,
                        style: TextStyle(fontSize: 13, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: preColor['down'],
                  border: Border.all(
                    color: preColor['down'],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  real.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: ListTile(
                    title: Text('Remover dos favoritos'),
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
