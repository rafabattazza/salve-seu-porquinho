import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:salveSeuPorquinho/components/object_array.dart';
import 'package:salveSeuPorquinho/screens/dashboard/report/header.dart';
import 'package:salveSeuPorquinho/screens/dashboard/report/tabs_button.dart';
import 'package:salveSeuPorquinho/services/transac_service.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime date = DateTime.now();
  int tab = 0;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _updateState(this.tab, this.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Header(this.dateChange),
              Padding(
                padding: EdgeInsets.only(top: 90),
                child: TabsButton(tab, this.tabChange),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 16)),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    if (tab == 0) {
      return buildWrapperChart();
    } else {
      return buildMethodsData();
    }
  }

  Widget buildMethodsData() {
    return Expanded(
      child: Column(
        children: [
          Text("Despesas por forma de pagamento"),
          Padding(padding: EdgeInsets.only(top: 32)),
          SingleChildScrollView(
            child: Column(
              children: new ObjectArray<Map<String, dynamic>>(transactions, _builderMethodRow).getObjects(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _builderMethodRow(Map<String, dynamic> rowDate, int row) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rowDate["met_name"],
                style: ThemeUtils.bigText,
              ),
              Text(
                double.parse(rowDate["tra_value"].toString()).toStringAsFixed(2),
                style: ThemeUtils.bigText,
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.white54,
        ),
      ],
    );
  }

  Widget buildWrapperChart() {
    Map<String, double> dataMap = new Map();

    transactions.forEach((transaction) {
      dataMap.putIfAbsent(transaction['wra_name'], () => double.parse(transaction['tra_value'].toString()));
    });

    if (dataMap.isEmpty) {
      return Text("Nenhum envelope localizado neste mês e ano");
    } else {
      return Expanded(
        child: Column(
          children: [
            Text("Despesas por envelopes"),
            SingleChildScrollView(
              child: PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                legendOptions: LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> tabChange(int tab) async {
    await _updateState(tab, this.date);
  }

  Future<void> dateChange(DateTime _date) async {
    await _updateState(this.tab, _date);
  }

  Future<void> _updateState(int _tab, DateTime _date) async {
    List<Map<String, dynamic>> _transactions;
    if (_tab == 0) {
      _transactions = await new TransacService().findByDateGroupByWrapper(_date);
    } else {
      _transactions = await new TransacService().findByDateGroupByMethod(_date);
    }

    setState(() {
      this.transactions = _transactions;
      this.tab = _tab;
      this.date = _date;
    });
  }
}
