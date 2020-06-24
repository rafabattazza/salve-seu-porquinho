import 'package:salveSeuPorquinho/models/category_model.dart';
import 'package:salveSeuPorquinho/models/prevision_model.dart';

class WrapperModel {
  int id;
  PrevisionModel prevision;
  CategoryModel category;
  String name;
  double budget;
  
  WrapperModel({this.id, this.prevision, this.category, this.name, this.budget});
  WrapperModel.id(this.id);
  WrapperModel.all(this.id, this.prevision, this.category, this.name, this.budget);

  factory WrapperModel.fromMap(Map<String, dynamic> json) => new WrapperModel.all(
        json["wra_id"],
        PrevisionModel.fromMap(json),
        CategoryModel.fromMap(json),
        json["wra_name"],
        json["wra_budget"]
      );

  Map<String, dynamic> toMap() => {
        "wra_id": id,
        "wra_prevision": prevision.id,
        "wra_category": category.id,
        "wra_name": name,
        "wra_budget": budget
      };
}
