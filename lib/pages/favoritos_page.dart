import 'package:cripto/widgets/moeda_card.dart';
import 'package:cripto/repositories/favoritos_repository.dart';

// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Moedas Favoritas'),
        ),
        body: Consumer<FavoritosRepository>(
          builder: (context, favoritos, child) {
            return favoritos.lista.isEmpty
                ? ListTile(
                    leading: Icon(Icons.star),
                    title: Text("Ainda não há moedas por aqui"),
                  )
                : ListView.builder(
                    itemCount: favoritos.lista.length,
                    itemBuilder: (_, index) {
                      return MoedasCard(moeda: favoritos.lista[index]);
                    },
                  );
          },
        ));
  }
}
