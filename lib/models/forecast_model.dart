// CategoryModel categoryFromJson(String str) {
//   final jsonData = json.decode(str);
//   return CategoryModel.fromMap(jsonData);
// }

// String categoryToJson(CategoryModel data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }



class ForecastModel {
  int id;
  int mounth;
  int year;
  double invoice;

  ForecastModel({this.id, this.mounth, this.year, this.invoice});
  ForecastModel.id(this.id);
  ForecastModel.all(this.id, this.mounth, this.year, this.invoice);

  factory ForecastModel.fromMap(Map<String, dynamic> json) => new ForecastModel.all(
        json["for_id"],
        json["for_mounth"],
        json["for_year"],
        json["for_invoice"] == null ? 0 : json["for_invoice"] + .0,
      );

  Map<String, dynamic> toMap() => {
        "for_id": id,
        "for_mounth": mounth,
        "for_year": year,
        "for_invoice": invoice,
      };
}
