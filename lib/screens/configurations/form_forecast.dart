import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:salveSeuPorquinho/components/InputFormatters/decimal-text-input-formatter.dart';
import 'package:salveSeuPorquinho/components/object_array.dart';
import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/forecast_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/forecast_service.dart';
import 'package:salveSeuPorquinho/services/wrapper_service.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:salveSeuPorquinho/utils/utils.dart';
import 'package:salveSeuPorquinho/utils/validation_utils.dart';

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

  static const String _CONFIRM_DELETE_TEXT =
      "Confirma a exclusão do envelope '{}'?";
  static const String _BUTTON_DELETE_TEXT = "Excluir";
  static const String _BUTTON_CANCELAR_TEXT = "Cancelar";

  TextEditingController _invoiceController = new TextEditingController();
  final ForecastService _forecastService = ForecastService();

  ForecastModel _forecast;
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
        ..._buildMonthPicker(),
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
        if ((this._forecast?.categories ?? []).length == 0)
          Text("Você não possui nenhuma categoria cadastrada"),
        if ((this._forecast?.categories ?? []).length != 0)
          ...new ObjectArray<CategoryModel>(
            this._forecast.categories,
            _builderCategoryRow,
          ).getObjects(),
      ],
    );
  }

  List<Widget> _buildMonthPicker() {
    List<Widget> monthPicker = <Widget>[
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

    return monthPicker;
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
              ],
            ),
            Divider(
              color: Colors.white24,
            ),
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
                  return WapperRow(wrapper, _editWrapper);
                },
              ).getObjects(),
            Divider(
              color: Colors.white24,
            ),
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
                            Utils.numberFormat.format(
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
                        " - " +
                            Utils.numberFormat.format(_sumWrappers(category)),
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
                            Utils.numberFormat.format(
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
    final WrapperService wrapperService = WrapperService();
    TextEditingController _nameController =
        new TextEditingController(text: wrapper?.name);
    TextEditingController _budgetController = new TextEditingController(
        text: wrapper == null
            ? null
            : Utils.numberFormat.format(wrapper?.budget));
    final _formKey = GlobalKey<FormState>();

    const String _BUTTON_DELETE_TEXT = "Excluir";

    _onBtnSalvarClick() async {
      if (!_formKey.currentState.validate()) return;

      WrapperModel wr = wrapper == null ? new WrapperModel() : wrapper;
      wr.forecast = _forecast;
      wr.category = category;
      wr.name = _nameController.text;
      wr.budget = double.parse(_budgetController.text);

      await wrapperService.persist(wr);
      this.refresh();
      Navigator.of(context).pop();
    }

    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text(wrapper == null
                    ? _NEW_WRAPPER_TEXT
                    : _EDIT_WRAPPER_TEXT.replaceAll("{}", wrapper.name)),
                if (wrapper != null)
                  RaisedButton.icon(
                    onPressed: () => _deleteWrapper(wrapper),
                    color: Colors.orange,
                    icon: Icon(Icons.delete),
                    label: Text(_BUTTON_DELETE_TEXT),
                  ),
              ],
            ),
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

  _onTxtInvoiceSaved(String value) async {
    setState(() {
      this._forecast.invoice =
          double.parse(value == null || value.length == 0 ? "0" : value);
    });
    _forecastService.persist(this._forecast);
  }

  _loadOrCreatePrevision(DateTime date) async {
    var _forecastLocal =
        await ForecastService().loadOrCreateForecast(context, date);
    setState(() {
      this._invoiceController.text =
          Utils.numberFormat.format(_forecastLocal.invoice);
      this._forecast = _forecastLocal;
    });
  }

  Future<void> refresh() async {
    final WrapperService wrapperService = WrapperService();
    List<CategoryModel> categories =
        await wrapperService.findByForecastGroupedByCategory(_forecast.id);
    setState(() {
      this._forecast.categories = categories;
    });
  }

  _deleteWrapper(WrapperModel wrapper) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_CONFIRM_DELETE_TEXT.replaceAll("{}", wrapper.name)),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              WrapperService _wrapperService = WrapperService();
              await _wrapperService.delete(wrapper);
              await this.refresh();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(_BUTTON_DELETE_TEXT),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(_BUTTON_CANCELAR_TEXT),
          ),
        ],
      ),
    );
  }

  double _sumWrappers(CategoryModel category) {
    if (category.groupedWrappers.length == 0) return 0.0;
    double soma = category.groupedWrappers
        .map((w) => w.budget)
        .reduce((value, element) => value += element);
    return soma;
  }
}

class WapperRow extends StatefulWidget {
  final WrapperModel wrapper;

  final Function(
    WrapperModel wrapperModel,
    CategoryModel categoryModel,
  ) onEdit;

  WapperRow(this.wrapper, this.onEdit);

  @override
  _WapperRowState createState() => _WapperRowState();
}

class _WapperRowState extends State<WapperRow> {
  bool deletedSelected = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController control = TextEditingController(
        text: Utils.numberFormat.format(widget.wrapper.budget));
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: control,
            decoration: InputDecoration(
              labelText: widget.wrapper.name,
              prefixIcon: Icon(Icons.attach_money),
            ),
            readOnly: true,
            onTap: () => widget.onEdit(widget.wrapper, widget.wrapper.category),
          ),
        ),
      ],
    );
  }
}
