import 'package:cripto/models/moeda.dart';

class MoedaRepository {
  static List<Moeda> tabela = [
    Moeda(
        icone: 'images/bitcoin.png',
        nome: 'Bticoin',
        sigla: 'BT',
        preco: 29.90),
    Moeda(
        icone: 'images/dodgecoin.png',
        nome: 'DodgeCoin',
        sigla: 'DG',
        preco: 11.9),
    Moeda(
        icone: 'images/ethereum.png',
        nome: 'Ethereum',
        sigla: 'ETH',
        preco: 15.15),
    Moeda(
        icone: 'images/litecoin.png',
        nome: 'Litecoin',
        sigla: 'LT',
        preco: 9.3),
    Moeda(
        icone: 'images/monero.png', nome: 'Monero', sigla: 'MN', preco: 13.35),
    Moeda(
        icone: 'images/solana.png', nome: 'Solana', sigla: 'SLN', preco: 3.15),
  ];
}
