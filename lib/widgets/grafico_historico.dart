import 'package:cripto/configs/app_settings.dart';
import 'package:cripto/models/moeda.dart';
import 'package:cripto/repositories/moeda_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraficoHistorico extends StatefulWidget {
  Moeda moeda;
  GraficoHistorico({super.key, required this.moeda});

  @override
  State<GraficoHistorico> createState() => _GraficoHistoricoState();
}

enum Periodo { hora, dia, semana, mes, ano, total }

class _GraficoHistoricoState extends State<GraficoHistorico> {
  List<Color> cores = [
    Color(0xFF3F51B5),
  ];
  Periodo periodo = Periodo.hora;
  List<Map<String, dynamic>> historico = [];
  List dadosCompletos = [];
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;

  ValueNotifier<bool> loaded = ValueNotifier(false);
  late MoedaRepository respositorio;
  late Map<String, String> loc;
  late NumberFormat real;

  setDados() async {
    loaded.value = false;
    dadosGrafico = [];
    if (historico.isEmpty) {
      historico = await respositorio.getHistoricoMoeda(widget.moeda);
    }
    dadosCompletos = historico[periodo.index]['prices'];
    dadosCompletos = dadosCompletos.reversed.map((item) {
      double preco = double.parse(item[0]);
      int time = int.parse(item[1].toString() + '000');
      return [preco, DateTime.fromMicrosecondsSinceEpoch(time)];
    }).toList();

    maxX = dadosCompletos.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var item in dadosCompletos) {
      maxY = item[0] > maxY ? item[0] : maxY;
      minY = item[0] < minY ? item[0] : minY;
    }

    for (int i = 0; i < dadosCompletos.length; i++) {
      dadosGrafico.add(
        FlSpot(
          i.toDouble(),
          dadosCompletos[i][0],
        ),
      );
    }
    loaded.value = true;
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      maxY: maxY,
      minY: minY,
      lineBarsData: [
        LineChartBarData(
          spots: dadosGrafico,
          isCurved: true,
          color: Color(0xFF3F51B5),
          barWidth: 2,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: Color(0xFF3F51B5).withOpacity(0.5),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.grey,
          getTooltipItems: (data) {
            return data.map((item) {
              final date = getDate(item.spotIndex);
              return LineTooltipItem(
                  real.format(item.y),
                  TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                        text: '\n $date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ))
                  ]);
            }).toList();
          },
        ),
      ),
    );
  }

  getDate(int index) {
    DateTime date = dadosCompletos[index][1];
    if (periodo != Periodo.ano && periodo != Periodo.total) {
      return DateFormat('dd/MM - hh:mm').format(date);
    } else {
      return DateFormat('dd/MM/y').format(date);
    }
  }

  chartButton(Periodo p, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () => setState(() {
          periodo = p;
        }),
        child: Text(label),
        style: (periodo != p)
            ? ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey))
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo[50])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    respositorio = context.read<MoedaRepository>();
    loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    setDados();

    return Container(
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                chartButton(Periodo.hora, '1H'),
                chartButton(Periodo.dia, '24H'),
                chartButton(Periodo.semana, 'Sem.'),
                chartButton(Periodo.mes, 'Mes'),
                chartButton(Periodo.ano, 'Ano'),
                chartButton(Periodo.total, 'Total'),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ValueListenableBuilder(
                  valueListenable: loaded,
                  builder: (context, bool isLoaded, _) {
                    return (isLoaded)
                        ? LineChart(
                            getChartData(),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
