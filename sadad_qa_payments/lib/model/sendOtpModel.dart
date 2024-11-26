// To parse this JSON data, do
//
//     final sendOtpModel = sendOtpModelFromJson(jsonString);

import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) => SendOtpModel.fromJson(json.decode(str));

String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());

class SendOtpModel {
  String? id;
  int? ttl;
  DateTime? created;
  int? userId;
  int? receiveotpvia;

  SendOtpModel({
    this.id,
    this.ttl,
    this.created,
    this.userId,
    this.receiveotpvia,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
    id: json["id"],
    ttl: json["ttl"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    userId: json["userId"],
    receiveotpvia: json["receiveotpvia"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ttl": ttl,
    "created": created?.toIso8601String(),
    "userId": userId,
    "receiveotpvia": receiveotpvia,
  };
}
