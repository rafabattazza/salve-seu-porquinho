import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:salveSeuPorquinho/components/InputFormatters/decimal-text-input-formatter.dart';
import 'package:salveSeuPorquinho/models/method_model.dart';
import 'package:salveSeuPorquinho/models/transac_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/methods_service.dart';
import 'package:salveSeuPorquinho/services/transac_service.dart';
import 'package:salveSeuPorquinho/services/wrapper_service.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:salveSeuPorquinho/utils/utils.dart';
import 'package:salveSeuPorquinho/utils/validation_utils.dart';

class FormEntry extends StatefulWidget {
  final TransacModel _transac;
  final int _startWrapperId;
  final int _forecastId;
  FormEntry(
    this._transac,
    this._forecastId,
    this._startWrapperId, {
    Key key,
  }) : super(key: key);

  @override
  _FormEntryState createState() => _FormEntryState(_transac);
}

class _FormEntryState extends State<FormEntry> {
  static const String _HEADER_TEXT = "Lançamento";

  static const String _WRAPPER_TEXT = "Envelope";
  static const String _PAYMENT_METHOD_TEXT = "Forma de pagamento";
  static const String _VALUE_TEXT = "Valor";
  static const String _DESCR_TEXT = "Descrição";
  static const String _DT_CREATE_TEXT = "Dia da compra";
  static const String _DT_DUE_TEXT = "Dia do pagto";

  static const String _INSTALLMENTS_OPTION_TEXT = "Forma de parcelamento";
  static const String _INSTALLMENT_TEXT = "Quantidade de parcelas";

  TransacService transacService = TransacService();

  TransacModel _transac;
  _FormEntryState(this._transac);

