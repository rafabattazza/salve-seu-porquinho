import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/tabs_button.dart';
import 'package:salveSeuPorquinho/services/business/forecast_business.dart';
import 'package:salveSeuPorquinho/services/database/forecast_dao.dart';
import 'header.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ForecastDAO forecastDao = new ForecastDAO();

  ForecastModel _forecast;
  double spentValues = 0;
  int selectedTab = 0;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Header(
              (_forecast?.invoice ?? 0) - (_forecast?.totalSpent() ?? 0),
              date,
              (DateTime d) {
                _loadDate(d);
              },
            ),
            TabsButton(selectedTab, (tab) {
              setState(() {
                this.selectedTab = tab;
              });
            }),
          ],
        ),
      ),
    );
  }

  void _loadDate(DateTime date) async {
    var forecast = await ForecastBusiness.loadOrCreateForecast(context, date);
    forecast = await forecastDao.findWithTransactionsValue(forecast.id);

    setState(() {
      this.date = date;
      this._forecast = forecast;
    });
  }
}
