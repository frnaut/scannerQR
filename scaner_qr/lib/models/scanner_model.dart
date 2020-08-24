import 'package:latlong/latlong.dart';

class ScannerModel {
  int id;
  String type;
  String value;

  ScannerModel({
    this.id,
    this.type,
    this.value,
  }) {
    if (this.value.contains("http")) {
      this.type = "http";
    }
    if (this.value.contains("geo")) {
      this.type = "geo";
    }
  }

  factory ScannerModel.fromJson(Map<String, dynamic> json) => ScannerModel(
        id: json["id"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };

  getLtdLng() {
    if (type == "geo") {
      List<String> geo = value.substring(4).split(",");

      return LatLng(double.parse(geo[0]), double.parse(geo[1]));
    }
  }
}
