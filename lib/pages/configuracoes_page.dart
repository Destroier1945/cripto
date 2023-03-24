import 'package:cripto/configs/app_settings.dart';
import 'package:cripto/pages/documentos._page.dart';
import 'package:cripto/repositories/conta_repository.dart';
import 'package:cripto/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracoes')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          ListTile(
            title: const Text('Saldo'),
            subtitle: Text(
              real.format(conta.saldo),
              style: TextStyle(
                  fontSize: 25, color: Theme.of(context).primaryColor),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: updateSaldo,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Escanear documento'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DocumentosPage(),
                  fullscreenDialog: true),
            ),
          ),
          const Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: OutlinedButton(
                  onPressed: () => context.read<AuthService>().logout(),
                  style: OutlinedButton.styleFrom(primary: Colors.red),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Sair do App',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = context.read<ContaRepository>();

    valor.text = conta.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: const Text('Atualizar o saldo'),
      content: Form(
        key: form,
        child: TextFormField(
            controller: valor,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            validator: (value) {
              if (value!.isEmpty) return 'Informe o valor do saldo';
              return null;
            }),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                conta.setSaldo(double.parse(valor.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'))
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
