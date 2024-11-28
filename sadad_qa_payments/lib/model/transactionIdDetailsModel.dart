import 'dart:convert';

TransactionIdDetailsModel transactionIdDetailsModelFromJson(String str) =>
    TransactionIdDetailsModel.fromJson(json.decode(str));

String transactionIdDetailsModelToJson(TransactionIdDetailsModel data) => json.encode(data.toJson());

class TransactionIdDetailsModel {
  TransactionIdDetailsModel({
    this.invoicenumber,
    this.verificationstatus,
    this.isRefund,
    this.amount,
    this.servicecharge,
    this.servicechargedescription,
    this.transactionSummary,
    this.txnip,
    this.txniptrackervalue,
    this.isSuspicious,
    this.isFraud,
    this.openingBalance,
    this.osHistory,
    this.creditcardpaymentmodeid,
    this.txnBankStatus,
    this.sourceofTxn,
    this.id,
    this.transactiondate,
    this.deletedAt,
    this.created,
    this.modified,
    this.transactionentityId,
    this.transactionmodeId,
    this.transactionstatusId,
    this.cardschemeid,
    this.hash,
    this.sadadId,
    this.receiverId,
  });

  String? invoicenumber;
  bool? verificationstatus;
  bool? isRefund;
  double? amount;
  double? servicecharge;
  Servicechargedescription? servicechargedescription;
  TransactionSummary? transactionSummary;
  String? txnip;
  String? txniptrackervalue;
  int? isSuspicious;
  bool? isFraud;
  String? openingBalance;
  List<OsHistory>? osHistory;
  int? creditcardpaymentmodeid;
  List<TxnBankStatus>? txnBankStatus;
  int? sourceofTxn;
  int? id;
  DateTime? transactiondate;
  dynamic deletedAt;
  DateTime? created;
  DateTime? modified;
  int? transactionentityId;
  int? transactionmodeId;
  int? transactionstatusId;
  int? cardschemeid;
  String? hash;
  String? sadadId;
  int? receiverId;

  factory TransactionIdDetailsModel.fromJson(Map<String, dynamic> json) => TransactionIdDetailsModel(
        invoicenumber: json["invoicenumber"],
        verificationstatus: json["verificationstatus"],
        isRefund: json["isRefund"],
        amount: json["amount"]?.toDouble(),
        servicecharge: json["servicecharge"]?.toDouble(),
        servicechargedescription: json["servicechargedescription"] == null
            ? null
            : Servicechargedescription.fromJson(json["servicechargedescription"]),
        transactionSummary:
            json["transaction_summary"] == null ? null : TransactionSummary.fromJson(json["transaction_summary"]),
        txnip: json["txnip"],
        txniptrackervalue: json["txniptrackervalue"],
        isSuspicious: json["is_suspicious"],
        isFraud: json["isFraud"],
        openingBalance: json["opening_balance"],
        osHistory: json["os_history"] == null
            ? []
            : List<OsHistory>.from(json["os_history"]!.map((x) => OsHistory.fromJson(x))),
        creditcardpaymentmodeid: json["creditcardpaymentmodeid"],
        txnBankStatus: json["txn_bank_status"] == null
            ? []
            : List<TxnBankStatus>.from(json["txn_bank_status"]!.map((x) => TxnBankStatus.fromJson(x))),
        sourceofTxn: json["sourceofTxn"],
        id: json["id"],
        transactiondate: json["transactiondate"] == null ? null : DateTime.parse(json["transactiondate"]),
        deletedAt: json["deletedAt"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
        transactionentityId: json["transactionentityId"],
        transactionmodeId: json["transactionmodeId"],
        transactionstatusId: json["transactionstatusId"],
        cardschemeid: json["cardschemeid"],
        hash: json["hash"],
        sadadId: json["SadadId"],
        receiverId: json["receiverId"],
      );

  Map<String, dynamic> toJson() => {
        "invoicenumber": invoicenumber,
        "verificationstatus": verificationstatus,
        "isRefund": isRefund,
        "amount": amount,
        "servicecharge": servicecharge,
        "servicechargedescription": servicechargedescription?.toJson(),
        "transaction_summary": transactionSummary?.toJson(),
        "txnip": txnip,
        "txniptrackervalue": txniptrackervalue,
        "is_suspicious": isSuspicious,
        "isFraud": isFraud,
        "opening_balance": openingBalance,
        "os_history": osHistory == null ? [] : List<dynamic>.from(osHistory!.map((x) => x.toJson())),
        "creditcardpaymentmodeid": creditcardpaymentmodeid,
        "txn_bank_status": txnBankStatus == null ? [] : List<dynamic>.from(txnBankStatus!.map((x) => x.toJson())),
        "sourceofTxn": sourceofTxn,
        "id": id,
        "transactiondate":
            "${transactiondate!.year.toString().padLeft(4, '0')}-${transactiondate!.month.toString().padLeft(2, '0')}-${transactiondate!.day.toString().padLeft(2, '0')}",
        "deletedAt": deletedAt,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "transactionentityId": transactionentityId,
        "transactionmodeId": transactionmodeId,
        "transactionstatusId": transactionstatusId,
        "cardschemeid": cardschemeid,
        "hash": hash,
        "SadadId": sadadId,
        "receiverId": receiverId,
      };
}

class OsHistory {
  OsHistory({
    this.datetime,
    this.os,
  });

