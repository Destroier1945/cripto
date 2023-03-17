import 'package:cripto/configs/app_settings.dart';
import 'package:cripto/myapp.dart';
import 'package:cripto/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => FavoritosRepository(),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritosRepository()),
      ],
      child: MyApp(),
    ),
  ));
}