  final DateFormat DT_FORMAT = new DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._edit(this._transac);
    });
  }

  int _wrapperId;
  int _methodId;
  int _installmentOption = 1;

  List<WrapperModel> _wrappers;
  List<MethodModel> _methods;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descrController = new TextEditingController();
  final TextEditingController _valueController = new TextEditingController();
  final TextEditingController _dtCreateController = new TextEditingController();
  final TextEditingController _dtDueController = new TextEditingController();
  final TextEditingController _subdivisionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_HEADER_TEXT),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
            ),
          ),
          actions: <Widget>[FlatButton(onPressed: _save, child: Icon(Icons.save))],
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 20,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 20,
                    children: <Widget>[
                      DropdownButtonFormField<int>(
                        items: _getWrapperMenuItens(),
                        value: _wrapperId,
                        onChanged: (wId) => _wrapperIdChange(wId),
                        decoration: new InputDecoration(labelText: _WRAPPER_TEXT),
                        validator: REQUIRED,
                      ),
                      DropdownButtonFormField<int>(
                        items: _getMethodsPaymentItems(),
                        value: _methodId,
                        onChanged: (wId) => _methodIdChange(wId),
                        decoration: new InputDecoration(labelText: _PAYMENT_METHOD_TEXT),
                        validator: REQUIRED,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        controller: _valueController,
                        decoration: new InputDecoration(labelText: _VALUE_TEXT, prefixIcon: Icon(Icons.monetization_on)),
                        validator: REQUIRED,
                        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                      ),
                      TextFormField(
                        controller: _descrController,
                        decoration: new InputDecoration(labelText: _DESCR_TEXT),
                        validator: REQUIRED,
                        maxLines: 2,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: _dtCreateController,
                              decoration: new InputDecoration(
                                labelText: _DT_CREATE_TEXT,
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              onTap: () => _pickDate(context, _dtCreateController),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 4, right: 4)),
                          Expanded(
                            child: TextFormField(
                              readOnly: this._transac.id != null,
                              controller: _dtDueController,
                              decoration: new InputDecoration(
                                labelText: _DT_DUE_TEXT,
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              onTap: () => _pickDate(context, _dtCreateController),
                            ),
                          ),
                        ],
                      ),
                      if (this._transac.id == null)
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Text(
                                "Parcelamento",
                                style: ThemeUtils.bigText,
                              ),
                              DropdownButtonFormField<int>(
                                items: _getSubdivisionOptions(),
                                value: _installmentOption,
                                onChanged: (option) => _subdivisionOptionChange(option),
                                decoration: new InputDecoration(labelText: _INSTALLMENTS_OPTION_TEXT),
                              ),
                              new TextFormField(
                                keyboardType: TextInputType.numberWithOptions(decimal: false),
                                maxLines: 1,
                                decoration: new InputDecoration(
                                  labelText: _INSTALLMENT_TEXT,
                                ),
                                controller: _subdivisionController,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _getWrapperMenuItens() {
    if (_wrappers == null || _wrappers.length == 0) return [];
    var res = _wrappers
        .map((e) => new DropdownMenuItem(
              child: Text(e.name),
              value: e.id,
            ))
        .toList();

    return res;
  }

  List<DropdownMenuItem<int>> _getMethodsPaymentItems() {
    if (_methods == null || _methods.length == 0) return [];
    var res = _methods
        .map((e) => new DropdownMenuItem(
              child: Text(e.name),
              value: e.id,
            ))
        .toList();

    return res;
  }

  List<DropdownMenuItem<int>> _getSubdivisionOptions() {
    return [
      new DropdownMenuItem(value: 1, child: Text("Dividir o valor acima entre as parcelas")),
      new DropdownMenuItem(value: 2, child: Text("Utilizar o valor acima em cada parcela")),
    ];
  }

  _wrapperIdChange(int _wrapperId) async {
    if (_wrapperId == null) return;
    String _lastDescr = "";
    _lastDescr = (await transacService.findLastDescr(_wrapperId)) ?? _wrappers.firstWhere((wr) => wr.id == _wrapperId).name + " - ";

    setState(() {
      this._wrapperId = _wrapperId;
      this._descrController.text = _lastDescr;
    });
  }

  _methodIdChange(int _methodId) async {
    if (_methodId == null) return;
    MethodModel method = this._methods.firstWhere((m) => m.id == _methodId);
    DateTime _dtCreate = this._dtCreateController.text.length == 0 ? DateTime.now() : DateFormat("dd/MM/yyyy").parse(this._dtCreateController.text);
    if (method.type == 2) {
      //Crédito
      int day = _dtCreate.day;
      DateTime hoje = DateTime.now();
      if (day >= method.bestDay) {
        setState(() {
          this._methodId = _methodId;
          _dtDueController.text = DT_FORMAT.format(new DateTime(hoje.year, hoje.month + 1, method.paymentDay));
        });
      }
    } else {
      setState(() {
        this._methodId = _methodId;
        _dtDueController.text = DT_FORMAT.format(_dtCreate);
      });
    }
  }

  _subdivisionOptionChange(int opt) async {
    if (opt == null) return;
    setState(() {
      this._installmentOption = opt;
    });
  }

  _edit(TransacModel transac) async {
    var _wrs = await WrapperService().findByForecast(widget._forecastId);
    var _methods = await MethodsService().findAll();

    setState(() {
      this._wrappers = _wrs;
      this._methods = _methods;

      this._wrapperId = transac?.wrapper?.id ?? widget._startWrapperId;
      this._methodId = transac?.method?.id ?? _methods[0].id;
      this._valueController.text = transac?.value == null ? null : Utils.numberFormat.format(transac?.value);
      this._descrController.text = transac?.descr;
      this._dtCreateController.text = DT_FORMAT.format(transac?.dtCreate ?? DateTime.now());
      this._dtDueController.text = DT_FORMAT.format(transac?.dtDue ?? DateTime.now());
    });

    if (transac.id == null) {
      await _wrapperIdChange(transac?.wrapper?.id ?? widget._startWrapperId);
    }
  }

  _save() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    this._transac.wrapper = WrapperModel.id(this._wrapperId);
    this._transac.method = MethodModel.id(this._methodId);
    this._transac.descr = this._descrController.text;
    this._transac.value = Utils.numberFormat.parse(this._valueController.text);
    this._transac.dtCreate = this._dtCreateController.text.length == 0 ? DateTime.now() : DT_FORMAT.parse(this._dtCreateController.text);
    this._transac.dtDue = this._dtDueController.text.length == 0 ? DateTime.now() : DT_FORMAT.parse(this._dtDueController.text);

    final num _installmentCount = this._subdivisionController.text.length > 0 ? Utils.numberFormat.parse(this._subdivisionController.text) : 0;
    transacService.persist(this._transac, _installmentCount.toInt(), this._installmentOption);

    Navigator.pop(context, true);
  }

  _pickDate(BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.text.length == 0 ? DateTime.now() : DT_FORMAT.parse(controller.text),
      firstDate: new DateTime(2020, 1),
      lastDate: new DateTime(2050, 12),
    );

    if (picked != null) {
      setState(() {
        controller.text = DT_FORMAT.format(picked);
      });
    }
  }
}
