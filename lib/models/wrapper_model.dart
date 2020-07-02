import 'package:salveSeuPorquinho/models/category_model.dart';

import 'forecast_model.dart';

class WrapperModel {
  int id;
  ForecastModel forecast;
  CategoryModel category;
  String name;
  double budget;

  WrapperModel({this.id, this.forecast, this.category, this.name, this.budget});
  WrapperModel.id(this.id);
  WrapperModel.all(
      this.id, this.forecast, this.category, this.name, this.budget);

  double sumTransactions;

  factory WrapperModel.fromMap(Map<String, dynamic> json) =>
      new WrapperModel.all(
          json["wra_id"],
          ForecastModel.fromMap(json),
          CategoryModel.fromMap(json),
          json["wra_name"],
          json["wra_budget"] + .0);

  Map<String, dynamic> toMap() => {
        "wra_id": id,
        "wra_forecast": forecast.id,
        "wra_category": category.id,
        "wra_name": name,
        "wra_budget": budget
      };
}
