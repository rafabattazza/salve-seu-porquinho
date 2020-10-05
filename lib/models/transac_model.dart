import 'package:salveSeuPorquinho/models/method_model.dart';
import 'package:salveSeuPorquinho/models/wrapper_model.dart';
import 'package:salveSeuPorquinho/utils/utils.dart';

class TransacModel {
  int id;
  WrapperModel wrapper;
  MethodModel method;
  String descr;
  double value;
  DateTime dtCreate;
  DateTime dtDue;

  TransacModel({this.id, this.wrapper, this.method, this.descr, this.value, this.dtCreate, this.dtDue});
  TransacModel.id(this.id);
  TransacModel.all(this.id, this.wrapper, this.method, this.descr, this.value, this.dtCreate, this.dtDue);

  factory TransacModel.fromMap(Map<String, dynamic> json) => new TransacModel.all(
        json["tra_id"],
        WrapperModel.fromMap(json),
        MethodModel.fromMap(json),
        json["tra_descr"],
        json["tra_value"] == null ? null : json["tra_value"] + .0,
        json["tra_dt_create"] == null ? null : Utils.dbDateFormat.parse(json["tra_dt_create"]),
        json["tra_dt_due"] == null ? null : Utils.dbDateFormat.parse(json["tra_dt_due"]),
      );

  Map<String, dynamic> toMap() => {
        "tra_id": id,
        "tra_wrapper": wrapper.id,
        "tra_method": method.id,
        "tra_descr": descr,
        "tra_value": value,
        "tra_dt_create": Utils.dbDateFormat.format(dtCreate),
        "tra_dt_due": Utils.dbDateFormat.format(dtDue),
      };
}
