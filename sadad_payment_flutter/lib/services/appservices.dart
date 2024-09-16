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
  static Future<void> getAccessToken() async {
    final url = Uri.parse(
      'https://sadad.de/sadadSDKTestConfig/index.php',
    );
    Map<String, String> header = {'Content-Type': 'application/json'};
    var result = await http.post(
      url,
      headers: header,
    );

    if (result.statusCode == 200) {
      var token = '${jsonDecode(result.body)}';
    }
  }

  // let request = NSMutableURLRequest(url: NSURL(string: "\(Constant.creditcard_Settings)")! as URL)
  // request.httpMethod = "GET"
  //
  // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  // request.setValue("\(strAccessToken)", forHTTPHeaderField: "Authorization")

  static Future<List<CreditCardSettingsModel>> getCreditCardSetting(
      {required String token, required BuildContext context}) async {
    final url = Uri.parse(
      ApiEndPoint.creditCardSettings,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    var result = await http.get(
      url,
      headers: header,
    );
    List<CreditCardSettingsModel> creditCardSettings = [];
    if (result.statusCode == 200) {
      List response = jsonDecode(result.body);
      creditCardSettings = response.map((e) => CreditCardSettingsModel.fromJson(e)).toList();
    }
    return creditCardSettings;
  }

  static Future<UserMetaPreference?> getUserPreferences({required String token}) async {
    final url = Uri.parse(
      ApiEndPoint.userMeta,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    var result = await http.get(
      url,
      headers: header,
    );

    if (result.statusCode == 200) {
      List response = jsonDecode(result.body);
      if (response.isNotEmpty) {
        UserMetaPreference userMetaPreference = UserMetaPreference.fromJson(response.first);
        return userMetaPreference;
      } else {
        return null;
      }
    }
    return null;
  }

  static Future<CheckedAllowedCountryModel?> checkAllowedCountry(
      {required String token, required String cardsixdigit}) async {
    final url = Uri.parse(
      ApiEndPoint.checkCountry,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    Map<String, String> body = {"cardsixdigit": cardsixdigit};
    CheckedAllowedCountryModel model = CheckedAllowedCountryModel(isAllowed: false, isDebitCard: false);
    var result = await http.post(
      url,
      headers: header,
      body: json.encode(body),
    );

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      model = CheckedAllowedCountryModel.fromJson(response);
      return model;
    } else {
      var response = jsonDecode(result.body);
    }
    return model;
  }

  static Future<dynamic> GenerateCreditCardTransectionID({required String card_type,
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
    required int is_cybersourse_visa}) async {
    final url = Uri.parse(
      ApiEndPoint.generateTransaction,
    );
    int TypeOfCard = 0;
    if (card_type == "Visa") {
      TypeOfCard = 1;
    } else if (card_type == "Mastercard") {
      TypeOfCard = 2;
    } else if (card_type == "Amex") {
      TypeOfCard = 3;
    }

    String cardID = "0";
    if (card_type == "Amex" && is_american_express) {
      cardID = "0";
    } else if (credit_card_bankpage_type == "3") {
      if (card_type == "Mastercard" &&
          (userMetaPreference.isallowedtocybersourcemastercard == 0 || is_cybersourse_mastercard == 0)) {
        cardID = "2";
        credit_card_bankpage_type = "2";
      } else if (card_type == "Visa" &&
          (userMetaPreference.isallowedtocybersourcevisa == 0 || is_cybersourse_visa == 0)) {
        cardID = "2";
        credit_card_bankpage_type = "2";
      } else {
        cardID = credit_card_bankpage_type;
      }
    } else {
      cardID = credit_card_bankpage_type;
    }
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    Map transaction_summary = {
      "MOBILE_NO": mobileNumber,
      "TXN_AMOUNT": txnAmount,
      "PRODUCT_DETAILS": productDetail,
    };
    Map body = {
      "amount": txnAmount,
      "transactionentityId": AppConstant.transection_SDK_ID,
      "transactionmodeId": AppConstant.CreditCard_TransactionMode_ID,
      "transactionstatusId": AppConstant.TransectionInProgress,
      "sourceofTxn": AppConstant.TransectionSource,
      "transaction_summary": transaction_summary,
      "cardschemeid": TypeOfCard,
      "creditcardpaymentmodeid": int.parse(cardID),
      "orderId": orderId,
    };
    String jsonString = jsonEncode(body);
    // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    // String encodedString = base64.encode(utf8.encode(temp)).trim();

    var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    String tempEncoded = base64.encode(utf8.encode(temp)).trim();
    var result = await http.post(url, headers: header, body: jsonEncode({"securedata": tempEncoded}));

    //var result = await http.post(url, headers: header, body: jsonEncode(body));
    // Body.tostring()
    // crypt()
    // Buffer.from(cipherText).toString('base64')
    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      TransactionIdDetailsModel transactionIdDetailsModel = TransactionIdDetailsModel.fromJson(response);
      return transactionIdDetailsModel;
    } else {
      var response = jsonDecode(result.body);
      String message = response['error']['message'];
      return message;
    }
  }

  static Future<dynamic> GenerateDebitCardTransactionID(
      {required String token,
      required String mobileNumber,
      required double txnAmount,
      required List<Map> productDetail,
      required String hash,
        required String orderId,
  required UserMetaPreference userMetaPreference}) async {
    final url = Uri.parse(
      ApiEndPoint.generateTransaction,
    );

    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    Map transaction_summary = {
      "MOBILE_NO": mobileNumber,
      "TXN_AMOUNT": txnAmount,
      "PRODUCT_DETAILS": productDetail,
    };
    Map body = {
      "amount": txnAmount,
      "transactionentityId": AppConstant.transection_SDK_ID,
      "transactionmodeId": AppConstant.DebitCard_TransactionMode_ID,
      "transactionstatusId": AppConstant.TransectionInProgress,
      "sourceofTxn": AppConstant.TransectionSource,
      "transaction_summary": transaction_summary,
      "encryted": true,
      "orderId": orderId,
    };

    String jsonString = jsonEncode(body);
    // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    // String encodedString = base64.encode(utf8.encode(temp)).trim();

    var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    String tempEncoded = base64.encode(utf8.encode(temp)).trim();
    var result = await http.post(url, headers: header, body: jsonEncode({"securedata": tempEncoded}));

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      TransactionIdDetailsModel transactionIdDetailsModel = TransactionIdDetailsModel.fromJson(response);
      return transactionIdDetailsModel;
    } else {
      var response = jsonDecode(result.body);
      String message = response['error']['message'];
      return message;
    }
  }

  static Future<String?> generateChecksum(
      {required String token, required String mobile, required double amount, required List product_detail}) async {
    final url = Uri.parse(
      ApiEndPoint.transectionURL,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    Map<String, dynamic> body = {"MOBILE_NO": mobile, "TXN_AMOUNT": amount, "PRODUCT_DETAILS": product_detail};
    String? hashKey;
    var result = await http.post(
      url,
      headers: header,
      body: json.encode(body),
    );

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      hashKey = response['hash'];
      return hashKey;
    }
    return hashKey;
  }

  static Future<dynamic?> creditCardWebViewRequest(
      {required String encodedString, required String creditCardUrl}) async {
    final url = Uri.parse(creditCardUrl);
    Map<String, dynamic> body = {"encryptData": encodedString};
    //List<int> body = utf8.encode("encryptData=$encodedString");
    var result = await http.post(url, body: body);
    if (result.statusCode == 200) {
      //var response = result.body;
      var response = jsonDecode(result.body);
      return response;
    }
    return null;
  }

  static Future<dynamic?> googlePayCompletion({required String encodedString, required String googlePayURL}) async {
    final url = Uri.parse(googlePayURL);
    Map<String, dynamic> body = {"encryptData": encodedString};
    //List<int> body = utf8.encode("encryptData=$encodedString");
    var result = await http.post(url, body: body);
    if (result.statusCode == 200) {
      //var response = result.body;
      var response = jsonDecode(result.body);
      return response;
    }
    return null;
  }

  static Future<String?> applePayWebviewRequest({required String encodedString}) async {
    final url = Uri.parse(ApiEndPoint.applepay_URL);
    Map<String, dynamic> body = {"data": encodedString};
    //List<int> body = utf8.encode("encryptData=$encodedString");
    var result = await http.post(url, body: body);
    if (result.statusCode == 200) {
      var response = result.body;
      return response;
    }
    return "";
  }

  static Future<dynamic?> debitCardWebViewRequest({required String encodedString}) async {
    final url = Uri.parse(ApiEndPoint.debitCardURL);
    String body = encodedString;
    //List<int> body = utf8.encode("encryptData=$encodedString");
    var result = await http.post(url, body: body);
    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      return response;
    }
    return "";
  }

  // static Future<Map?> updateTransactionCreditCard({required String token, required Map transactionDetail}) async {
  //   int transactionStatus = 403;
  //   String transactionID = "";
  //   int transactionAmount = 0;
  //   String creditCard = "";
  //   if (transactionDetail.containsKey('vpc_Amount')) {
  //     transactionAmount = int.parse(transactionDetail['vpc_Amount'] ?? "0") ~/ 10000;
  //   }
  //   if (transactionDetail.containsKey('vpc_Message')) {
  //     creditCard = transactionDetail['vpc_Message'];
  //     if (creditCard.toLowerCase() == "approved" || creditCard.toLowerCase() == "accept") {
  //       transactionStatus = 3;
  //     } else {
  //       transactionStatus = 2;
  //     }
  //   } else {
  //     transactionStatus = 2;
  //   }
  //
  //   if (transactionDetail.containsKey('vpc_MerchTxnRef')) {
  //     transactionID = transactionDetail['vpc_MerchTxnRef'];
  //   } else {
  //     transactionStatus = 2;
  //   }
  //
  //   final url = Uri.parse(
  //     ApiEndPoint.patchTransactionURL,
  //   );
  //   Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
  //   Map<String, dynamic> body = {
  //     "amount": transactionAmount,
  //     "transactionno": transactionID,
  //     "transactionstatusId": transactionStatus.toString()
  //   };
  //
  //   var result = await http.post(
  //     url,
  //     headers: header,
  //     body: json.encode(body),
  //   );
  //
  //   if (result.statusCode == 200) {
  //     var response = jsonDecode(result.body);
  //     print(response);
  //     return response['data'];
  //   }
  //   var response = jsonDecode(result.body);
  //   print(response);
  //   return null;
  // }

  // static Future<Map?> updateTransactionDebitCard({required String token, required Map transactionDetail}) async {
  //   int transactionStatus = 403;
  //   String transactionID = "";
  //   int transactionAmount = 0;
  //   String creditCard = "";
  //   if (transactionDetail.containsKey('vpc_Amount')) {
  //     transactionAmount = int.parse(transactionDetail['vpc_Amount'] ?? "0") ~/ 10000;
  //   }
  //   if (transactionDetail.containsKey('vpc_Message')) {
  //     creditCard = transactionDetail['vpc_Message'];
  //     if (creditCard.toLowerCase() == "approved" || creditCard.toLowerCase() == "accept") {
  //       transactionStatus = 3;
  //     } else {
  //       transactionStatus = 2;
  //     }
  //   } else {
  //     transactionStatus = 2;
  //   }
  //
  //   if (transactionDetail.containsKey('vpc_MerchTxnRef')) {
  //     transactionID = transactionDetail['vpc_MerchTxnRef'];
  //   } else {
  //     transactionStatus = 2;
  //   }
  //
  //   final url = Uri.parse(
  //     ApiEndPoint.patchTransactionURL,
  //   );
  //   Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
  //   Map<String, dynamic> body = {
  //     "amount": transactionAmount,
  //     "transactionno": transactionID,
  //     "transactionstatusId": transactionStatus.toString()
  //   };
  //
  //   var result = await http.post(
  //     url,
  //     headers: header,
  //     body: json.encode(body),
  //   );
  //
  //   if (result.statusCode == 200) {
  //     var response = jsonDecode(result.body);
  //     print(response);
  //     return response['data'];
  //   }
  //   var response = jsonDecode(result.body);
  //   print(response);
  //   return null;
  // }

  // static Future<SadadPayMinAmountCheckModel?> sadadPayMinAmountCheck({
  //   required String token,
  // }) async {
  //   final url = Uri.parse(ApiEndPoint.minAmount);
  //   Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
  //   var result = await http.get(url, headers: header);
  //   if (result.statusCode == 200) {
  //     List<SadadPayMinAmountCheckModel> temp = sadadPayMinAmountCheckModelFromJson(result.body);
  //     return temp.first;
  //   }
  //   return null;
  // }

  // static Future<String?> sadadPayWebViewRequest({required double transactionAmount, required String token, required List products}) async {
  //   final url = Uri.parse(ApiEndPoint.test_SDKLoginURL);
  //   String strProductDetail = utf8.encode(jsonEncode(products)).toString();
  //   strProductDetail = strProductDetail.replaceAll("(", "[").replaceAll(")", "]");
  //   // Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
  //   //Map<String, dynamic> body = {"TXN_AMOUNT": transactionAmount, "PRODUCT_DETAILS": strProductDetail, "ACCESS_TOKEN": ""};
  //   String bodyString = "TXN_AMOUNT=10.0&PRODUCT_DETAILS=$strProductDetail&ACCESS_TOKEN=$token";
  //   var result = await http.post(url, body: bodyString);
  //   if (result.statusCode == 200) {
  //     var response = result.body;
  //     print(response);
  //     return response;
  //   }
  //   return "";
  // }

  static Future<SendOtpModel?> sadadPayLogin(
      {required String token, required String cellnumber, required String password}) async {
    final url = Uri.parse(
      ApiEndPoint.SDKLoginURL,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    Map<String, dynamic> body = {"cellnumber": cellnumber, "password": password};

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

  static Future<bool?> sadadPayVerifyOtp({required String token, required String otp, required String userId}) async {
    final url = Uri.parse(
      ApiEndPoint.sadadPayVerifyOTP,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};
    Map<String, dynamic> body = {"otp": int.parse(otp), "userId": int.parse(userId)};

    var result = await http.post(
      url,
      headers: header,
      body: json.encode(body),
    );

    if (result.statusCode == 200) {
      return true;
      var response = jsonDecode(result.body);
    }
    var response = jsonDecode(result.body);
    return false;
  }

  static Future<bool> sadadPayResendOtp({required String token}) async {
    final url = Uri.parse(
      ApiEndPoint.sadadPayResendOTP,
    );
    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": token};

    var result = await http.get(url, headers: header);

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      return response['result'];
    }
    var response = jsonDecode(result.body);
    return false;
  }

  static Future<Map?> sadadPayTransactions(
      {required String ipAddress,
      required List productDetails,
      required String token,
      required String sadadId,
      required int userId,
        required String orderId,
      required double amount}) async {
    final url = Uri.parse(
      ApiEndPoint.sadadPayTransaction,
    );
    // Pay Via Sadad
    // ------------------------
    // Authorization (senderid token >> getting from login)
    // sadadid (token generated from index.php)
    // pay via others
    // -----------------------------------
    //    Authorization (token generated from index.php)

    Map<String, String> header = {'Content-Type': 'application/json', "Authorization": sadadId, "sadadId": token};
    Map<String, dynamic> body = {
      "createdby": userId,
      "modifiedby": userId,
      "amount": amount,
      "senderId": userId,
      "transactionstatusId": 3,
      "transactionmodeId": 3,
      "transactionentityId": 9,
      "transaction_summary": productDetails,
      "txnip": ipAddress,
      "orderId": orderId,
    };

    // var result = await http.post(
    //   url,
    //   headers: header,
    //   body: json.encode(body),
    // );
    String jsonString = jsonEncode(body);
    // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    // String encodedString = base64.encode(utf8.encode(temp)).trim();

    var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    String tempEncoded = base64.encode(utf8.encode(temp)).trim();
    var result = await http.post(url, headers: header, body: jsonEncode({"securedata": tempEncoded}));

    if (result.statusCode == 200) {
      var response = jsonDecode(result.body);
      return response;
    }
    return null;
  }

  static Future<bool>checkAccessToken({required String token}) async {
    final url = Uri.parse("${ApiEndPoint.validateToken_URL}?accesstoken=$token");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result['result'];
    }
    return false;
  }

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
    // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    // String encodedString = base64.encode(utf8.encode(temp)).trim();

    //var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    //String tempEncoded = base64.encode(utf8.encode(temp)).trim();
    var result = await http.post(url, headers: header, body: body);

    //var result = await http.post(url, headers: header, body: jsonEncode(body));
    // Body.tostring()
    // crypt()
    // Buffer.from(cipherText).toString('base64')
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

    // var result = await http.post(
    //   url,
    //   headers: header,
    //   body: json.encode(body),
    // );
    //String jsonString = jsonEncode(body);
    // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    // String encodedString = base64.encode(utf8.encode(temp)).trim();

    // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(jsonString, "XDRvx?#Py^5V@3jC");
    // String tempEncoded = base64.encode(utf8.encode(temp)).trim();
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

