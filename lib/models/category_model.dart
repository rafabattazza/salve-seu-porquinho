import 'package:salveSeuPorquinho/models/wrapper_model.dart';

class CategoryModel {
  int id;
  String name;
  int percent;
  bool deleted;

  List<WrapperModel> groupedWrappers = [];

  CategoryModel({this.id, this.name, this.percent, this.deleted});
  CategoryModel.id(this.id);
  CategoryModel.all(this.id, this.name, this.percent, this.deleted);

  double sumWrappersBudget() {
    if (groupedWrappers.length == 0) return 0;
    return groupedWrappers.map((wrapper) => wrapper.budget).reduce((value, element) => value + element);
  }

  double sumWrappersSpent() {
    if (groupedWrappers.length == 0) return 0;
    return groupedWrappers.map((wrapper) => wrapper.sumTransactions).reduce((value, element) => value + element);
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) => new CategoryModel.all(
        json["cat_id"],
        json["cat_name"],
        json["cat_percent"],
        json["cat_deleted"] == 1,
      );

  Map<String, dynamic> toMap() => {
        "cat_id": id,
        "cat_name": name,
        "cat_percent": percent,
        "cat_deleted": deleted ? 1 : 0,
      };
}
