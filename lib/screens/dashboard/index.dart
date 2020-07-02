import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salveSeuPorquinho/components/object_array.dart';
import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/screens/dashboard/dashboard_item.dart';
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
            Container(
              height: 230,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Header(
                    (_forecast?.invoice ?? 0) -
                        (_forecast?.sumCategoriesSpent() ?? 0),
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
            Padding(padding: EdgeInsets.only(top: 16)),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildList(),
                    )),
              ),
            ),
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

  List<Widget> _buildList() {
    if (selectedTab == 0) {
      return ObjectArray<CategoryModel>(
              (_forecast?.categories ?? []), _buildCategory)
          .getObjects();
    } else {
      return ObjectArray<CategoryModel>(
              (_forecast?.categories ?? []), _buildGroupByCategory)
          .getObjects();
    }
  }

  Widget _buildCategory(CategoryModel category, int index) {
    print(category.groupedWrappers);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(category.name),
          ),
          ...ObjectArray<WrapperModel>(
            category.groupedWrappers,
            (final WrapperModel wrapper, final int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DashboardItem(
                  wrapper.name,
                  wrapper.budget,
                  wrapper.sumTransactions,
                  showAdd: true,
                ),
              );
            },
          ).getObjects()
        ],
      ),
    );
  }

  Widget _buildGroupByCategory(CategoryModel category, int index) {
    print(category.groupedWrappers);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: DashboardItem(
        category.name,
        category.sumWrappersBudget(),
        category.sumWrappersSpent(),
        showAdd: false,
      ),
    );
  }
}
