import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:salveSeuPorquinho/components/async_builder.dart';
import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/services/database/category_dao.dart';
import 'package:salveSeuPorquinho/utils/theme_utils.dart';
import 'package:salveSeuPorquinho/utils/validation_utils.dart';

class FormCategories extends StatefulWidget {
  FormCategories({Key key}) : super(key: key);

  @override
  _FormCategoriesState createState() => _FormCategoriesState();
}

class _FormCategoriesState extends State<FormCategories> {
  static const String _HEADER_TEXT = "Lista de categorias";

  static const String _NEW_TEXT_BUTTON = "Novo";
  static const String _SAVE_TEXT_BUTTON = "Salvar";
  static const String _CANCEL_TEXT_BUTTON = "Cancelar";
  static const String _DELETE_TEXT_BUTTON = "Excluir";
  static const String _UNDO_TEXT_BUTTON = "Desfazer";

  static const String _NEW_CATEGORY_TEXT = "Nova Categoria";
  static const String _EDIT_CATEGORY_TEXT = "Editar Categoria";

  static const String _NAME_TEXT = "Nome da categoria";
  static const String _PERCENT_TEXT = "Precentual %";
  static const String _PERCENT_VALIDATION = "Atenção a soma dos percentuais deve ser igual 100%. Sua soma está em {1}% você deve {2}%";
  static const String _DELETED_TEXT = "Categoria excluída!";
  static const String _CORRECT_TEXT_BUTTON = "Corrigir Automaticamente";

  final CategoryDAO _categoryDao = new CategoryDAO();

  CategoryModel _record;
  int _percentTotal = 0;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _percentController = new TextEditingController();
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
                  onPressed: () => _edit(new CategoryModel()),
                )
              ],
            ),
            new AsyncBuilder<List<CategoryModel>>(
              _findCategories(),
              "Buscando Categorias",
              "Nenhuma Categoria Localizada",
              List<CategoryModel>(),
              (categories) {
                return Column(
                  children: <Widget>[
                    if (_percentTotal != 100 && categories.length > 0)
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Column(
                          children: <Widget>[
                            Text(
                              _validationText,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            Center(
                              child: RaisedButton(
                                onPressed: () => _correctPercentages(),
                                child: Text(
                                  _CORRECT_TEXT_BUTTON,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: categories.length,
                      itemBuilder: (context, i) {
                        return _buildRow(categories[i]);
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
                  _record.id == null ? _NEW_CATEGORY_TEXT : _EDIT_CATEGORY_TEXT,
                ),
                if (_record.id != null)
                  RaisedButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text(_DELETE_TEXT_BUTTON),
                    color: Colors.orange,
                    onPressed: _delete,
                  ),
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
                    decoration: ThemeUtils.inputDecoration
                        .copyWith(labelText: _NAME_TEXT),
                    validator: REQUIRED,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _percentController,
                    decoration: ThemeUtils.inputDecoration
                        .copyWith(labelText: _PERCENT_TEXT),
                    validator: REQUIRED,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
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

  Widget _buildRow(CategoryModel category) {
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
                  Text("${category.name} (${category.percent}%)"),
                ],
              ),
            ),
            onTap: () {
              _edit(category);
            },
          ),
        ),
      ),
    );
  }

  Future<List<CategoryModel>> _findCategories() async {
    List<CategoryModel> categories = await _categoryDao.findAll();
    this._percentTotal = 0;
    for (var category in categories) {
      this._percentTotal += category.percent;
    }
    return categories;
  }

  get _validationText {
    if (this._percentTotal > 100) {
      return _PERCENT_VALIDATION
          .replaceAll("{1}", _percentTotal.toString())
          .replaceAll("{2}", " subtrair ${(_percentTotal - 100)}");
    } else {
      return _PERCENT_VALIDATION
          .replaceAll("{1}", _percentTotal.toString())
          .replaceAll("{2}", " adicionar mais ${(100 - _percentTotal)}");
    }
  }

  _correctPercentages() async {
    List<CategoryModel> categories = await _categoryDao.findAll();
    int total = 0;
    for (var category in categories) {
      total += category.percent;
    }
    int dif = 100 - total;
    if (dif > 0) {
      categories[0].percent += dif;
      _categoryDao.persist(categories[0]);
    } else {
      dif = dif.abs();
      for (CategoryModel category in categories) {
        if (category.percent > dif) {
          category.percent -= dif;
          _categoryDao.persist(category);
          break;
        } else {
          int subtract = category.percent ~/ 2;
          dif -= subtract;
          category.percent -= subtract;
          _categoryDao.persist(category);
        }
      }
    }
    setState(() {});
  }

  _delete() {
    this._record.deleted = true;
    _categoryDao.persist(this._record);

    final regId = this._record.id;
    final snackBar = SnackBar(
      duration: Duration(seconds: 10),
      backgroundColor: Colors.white,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_DELETED_TEXT),
          FlatButton.icon(
            color: Colors.blue,
            icon: Icon(Icons.undo),
            onPressed: () => _undoDeleted(regId),
            label: Text(
              _UNDO_TEXT_BUTTON,
            ),
          ),
        ],
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);

    setState(() {
      this._record = null;
    });
  }

  _undoDeleted(int id) async {
    CategoryModel category = await _categoryDao.findById(id);
    category.deleted = false;
    await _categoryDao.persist(category);
    Scaffold.of(context).hideCurrentSnackBar();
    setState(() {});
  }

  _edit(CategoryModel edit) {
    setState(() {
      this._nameController.text = edit?.name != null ? edit.name : "";
      this._percentController.text =
          edit?.percent != null ? edit.percent.toString() : "";
      this._record = edit;
    });
  }

  _save() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    this._record.name = this._nameController.text;
    this._record.percent = int.parse(this._percentController.text);
    this._record.deleted = false;
    _categoryDao.persist(this._record);
    setState(() {
      this._record = null;
    });
  }
}
