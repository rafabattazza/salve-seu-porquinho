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
import 'package:salveSeuPorquinho/utils/validation_utils.dart';

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

  static const String _NEW_WRAPPER_TEXT = "Novo envelope de despesas";
  static const String _EDIT_WRAPPER_TEXT = "Editando envelope '{}'";

  static const String _INPUT_NAME_TEXT = "Nome do envelope";
  static const String _INPUT_BUGDET_TEXT = "Valor";

  TextEditingController _invoiceController = new TextEditingController();
  final ForecastDAO _forecastDao = ForecastDAO();

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
          onChanged: _onTxtInvoiceSaved,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 0, 8.0),
          child: Text("Envelopes de despesas - Informe suas previsões"),
        ),
        if (this._categories.length == 0)
          Text("Você não possui nenhuma categoria cadastrada"),
        if (this._categories.length != 0)
          ...new ObjectArray<CategoryModel>(
                  this._categories, _builderCategoryRow)
              .getObjects(),
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

  _onTxtInvoiceSaved(String value) async {
    setState(() {
      this._forecast.invoice =
          double.parse(value == null || value.length == 0 ? "0" : value);
    });
    _forecastDao.persist(this._forecast);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text("${category.name} (${category.percent}%)"),
                  width: MediaQuery.of(context).size.width - 200,
                ),
                InkWell(
                  child: Icon(
                    Icons.add,
                    size: 32,
                  ),
                  onTap: () {
                    _editWrapper(null, category);
                  },
                ),
              ],
            ),
            Divider(color: Colors.white24,),
            if (category.groupedWrappers.length == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Nenhum envelope cadastrado nesta categoria",
                    style: ThemeUtils.bigText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (category.groupedWrappers.length != 0)
              ...new ObjectArray<WrapperModel>(
                category.groupedWrappers,
                (wrapper, wrIndex) {
                  final TextEditingController control = TextEditingController(
                      text: _format.format(wrapper.budget));
                  return Container(
                    padding: EdgeInsets.only(top: 8),
                    child: TextFormField(
                      controller: control,
                      decoration: InputDecoration(
                        labelText: wrapper.name,
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      readOnly: true,
                      onTap: () => _editWrapper(wrapper, wrapper.category),
                    ),
                  );
                },
              ).getObjects(),
            Divider(color: Colors.white24,),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(_AVAILABLE_TEXT),
                      Text(
                        " + " +
                            _format.format(
                                (_forecast.invoice * (category.percent / 100))),
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
                      Text(
                        " - " + _format.format(_sumWrappers(category)),
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
                      Text(
                        " = " +
                            _format.format(
                                (_forecast.invoice * (category.percent / 100) -
                                    _sumWrappers(category))),
                        style: ThemeUtils.strongText.copyWith(
                          fontSize: 16,
                          color: (_forecast.invoice * (category.percent / 100) -
                                      _sumWrappers(category)) <
                                  0
                              ? Colors.red
                              : Colors.green,
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

  void _editWrapper(WrapperModel wrapper, CategoryModel category) {
    final WrapperDAO wrapperDao = WrapperDAO();
    TextEditingController _nameController =
        new TextEditingController(text: wrapper?.name);
    TextEditingController _budgetController = new TextEditingController(
        text: wrapper == null ? null : _format.format(wrapper?.budget));
    final _formKey = GlobalKey<FormState>();

    _onBtnSalvarClick() async {
      if (!_formKey.currentState.validate()) return;

      WrapperModel wr = wrapper == null ? new WrapperModel() : wrapper;
      wr.forecast = _forecast;
      wr.category = category;
      wr.name = _nameController.text;
      wr.budget = double.parse(_budgetController.text);

      await wrapperDao.persist(wr);
      List<CategoryModel> categories =
          await wrapperDao.findByForecastGroupedByCategory(_forecast.id);
      setState(() {
        this._categories = categories;
      });
      Navigator.of(context).pop();
    }

    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(wrapper == null
                ? _NEW_WRAPPER_TEXT
                : _EDIT_WRAPPER_TEXT.replaceAll("{}", wrapper.name)),
            content: Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 20,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: ThemeUtils.inputDecoration
                        .copyWith(labelText: _INPUT_NAME_TEXT),
                    validator: REQUIRED,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _budgetController,
                    decoration: ThemeUtils.inputDecoration
                        .copyWith(labelText: _INPUT_BUGDET_TEXT),
                    inputFormatters: <TextInputFormatter>[
                      DecimalTextInputFormatter()
                    ],
                    validator: REQUIRED,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: _onBtnSalvarClick,
                child: Text("Salvar"),
                color: Colors.blue,
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Cancelar "),
                color: Colors.red,
              ),
            ],
          );
        });
  }

  double _sumWrappers(CategoryModel category) {
    if (category.groupedWrappers.length == 0) return 0.0;
    double soma = category.groupedWrappers
        .map((w) => w.budget)
        .reduce((value, element) => value += element);
    return soma;
  }
}
