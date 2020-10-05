class MethodModel {
  int id;
  String name;
  int type;
  int bestDay;
  int paymentDay;

  MethodModel({this.id, this.name, this.type, this.bestDay, this.paymentDay});
  MethodModel.id(this.id);
  MethodModel.all(this.id, this.name, this.type, this.bestDay, this.paymentDay);

  factory MethodModel.fromMap(Map<String, dynamic> json) => new MethodModel.all(
        json["met_id"],
        json["met_name"],
        json["met_type"],
        json["met_best_day"],
        json["met_payment_day"],
      );

  Map<String, dynamic> toMap() => {
        "met_id": id,
        "met_name": name,
        "met_type": type,
        "met_best_day": bestDay,
        "met_payment_day": paymentDay,
      };
}
