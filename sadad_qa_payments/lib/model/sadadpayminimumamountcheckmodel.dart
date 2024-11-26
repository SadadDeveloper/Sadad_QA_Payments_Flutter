// To parse this JSON data, do
//
//     final sadadPayMinAmountCheckModel = sadadPayMinAmountCheckModelFromJson(jsonString);

import 'dart:convert';

List<SadadPayMinAmountCheckModel> sadadPayMinAmountCheckModelFromJson(String str) => List<SadadPayMinAmountCheckModel>.from(json.decode(str).map((x) => SadadPayMinAmountCheckModel.fromJson(x)));

String sadadPayMinAmountCheckModelToJson(List<SadadPayMinAmountCheckModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SadadPayMinAmountCheckModel {
  String key;
  String value;
  dynamic createdby;
  dynamic modifiedby;
  int id;
  dynamic deletedAt;
  DateTime created;
  DateTime modified;

  SadadPayMinAmountCheckModel({
    required this.key,
    required this.value,
    this.createdby,
    this.modifiedby,
    required this.id,
    this.deletedAt,
    required this.created,
    required this.modified,
  });

  factory SadadPayMinAmountCheckModel.fromJson(Map<String, dynamic> json) => SadadPayMinAmountCheckModel(
    key: json["key"],
    value: json["value"],
    createdby: json["createdby"],
    modifiedby: json["modifiedby"],
    id: json["id"],
    deletedAt: json["deletedAt"],
    created: DateTime.parse(json["created"]),
    modified: DateTime.parse(json["modified"]),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
    "createdby": createdby,
    "modifiedby": modifiedby,
    "id": id,
    "deletedAt": deletedAt,
    "created": created.toIso8601String(),
    "modified": modified.toIso8601String(),
  };
}
