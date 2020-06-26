import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:salveSeuPorquinho/components/InputFormatters/decimal-text-input-formatter.dart';
import 'package:salveSeuPorquinho/components/object_array.dart';
import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/forecast_dao.dart';
import 'package:salveSeuPorquinho/services/database/start_db_dao.dart';
import 'package:salveSeuPorquinho/services/database/wrapper_dao.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';

final NumberFormat _format = new NumberFormat("##0.00");

class FormForecast extends StatefulWidget {
  FormForecast({Key key}) : super(key: key);

  @override
  _FormForecastState createState() => _FormForecastState();
}

class _FormForecastState extends State<FormForecast> {
  static const String _DATE_LABEL_TEXT = "Selecione o mês e ano da previsão";
  static const String _INVOICE_LABEL_TEXT = "Quanto você receberá no mês";
  static const String _AVAILABLE_TEXT = "Disponível nesta categoria: ";
  static const String _BUDGETED_TEXT = "Soma dos envelopes: ";
  static const String _RESULT_TEXT = "Saldo desta categoria: ";

  TextEditingController _invoiceController = new TextEditingController();

  ForecastModel _forecast;
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrCreatePrevision(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildMounthPicker(),
        TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          controller: _invoiceController,
          decoration: ThemeUtils.inputDecoration
              .copyWith(labelText: _INVOICE_LABEL_TEXT, isDense: true),
          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 0, 8.0),
          child: Text("Envelopes de despesas - Informe suas previsões"),
        ),
        ...new ObjectArray<CategoryModel>(this._categories, _builderCategoryRow)
            .getObjects()
      ],
    );
  }

  List<Widget> _buildMounthPicker() {
    List<Widget> mounthPicker = <Widget>[
      Text(
        _DATE_LABEL_TEXT,
      ),
      new MonthStrip(
        format: 'MMM yyyy',
        from: new DateTime(2016, 4),
        to: new DateTime(2025, 5),
        initialMonth: DateTime.now(),
        height: 48.0,
        viewportFraction: 0.25,
        onMonthChanged: (date) async {
          await _loadOrCreatePrevision(date);
        },
        normalTextStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.green),
      ),
      Divider(
        color: Colors.white54,
      )
    ];

    return mounthPicker;
  }

  _loadOrCreatePrevision(DateTime date) async {
    final ForecastDAO _forecastDao = ForecastDAO();
    final WrapperDAO _wrapperDao = WrapperDAO();

    ForecastModel _forecast =
        await _forecastDao.findByMounthAndYear(date.month, date.year);
    if (_forecast == null) {
      _forecast = await _forecastDao.findLast();
      if (_forecast != null) {
        //Creating from the last forecast
        _forecast.id = null;
        _forecast.mounth = date.month;
        _forecast.year = date.year;
        await _forecastDao.persist(_forecast);
      }
    }

    if (_forecast == null) {
      await new StartDbDao().createDefaultPrevision();
      _forecast = await _forecastDao.findByMounthAndYear(date.month, date.year);
    }

    List<CategoryModel> _categories =
        await _wrapperDao.findByForecastGroupedByCategory(_forecast.id);

    setState(() {
      print(_format.format(_forecast.invoice));
      this._invoiceController.text = _format.format(_forecast.invoice);
      this._forecast = _forecast;
      this._categories = _categories;
    });
  }

  Widget _builderCategoryRow(CategoryModel category, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Color(0xFF121212),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${category.name} (${category.percent}%)"),
            ...new ObjectArray<WrapperModel>(
              category.groupedWrappers,
              (wrapper, wrIndex) {
                final TextEditingController control =
                    TextEditingController(text: _format.format(wrapper.budget));
                return Container(
                  padding: EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: control,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: wrapper.name,
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2),
                    ],
                  ),
                );
              },
            ).getObjects(),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(_AVAILABLE_TEXT),
                      Text(" + " + _format.format((_forecast.invoice * (category.percent / 100))),
                        style: ThemeUtils.strongText.copyWith(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(_BUDGETED_TEXT),
                      Text(" - "  + _format.format(_sumWrappers(category)),
                        style: ThemeUtils.strongText.copyWith(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(_RESULT_TEXT),
                      Text(" = "  + _format.format((_forecast.invoice * (category.percent / 100) - _sumWrappers(category))),
                        style: ThemeUtils.strongText.copyWith(
                          fontSize: 16,
                          color: (_forecast.invoice * (category.percent / 100) - _sumWrappers(category)) < 0 ? Colors.red : Colors.green,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _sumWrappers (CategoryModel category) {
    double soma = category.groupedWrappers.map((w) => w.budget).reduce((value, element) => value += element);
    return soma;
  }
}
