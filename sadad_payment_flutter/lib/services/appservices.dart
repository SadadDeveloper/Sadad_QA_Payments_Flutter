import 'dart:convert';
import 'dart:developer';

import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_payment_flutter/apputils/appstrings.dart';
import 'package:sadad_payment_flutter/model/checkedallowedcountrymodel.dart';
import 'package:sadad_payment_flutter/model/creditcardsettingsmodel.dart';
import 'package:sadad_payment_flutter/model/sadadpayminimumamountcheckmodel.dart';
import 'package:sadad_payment_flutter/model/sendOtpModel.dart';
import 'package:sadad_payment_flutter/model/transactionIdDetailsModel.dart';
import 'package:sadad_payment_flutter/model/usermetapreference.dart';
import 'package:sadad_payment_flutter/services/api_endpoint.dart';

class AppServices {

  static Future<Map?> SDKSettingAPI(
      {required String token,
      required String mobileNumber,
      required double amouont,
      required List product_detail,required String issandboxmode}) async {
    final url = Uri.parse("${ApiEndPoint.settingAPI}");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = json.encode({
      "token": token,
      "mobile": mobileNumber,
      "amount": amouont,
      "product": product_detail,
      "issandboxmode" : issandboxmode
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if(result != null) {
          return result;
        } else {
          return null;
        }
      } else {
        final errorResponse = ErrorResponse.fromJson(json.decode(response.body));
        // Extract the error message
        final errorMessage = errorResponse.error.message;
        print('Error Message: $errorMessage');

        // Return the error details as a map
        return {
          'statusCode': errorResponse.error.statusCode,
          'name': errorResponse.error.name,
          'message': errorMessage,
        };
      }
    } catch (e) {
    }
  }
  static Future<dynamic> CreditCardPayment({required String card_type,
    required String token,
    required String cardsixdigit,
    required String mobileNumber,
    required double txnAmount,
    required List<Map> productDetail,
    required bool is_american_express,
    required int is_cybersourse_mastercard,
    required String credit_card_bankpage_type,
    required String hash,
    required String orderId,
    required UserMetaPreference userMetaPreference,
    required int is_cybersourse_visa, required String ipAddress, required String merchantID, required String expiryDate, required String lang, required String mobileos, required bool isAmexAllowed, required String cvv, required String email, required String cardnumber, required String cardHolderName, required String lastname, required String firstname, required String issandboxmode}) async {
    final url = Uri.parse(
      ApiEndPoint.creditCardPayment,
    );
    int TypeOfCard = 0;
    if (card_type == "Visa") {
      TypeOfCard = 1;
    } else if (card_type == "Mastercard") {
      TypeOfCard = 2;
    } else if (card_type == "Amex") {
      TypeOfCard = 3;
    }

    Map<String, String> header = {'Content-Type': 'application/json'};
    final body =  json.encode({
      "token":token,
      "cardnumber": cardnumber,
      "cardsixdigit": cardsixdigit,
      "cardType": card_type,
      "mobileNumber": mobileNumber,
      "orderId": orderId,
      "txnAmount" : txnAmount,
      "productDetail" : productDetail,
      "is_american_express" : is_american_express,
      "is_cybersourse_visa" : is_cybersourse_mastercard,
      "credit_card_bankpage_type" : credit_card_bankpage_type,
      "is_cybersourse_mastercard" : is_cybersourse_mastercard,
      "ipAddress" : ipAddress,
      "userMetaPreference" : userMetaPreference,
      "merchantID" : merchantID,
      "expiryDate" : expiryDate,
      "lang" : lang,
      "mobileos" : mobileos,
      "isAmexAllowed" : isAmexAllowed,
      "cvv" : cvv,
      "email" : email,
      "cardHolderName" : cardHolderName,
      "lastname" : lastname,
      "firstname" : firstname,
      "issandboxmode" : issandboxmode
    });
  var result = await http.post(url, headers: header, body: body);

  if (result.statusCode == 200) {
      var test = jsonDecode(result.body);
      return test;
    } else {
      final errorResponse = ErrorResponse.fromJson(json.decode(result.body));
      // Extract the error message
      final errorMessage = errorResponse.error.message;
      // Return the error details as a map
      return {
        'statusCode': errorResponse.error.statusCode,
        'name': errorResponse.error.name,
        'message': errorMessage,
      };
    }
  }
  static Future<dynamic?> debitCardPayment({required Map encodedString}) async {
    final url = Uri.parse(ApiEndPoint.debitCardPayment);
    Map<String, String> header = {'Content-Type': 'application/json'};

    final body =  json.encode({
      "token": encodedString["token"],
      "mobileNumber": encodedString["mobileNumber"],
      "orderId": encodedString["orderId"],
      "txnAmount": encodedString["txnAmount"].toString(),
      "productDetail": encodedString["productDetail"],
      "lang": encodedString["lang"],
      "issandboxmode" : encodedString["issandboxmode"],
      "mobileos" : encodedString["mobileos"],
    });
    //List<int> body = utf8.encode("encryptData=$encodedString");
    var result = await http.post(url, headers: header, body: body);

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      return response;
    } else {
      final errorResponse = ErrorResponse.fromJson(json.decode(result.body));
      // Extract the error message
      final errorMessage = errorResponse.error.message;
      print('Error Message: $errorMessage');

      // Return the error details as a map
      return {
        'statusCode': errorResponse.error.statusCode,
        'name': errorResponse.error.name,
        'message': errorMessage,
      };
    }
    return "";
  }
  static Future<dynamic> applePayment({required String token,
    required String mobileNumber,
    required double txnAmount,
    required List<Map> productDetail,
    required String checksum,
    required String orderId,
    required String ipAddress,
    required String merchantID,
    required String merchantSadadID,
    required String lang,
    required String email,
    required String firstname,
    required String transactionId,
    required String issandboxmode}) async {
    final url = Uri.parse("${ApiEndPoint.applePay}");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = json.encode({
        "token":token,
        "mobileNumber": mobileNumber,
        "orderId": orderId,
        "txnAmount" : txnAmount,
        "ProductDetails" : productDetail,
        "ipAddress" : ipAddress,
        "merchantID" : merchantID,
        "lang" : lang,
        "emailId" : email,
        "issandboxmode" : issandboxmode,
        "merchantSadadID" : merchantSadadID,
        "checksum" : checksum});
    try {
      final result = await http.post(url, headers: headers, body: body);

      if (result.statusCode == 200) {
        var test = jsonDecode(result.body);
        return test;
      } else {
        final errorResponse = ErrorResponse.fromJson(json.decode(result.body));
        // Extract the error message
        final errorMessage = errorResponse.error.message;
        print('Error Message: $errorMessage');

        // Return the error details as a map
        return {
          'statusCode': errorResponse.error.statusCode,
          'name': errorResponse.error.name,
          'message': errorMessage,
        };
      }
    } catch (e) {
    }
  }
  static Future googlePayment({
    required String encrypt_string}) async {
    final url = Uri.parse("${ApiEndPoint.googlePay}");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // final url = Uri.parse(googlePayURL);
    // Map<String, dynamic> body = {"encryptData": encodedString};
    // //List<int> body = utf8.encode("encryptData=$encodedString");
    // var result = await http.post(url, body: body);

    final body = json.encode({"encrypt_string": encrypt_string});

    try {
      final result = await http.post(url, headers: headers, body: body);

      if (result.statusCode == 200) {
        var test = jsonDecode(result.body);
        return test;
      }  else {
        final errorResponse = ErrorResponse.fromJson(json.decode(result.body));
        // Extract the error message
        final errorMessage = errorResponse.error.message;
        print('Error Message: $errorMessage');

        // Return the error details as a map
        return {
          'statusCode': errorResponse.error.statusCode,
          'name': errorResponse.error.name,
          'message': errorMessage,
        };
      }
    } catch (e) {
    }
  }
  static Future<SendOtpModel?> sadadPayLoginV6(
      {required String token, required String cellnumber, required String password, required String issandboxmode}) async {
    final url = Uri.parse(
      ApiEndPoint.sadadPayLogin,
    );
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"cellnumber": cellnumber, "password": password,"token" : token,"issandboxmode" : issandboxmode};

    var result = await http.post(
      url,
      headers: header,
      body: json.encode(body),
    );

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      SendOtpModel sendOtpModel = sendOtpModelFromJson(jsonEncode(response));
      return sendOtpModel;
    }
    return null;
  }
  static Future<Map?> sadadPayTransactionV6(
      {required String ipAddress,
        required List productDetails,
        required String token,
        required String otp,
        required int userId,
        required String orderId,
        required String issandboxmode,
        required double amount, required String sadadId}) async {
    final url = Uri.parse(
      ApiEndPoint.sadadPayTransationV6,
    );
    Map<String, String> header = {'Content-Type': 'application/json'};
    final body = json.encode({
      "amount": amount,
      "sadadId":sadadId,
      "token": token,
      "orderId": orderId,
      "ipAddress": ipAddress,
      "productDetails": productDetails,
      "userId": userId,
      "otp": otp,
      "issandboxmode" : issandboxmode,
    });

    var result = await http.post(
      url,
      headers: header,
      body: body
    );

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      return response;
    } else {
      final Map<String, dynamic> jsonData = json.decode(result.body);
      ErrorResponse errorResponse = ErrorResponse.fromJson(jsonData);

      // Extract the error message
      final errorMessage = errorResponse.error.message;
      print('Error Message: $errorMessage');

      // Return the error details as a map
      return {
        'statusCode': errorResponse.error.statusCode,
        'name': errorResponse.error.name,
        'message': errorMessage,
      };
    }
    return null;
  }
  static Future<bool> sadadPayResendOtpV6(
      {required String token,required String issandboxmode}) async {
    final url = Uri.parse(
      ApiEndPoint.sadadPayResendOTPV6,
    );
    Map<String, String> header = {'Content-Type': 'application/json'};
    //Map<String, dynamic> body = {"token" : token,"issandboxmode": issandboxmode};

    final body = json.encode({
      "token": token,
      "issandboxmode":issandboxmode,
    });
    var result = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      return response['result'];
    }
    return false;
  }

}


class ErrorResponse {
  ErrorDetails error;

  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: ErrorDetails.fromJson(json['error']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error.toJson(),
    };
  }
}


class ErrorDetails {
  int statusCode;
  String name;
  String message;

  ErrorDetails({required this.statusCode, required this.name, required this.message});

  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      statusCode: json['statusCode'],
      name: json['name'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'name': name,
      'message': message,
    };
  }
}

