import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:salveSeuPorquinho/models/transac_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/services/database/transac_dao.dart';
import 'package:salveSeuPorquinho/services/database/wrapper_dao.dart';
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
  static const String _VALUE_TEXT = "Valor";
  static const String _DESCR_TEXT = "Descrição";
  static const String _DATE_TEXT = "Dia";
  static const String _TIME_TEXT = "Hora";

  static const String _SAVE_TEXT_BUTTON = "Salvar";

  TransacDAO transacDao = TransacDAO();

  TransacModel _transac;
  _FormEntryState(this._transac);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._edit(this._transac);
    });
  }

  int _wrapperId;
  List<WrapperModel> _wrappers;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descrController = new TextEditingController();
  final TextEditingController _valueController = new TextEditingController();
  final TextEditingController _dataController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_HEADER_TEXT),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5D57EA), Color(0xFF9647DB)]),
          ),
        ),
        elevation: 0,
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
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _valueController,
                      decoration: new InputDecoration(
                          labelText: _VALUE_TEXT,
                          prefixIcon: Icon(Icons.monetization_on)),
                      validator: REQUIRED,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
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
                            controller: _dataController,
                            decoration: new InputDecoration(
                              labelText: _DATE_TEXT,
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 4, right: 4)),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _timeController,
                            decoration: new InputDecoration(
                              labelText: _TIME_TEXT,
                              prefixIcon: Icon(Icons.access_time),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      _save();
                    },
                    child: Text(
                      _SAVE_TEXT_BUTTON,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
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

  _wrapperIdChange(int _wrapperId) async {
    if (_wrapperId == null) return;
    String _lastDescr = "";
    _lastDescr = (await transacDao.findLastDescr(_wrapperId)) ??
        _wrappers.firstWhere((wr) => wr.id == _wrapperId).name + " - ";

    setState(() {
      this._wrapperId = _wrapperId;
      this._descrController.text = _lastDescr;
    });
  }

  _edit(TransacModel transac) async {
    var _wrs = await WrapperDAO().findByForecast(widget._forecastId);

    setState(() {
      this._wrappers = _wrs;

      this._wrapperId = transac?.wrapper?.id ?? widget._startWrapperId;
      this._valueController.text = transac?.value == null
          ? null
          : Utils.numberFormat.format(transac?.value);
      this._descrController.text = transac?.descr;
      this._dataController.text =
          new DateFormat("dd/MM/yyyy").format(transac?.date ?? DateTime.now());
      this._timeController.text =
          new DateFormat("HH:mm").format(transac?.date ?? DateTime.now());
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
    this._transac.descr = this._descrController.text;
    this._transac.value = Utils.numberFormat.parse(this._valueController.text);
    this._transac.date = this._transac.date ??
        DateTime.now(); // TODO implementar o date/timer pick

    print(this._transac.toMap());
    transacDao.persist(this._transac);

    Navigator.pop(context, true);
  }
}
