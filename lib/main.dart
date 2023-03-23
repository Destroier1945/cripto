import 'package:cripto/configs/app_settings.dart';
import 'package:cripto/configs/hive_config.dart';
import 'package:cripto/myapp.dart';
import 'package:cripto/repositories/conta_repository.dart';
import 'package:cripto/repositories/favoritos_repository.dart';
import 'package:cripto/repositories/moeda_repository.dart';
import 'package:cripto/service/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => MoedaRepository()),
        ChangeNotifierProvider(
            create: (context) =>
                ContaRepository(moedas: context.read<MoedaRepository>())),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
            create: (context) => FavoritosRepository(
                auth: context.read<AuthService>(),
                moedas: context.read<MoedaRepository>())),
      ],
      child: const MyApp(),
    ),
  );
}
