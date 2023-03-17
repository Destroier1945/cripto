// ignore_for_file: prefer_const_constructors

import 'package:cripto/myapp.dart';
import 'package:cripto/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => FavoritosRepository(),
    child: MyApp(),
  ));
}
