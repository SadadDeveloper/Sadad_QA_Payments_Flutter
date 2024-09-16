import 'package:flutter/material.dart';
import 'package:sadad_payment_flutter/sadad_payment_flutter.dart';

class WebViewDetailsModel {
  bool? isAmexEnableForAdmin;
  int? isMasterEnableForCyber;
  int? isVisaEnableForCyber;
  int? isMasterEnableForCyberAdmin;
  int? isVisaEnableForCyberAdmin;
  String? creditcardType;
  String? sadadId;
  String? cardnumber;
  String? expiryDate;
  String? cvv;
  String? cardHolderName;
  String? customerName;
  String? contactNumber;
  String? transactionId;
  String? email;
  double? transactionAmount;
  String? token;
  String? paymentMethod;
  PackageMode? packageMode;
  List<Map> productDetail;
  String? checksum;
  String? merchantUserId;
  String? merchantSadadId;
  String? htmlString;
  String? orderID;
  final Color themeColor;
  bool? isWebContentAvailable;
  String? webContent;

  WebViewDetailsModel(
      {required this.themeColor,this.isAmexEnableForAdmin,this.orderID,
      this.isMasterEnableForCyber,
      this.isVisaEnableForCyber,
      this.isMasterEnableForCyberAdmin,
      this.isVisaEnableForCyberAdmin,
      this.creditcardType,
      this.sadadId,
      this.cardnumber,
      this.merchantSadadId,
      this.expiryDate,
      this.cvv,
      this.cardHolderName,
      this.customerName,
      this.token,
      this.paymentMethod,
      this.packageMode,
      this.contactNumber = "",
      this.productDetail = const [],
      this.transactionAmount,
      this.transactionId,
      this.email,
      this.checksum,
      this.merchantUserId,this.htmlString,this.isWebContentAvailable,this.webContent});
}
