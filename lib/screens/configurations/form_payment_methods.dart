import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:salveSeuPorquinho/components/async_builder.dart';
import 'package:salveSeuPorquinho/models/method_model.dart';
import 'package:salveSeuPorquinho/services/methods_service.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:salveSeuPorquinho/utils/validation_utils.dart';

class FormPaymentMethods extends StatefulWidget {
  FormPaymentMethods({Key key}) : super(key: key);

  @override
  _FormPaymentMethodsState createState() => _FormPaymentMethodsState();
}

class _FormPaymentMethodsState extends State<FormPaymentMethods> {
  static const String _HEADER_TEXT = "Formas de pagamento";

  static const String _NEW_TEXT_BUTTON = "Nova forma";
  static const String _SAVE_TEXT_BUTTON = "Salvar";
  static const String _CANCEL_TEXT_BUTTON = "Cancelar";

  static const String _NEW_METHOD_TEXT = "Nova Forma";
  static const String _EDIT_METHOD_TEXT = "Editar Forma";

  static const String _NAME_TEXT = "Nome";
  static const String _TYPE_TEXT = "Tipo";
  static const String _BEST_DAY_TEXT = "Melhor dia para compras";
  static const String _PAYMENT_DAY_TEXT = "Dia de pagamento da fatura";

  final MethodsService _methodsService = new MethodsService();

  MethodModel _record;
  int _type = 1;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _bestDayController = new TextEditingController();
  TextEditingController _paymentDayController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (_record == null) {
      return Container(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _HEADER_TEXT,
                  style: ThemeUtils.thinText,
                ),
                RaisedButton(
                  child: Row(
                    children: <Widget>[Icon(Icons.add), Text(_NEW_TEXT_BUTTON)],
                  ),
                  onPressed: () => _edit(new MethodModel()),
                )
              ],
            ),
            new AsyncBuilder<List<MethodModel>>(
              _findMethods(),
              "Buscando Formas de Pagamento",
              "Nenhuma Forma Localizada",
              List<MethodModel>(),
              (methods) {
                return Column(
                  children: <Widget>[
                    new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: methods.length,
                      itemBuilder: (context, i) {
                        return _buildRow(methods[i]);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8),
        child: Wrap(
          runSpacing: 20,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _record.id == null ? _NEW_METHOD_TEXT : _EDIT_METHOD_TEXT,
                )
              ],
            ),
            Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 20,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: ThemeUtils.inputDecoration.copyWith(labelText: _NAME_TEXT),
                    validator: REQUIRED,
                  ),
                  DropdownButtonFormField<int>(
                    items: _getTypeItems(),
                    value: _type,
                    onChanged: (option) => _typeChange(option),
                    decoration: new InputDecoration(labelText: _TYPE_TEXT),
                  ),
                  if (_type == 2)
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.numberWithOptions(decimal: false),
                          controller: _bestDayController,
                          decoration: ThemeUtils.inputDecoration.copyWith(labelText: _BEST_DAY_TEXT),
                          validator: REQUIRED,
                          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: false),
                            controller: _paymentDayController,
                            decoration: ThemeUtils.inputDecoration.copyWith(labelText: _PAYMENT_DAY_TEXT),
                            validator: REQUIRED,
                            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
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
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    _edit(null);
                  },
                  child: Text(
                    _CANCEL_TEXT_BUTTON,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRow(MethodModel method) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        width: double.maxFinite,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFF12121A),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: InkWell(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${method.name}"),
                ],
              ),
            ),
            onTap: () {
              _edit(method);
            },
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> _getTypeItems() {
    return [
      new DropdownMenuItem(value: 1, child: Text("A vista")),
      new DropdownMenuItem(value: 2, child: Text("Crédito")),
    ];
  }

  _typeChange(int opt) async {
    if (opt == null) return;
    setState(() {
      this._type = opt;
    });
  }

  Future<List<MethodModel>> _findMethods() async {
    List<MethodModel> categories = await _methodsService.findAll();
    return categories;
  }

  _edit(MethodModel method) {
    setState(() {
      this._nameController.text = method?.name ?? "";
      this._type = method?.type ?? 1;
      this._record = method;
      this._bestDayController.text = (method?.bestDay ?? 1).toString();
      this._paymentDayController.text = (method?.paymentDay ?? 10).toString();
    });
  }

  _save() {
    this._record.name = this._nameController.text;
    this._record.type = this._type ?? 1;
    this._record.bestDay = int.parse(this._bestDayController?.text?.length == 0 ? "1" : this._bestDayController?.text);
    this._record.paymentDay = int.parse(this._paymentDayController?.text?.length == 0 ? "10" : this._paymentDayController?.text);

    _methodsService.persist(this._record);
    setState(() {
      this._record = null;
    });
  }
}
