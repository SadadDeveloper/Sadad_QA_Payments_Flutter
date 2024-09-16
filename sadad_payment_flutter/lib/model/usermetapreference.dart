// To parse this JSON data, do
//
//     final userMetaPreference = userMetaPreferenceFromJson(jsonString);

import 'dart:convert';

List<UserMetaPreference> userMetaPreferenceFromJson(String str) => List<UserMetaPreference>.from(json.decode(str).map((x) => UserMetaPreference.fromJson(x)));

String userMetaPreferenceToJson(List<UserMetaPreference> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserMetaPreference {
  UserMetaPreference({
    this.receivedpaymentpush,
    this.receivedpaymentsms,
    this.receivedpaymentemail,
    this.transferpush,
    this.transfersms,
    this.transferemail,
    this.receivedorderspush,
    this.receivedordersms,
    this.receivedorderemail,
    this.receivedrequestforpaymentpush,
    this.receivedrequestforpaymentsms,
    this.receivedrequestforpaymentemail,
    this.orderpush,
    this.ordersms,
    this.orderemail,
    this.lastloginip,
    this.lastlogindatetime,
    this.createdby,
    this.modifiedby,
    this.isplayasound,
    this.isArabic,
    this.isInternational,
    this.maxaddfundamt,
    this.allowrecurringpayment,
    this.reminderdays,
    this.issavecreditcardajax,
    this.isallowsecretkey,
    this.assignedoriginator,
    this.isusercomission,
    this.isinternationalcreditcard,
    this.allowcountries,
    this.isdebitcardallowforwebcheckout,
    this.allowCountryHistory,
    this.receiveotpvia,
    this.isallowedtosavecard,
    this.isallowedtodirectpayment,
    this.isallowedtocybersourcevisa,
    this.isallowedtocybersourcemastercard,
    this.isallowedtoapplepay,
    this.isallowedtogooglepay,
    this.isallowedtoamex,
    this.id,
    this.userId,
    this.user,
  });

  bool? receivedpaymentpush;
  bool? receivedpaymentsms;
  bool? receivedpaymentemail;
  bool? transferpush;
  bool? transfersms;
  bool? transferemail;
  bool? receivedorderspush;
  bool? receivedordersms;
  bool? receivedorderemail;
  bool? receivedrequestforpaymentpush;
  bool? receivedrequestforpaymentsms;
  bool? receivedrequestforpaymentemail;
  bool? orderpush;
  bool? ordersms;
  bool? orderemail;
  String? lastloginip;
  DateTime? lastlogindatetime;
  int? createdby;
  int? modifiedby;
  String? isplayasound;
  bool? isArabic;
  bool? isInternational;
  dynamic maxaddfundamt;
  bool? allowrecurringpayment;
  int? reminderdays;
  bool? issavecreditcardajax;
  bool? isallowsecretkey;
  int? assignedoriginator;
  int? isusercomission;
  bool? isinternationalcreditcard;
  dynamic allowcountries;
  bool? isdebitcardallowforwebcheckout;
  dynamic allowCountryHistory;
  int? receiveotpvia;
  bool? isallowedtosavecard;
  bool? isallowedtodirectpayment;
  bool? isallowedtocybersourcevisa;
  bool? isallowedtocybersourcemastercard;
  bool? isallowedtoapplepay;
  bool? isallowedtogooglepay;
  bool? isallowedtoamex;
  int? id;
  String? userId;
  User? user;

  factory UserMetaPreference.fromJson(Map<String, dynamic> json) => UserMetaPreference(
    receivedpaymentpush: json["receivedpaymentpush"],
    receivedpaymentsms: json["receivedpaymentsms"],
    receivedpaymentemail: json["receivedpaymentemail"],
    transferpush: json["transferpush"],
    transfersms: json["transfersms"],
    transferemail: json["transferemail"],
    receivedorderspush: json["receivedorderspush"],
    receivedordersms: json["receivedordersms"],
    receivedorderemail: json["receivedorderemail"],
    receivedrequestforpaymentpush: json["receivedrequestforpaymentpush"],
    receivedrequestforpaymentsms: json["receivedrequestforpaymentsms"],
    receivedrequestforpaymentemail: json["receivedrequestforpaymentemail"],
    orderpush: json["orderpush"],
    ordersms: json["ordersms"],
    orderemail: json["orderemail"],
    lastloginip: json["lastloginip"],
    lastlogindatetime: json["lastlogindatetime"] == null ? null : DateTime.parse(json["lastlogindatetime"]),
    createdby: json["createdby"],
    modifiedby: json["modifiedby"],
    isplayasound: json["isplayasound"],
    isArabic: json["isArabic"],
    isInternational: json["isInternational"],
    maxaddfundamt: json["maxaddfundamt"],
    allowrecurringpayment: json["allowrecurringpayment"],
    reminderdays: json["reminderdays"],
    issavecreditcardajax: json["issavecreditcardajax"],
    isallowsecretkey: json["isallowsecretkey"],
    assignedoriginator: json["assignedoriginator"],
    isusercomission: json["isusercomission"],
    isinternationalcreditcard: json["isinternationalcreditcard"],
    allowcountries: json["allowcountries"],
    isdebitcardallowforwebcheckout: json["isdebitcardallowforwebcheckout"],
    allowCountryHistory: json["allowCountryHistory"],
    receiveotpvia: json["receiveotpvia"],
    isallowedtosavecard: json["isallowedtosavecard"],
    isallowedtodirectpayment: json["isallowedtodirectpayment"],
    isallowedtocybersourcevisa: json["isallowedtocybersourcevisa"],
    isallowedtocybersourcemastercard: json["isallowedtocybersourcemastercard"],
    isallowedtoapplepay: json["isallowedtoapplepay"],
    isallowedtogooglepay: json["isallowedtogooglepay"],
    isallowedtoamex: json["isallowedtoamex"],
    id: json["id"],
    userId: json["userId"] == null ? "" : json["userId"].toString(),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "receivedpaymentpush": receivedpaymentpush,
    "receivedpaymentsms": receivedpaymentsms,
    "receivedpaymentemail": receivedpaymentemail,
    "transferpush": transferpush,
    "transfersms": transfersms,
    "transferemail": transferemail,
    "receivedorderspush": receivedorderspush,
    "receivedordersms": receivedordersms,
    "receivedorderemail": receivedorderemail,
    "receivedrequestforpaymentpush": receivedrequestforpaymentpush,
    "receivedrequestforpaymentsms": receivedrequestforpaymentsms,
    "receivedrequestforpaymentemail": receivedrequestforpaymentemail,
    "orderpush": orderpush,
    "ordersms": ordersms,
    "orderemail": orderemail,
    "lastloginip": lastloginip,
    "lastlogindatetime": lastlogindatetime?.toIso8601String(),
    "createdby": createdby,
    "modifiedby": modifiedby,
    "isplayasound": isplayasound,
    "isArabic": isArabic,
    "isInternational": isInternational,
    "maxaddfundamt": maxaddfundamt,
    "allowrecurringpayment": allowrecurringpayment,
    "reminderdays": reminderdays,
    "issavecreditcardajax": issavecreditcardajax,
    "isallowsecretkey": isallowsecretkey,
    "assignedoriginator": assignedoriginator,
    "isusercomission": isusercomission,
    "isinternationalcreditcard": isinternationalcreditcard,
    "allowcountries": allowcountries,
    "isdebitcardallowforwebcheckout": isdebitcardallowforwebcheckout,
    "allowCountryHistory": allowCountryHistory,
    "receiveotpvia": receiveotpvia,
    "isallowedtosavecard": isallowedtosavecard,
    "isallowedtodirectpayment": isallowedtodirectpayment,
    "isallowedtocybersourcevisa": isallowedtocybersourcevisa,
    "isallowedtocybersourcemastercard": isallowedtocybersourcemastercard,
    "isallowedtoapplepay": isallowedtoapplepay,
    "isallowedtogooglepay": isallowedtogooglepay,
    "isallowedtoamex": isallowedtoamex,
    "id": id,
    "userId": userId,
    "user": user?.toJson(),
  };
}

class User {
  User({
    this.sadadId,
    this.id,
  });

  String? sadadId;
  int? id;

  factory User.fromJson(Map<String, dynamic> json) => User(
    sadadId: json["SadadId"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "SadadId": sadadId,
    "id": id,
  };
}
