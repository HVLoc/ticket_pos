//product extra dung o danh muc

import 'dart:convert';

List<ProductExtra> listProductExtraFromString(String extra) =>
    List<ProductExtra>.from(
        jsonDecode(extra).map((x) => ProductExtra.fromJson(x))).toList();

class ProductExtra {
  String? label;
  String? name;
  String? value;
  bool? visibility;

  ProductExtra({
    this.label,
    this.name,
    this.value,
    this.visibility = true,
  });
  factory ProductExtra.fromJson(Map<String, dynamic> json) => ProductExtra(
        label: json["Label"],
        name: json["Name"],
        value: json["Value"],
        visibility: json["Visibility"],
      );

  Map<String, dynamic> toJson() => {
        "Label": label,
        "Name": name,
        "Value": value,
        "Visibility": visibility,
      };
}
