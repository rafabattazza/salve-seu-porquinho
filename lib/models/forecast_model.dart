// CategoryModel categoryFromJson(String str) {
//   final jsonData = json.decode(str);
//   return CategoryModel.fromMap(jsonData);
// }

// String categoryToJson(CategoryModel data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }

import 'package:salveSeuPorquinho/models/category_model.dart';

class ForecastModel {
  int id;
  int month;
  int year;
  double invoice;

  ForecastModel({this.id, this.month, this.year, this.invoice});
  ForecastModel.id(this.id);
  ForecastModel.all(this.id, this.month, this.year, this.invoice);

  List<CategoryModel> categories;

  double sumCategoriesSpent() {
    if (categories == null) return 0;

    return categories
        .map((e) => e.sumWrappersSpent())
        .reduce((value, element) => value + element);

    // double total = 0.0;
    // categories.forEach((category) {
    //   (category.groupedWrappers ?? []).forEach((wrapper) {
    //     total += wrapper.sumTransactions ?? 0;
    //   });
    // });
    // return total;
  }

  factory ForecastModel.fromMap(Map<String, dynamic> json) =>
      new ForecastModel.all(
        json["for_id"],
        json["for_month"],
        json["for_year"],
        json["for_invoice"] == null ? 0 : json["for_invoice"] + .0,
      );

  Map<String, dynamic> toMap() => {
        "for_id": id,
        "for_month": month,
        "for_year": year,
        "for_invoice": invoice,
      };
}