  DateTime? datetime;
  String? os;

  factory OsHistory.fromJson(Map<String, dynamic> json) => OsHistory(
        datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        os: json["os"],
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime?.toIso8601String(),
        "os": os,
      };
}

class Servicechargedescription {
  Servicechargedescription({
    this.percentage,
    this.percentageAmount,
    this.minCommissionAmount,
    this.orderCommission,
    this.fixedCommssion,
  });

  double? percentage;
  double? percentageAmount;
  double? minCommissionAmount;
  double? orderCommission;
  double? fixedCommssion;

  factory Servicechargedescription.fromJson(Map<String, dynamic> json) => Servicechargedescription(
      percentage: json["Percentage"]?.toDouble(),
      percentageAmount: json["PercentageAmount"]?.toDouble(),
      minCommissionAmount: json["MinCommissionAmount"]?.toDouble(),
      orderCommission: json["orderCommission"]?.toDouble(),
      fixedCommssion: json["FixedCommssion"]?.toDouble());

  Map<String, dynamic> toJson() => {
        "Percentage": percentage,
        "PercentageAmount": percentageAmount,
        "MinCommissionAmount": minCommissionAmount,
        "orderCommission": orderCommission,
        "FixedCommssion": fixedCommssion,
      };
}

class TransactionSummary {
  TransactionSummary({
    this.mobileNo,
    this.txnAmount,
    this.productDetails,
  });

  String? mobileNo;
  double? txnAmount;
  List<dynamic>? productDetails;

  factory TransactionSummary.fromJson(Map<String, dynamic> json) => TransactionSummary(
        mobileNo: json["MOBILE_NO"],
        txnAmount: json["TXN_AMOUNT"]?.toDouble(),
        productDetails:
            json["PRODUCT_DETAILS"] == null ? [] : List<dynamic>.from(json["PRODUCT_DETAILS"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "MOBILE_NO": mobileNo,
        "TXN_AMOUNT": txnAmount,
        "PRODUCT_DETAILS": productDetails == null ? [] : List<dynamic>.from(productDetails!.map((x) => x)),
      };
}

class TxnBankStatus {
  TxnBankStatus({
    this.date,
    this.txnId,
    this.code,
    this.message,
  });

  DateTime? date;
  String? txnId;
  String? code;
  String? message;

  factory TxnBankStatus.fromJson(Map<String, dynamic> json) => TxnBankStatus(
        date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
        txnId: json["TxnID"],
        code: json["Code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "Date": date?.toIso8601String(),
        "TxnID": txnId,
        "Code": code,
        "message": message,
      };
}
