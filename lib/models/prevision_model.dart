// CategoryModel categoryFromJson(String str) {
//   final jsonData = json.decode(str);
//   return CategoryModel.fromMap(jsonData);
// }

// String categoryToJson(CategoryModel data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }



class PrevisionModel {
  int id;
  int mounth;
  int year;
  double invoice;

  PrevisionModel({this.id, this.mounth, this.year, this.invoice});
  PrevisionModel.id(this.id);
  PrevisionModel.all(this.id, this.mounth, this.year, this.invoice);

  factory PrevisionModel.fromMap(Map<String, dynamic> json) => new PrevisionModel.all(
        json["pre_id"],
        json["pre_mounth"],
        json["pre_year"],
        json["pre_invoice"] + .0,

      );

  Map<String, dynamic> toMap() => {
        "pre_id": id,
        "pre_mounth": mounth,
        "pre_year": year,
        "pre_invoice": invoice,
      };
}
