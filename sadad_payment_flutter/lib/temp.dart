import 'dart:convert';
import 'dart:io';

import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sadad_payment_flutter/apputils/appdialogs.dart';
import 'package:sadad_payment_flutter/apputils/extensions.dart';
import 'package:sadad_payment_flutter/model/webViewDetailsModel.dart';
import 'package:sadad_payment_flutter/sadad_payment_flutter.dart';
import 'package:sadad_payment_flutter/services/appservices.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'services/api_endpoint.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final WebViewDetailsModel webViewDetailsModel;

  PaymentWebViewScreen({Key? key, required this.webViewDetailsModel}) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeUrl();
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(
          "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = true;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print(error);
          },
        ),
      );
  }

  String country = "";
  String city = "";
  String postString = "";
  String creditCardUrl = "";
  bool isCyberSorurce = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            if(isLoading)...[
              Center(
                child: CircularProgressIndicator(
                  color: widget.webViewDetailsModel.themeColor,
                ),
              )
            ],
            WebViewWidget(controller: webController!),
          ],
        ));
  }

  WebViewController? webController;

  //..loadRequest(Uri.parse('https://flutter.dev'));

  Future<void> makeUrl() async {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   AppDialog.showTransactionProcess(context, widget.webViewDetailsModel.themeColor);
    // });
    // await Future.delayed(Duration(seconds: 1));
    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }
    // webController =
    // WebViewController.fromPlatformCreationParams(params);
    // if (webController.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //   (webController.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(true);
    // }
    //webController.setUserAgent("Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1");
    webController?.addJavaScriptChannel(
      "IOSMyHandler",
      onMessageReceived: (p0) {
        print(p0.message);
        Map tempMessage = jsonDecode(p0.message);
        print("tempMessage::$tempMessage");
        Navigator.pop(context, tempMessage);
        // updateTransactionCreditCard(transactionDetails: tempMessage);
        // print("tempMessage::$tempMessage");
      },
    );

    // webController.addJavaScriptChannel(
    //   "",
    //   onMessageReceived: (p0) {
    //     print(p0);
    //     Map tempMessage = jsonDecode(p0.message);
    //     updateTransactionCreditCard(transactionDetails: tempMessage);
    //     print("tempMessage::$tempMessage");
    //   },
    // );

    int amount = (widget.webViewDetailsModel.transactionAmount!).toInt();
    if (widget.webViewDetailsModel.paymentMethod == "credit") {
      String? ipAddress = await NetworkInfo().getWifiIPv6();
      String merchantID = widget.webViewDetailsModel.merchantUserId ?? ""; //"9246722"

      String? cardNumberWithoutSpace = widget.webViewDetailsModel.cardnumber?.replaceAll("-", "");
      List tempExpiryDate = widget.webViewDetailsModel.expiryDate!.split("/");
      var expiryDate = tempExpiryDate.last.toString() + tempExpiryDate.first.toString();
      postString =
      "carduser_id=$merchantID&mobileOS=${Platform.isIOS ? "1" : "2"}&is_Flutter=1&vpc_Version=1&transactionEntityId=9&deviceIp=$ipAddress&transactionmodeId=1&MID=${widget.webViewDetailsModel.sadadId}&vpc_Command=pay&vpc_Merchant=${widget.webViewDetailsModel.sadadId}&vpc_AccessCode=F4996AF0&vpc_OrderInfo=Test Order&vpc_Amount=$amount&vpc_Currency=QAR&vpc_TicketNo=6AQ89F3&vpc_ReturnURL=https://sadad.de/bankapi/25/PHP_VPC_3DS 2.5 Party_DR.php&vpc_Gateway=ssl&vpc_card=${widget.webViewDetailsModel.creditcardType}&vpc_CardNum=$cardNumberWithoutSpace&vpc_CardExp=$expiryDate&vpc_CardSecurityCode=${widget.webViewDetailsModel.cvv}&vpc_MerchTxnRef=${widget.webViewDetailsModel.transactionId}&firstName=${widget.webViewDetailsModel.cardHolderName!.split(" ").first}&lastName=${widget.webViewDetailsModel.cardHolderName!.split(" ").last}&nameOnCard=${widget.webViewDetailsModel.cardHolderName}&email=${widget.webViewDetailsModel.email}&mobilePhone=974${widget.webViewDetailsModel.contactNumber}&city=$city&country=$country";
      // if (widget.webViewDetailsModel.creditcardType == "Amex") {
      //   postString += "&transactionEntityId=9";
      // }
      var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
      String encodedString = base64.encode(utf8.encode(temp)).trim();
      print(encodedString);
      String? cardNumber = widget.webViewDetailsModel.cardnumber;
      String cardType = getCardType(cardNumber!);
      String? creditCardType = widget.webViewDetailsModel.creditcardType;
      bool? isAmexAllowed = widget.webViewDetailsModel.isAmexEnableForAdmin;

      if (isAmexAllowed! && cardType == "Amex") {
        creditCardUrl = ApiEndPoint.amex_creditCardURL;
      } else {
        creditCardUrl = ApiEndPoint.mpgs_pay_creditCardURL;
      }
      // else if (creditCardType == "3") //CREDIT_CARD_BANK_TYPE_CYBER{
      //   {
      //   if (cardType == "Mastercard" &&
      //       widget.webViewDetailsModel.isMasterEnableForCyber == 1 &&
      //       widget.webViewDetailsModel.isMasterEnableForCyberAdmin == 1) {
      //     isCyberSorurce = true;
      //   } else if (cardType == "Visa" &&
      //       widget.webViewDetailsModel.isVisaEnableForCyber == 1 &&
      //       widget.webViewDetailsModel.isVisaEnableForCyberAdmin == 1) {
      //     isCyberSorurce = true;
      //   } else {
      //     isCyberSorurce = false;
      //   }
      // }
      // else if (creditCardType == "0") //CREDIT_CARD_BANK_TYPE_MIGS
      // {
      //   creditCardUrl = ApiEndPoint.test_migs_pay_creditCardURL;
      // }

      Map? htmlString =
      await AppServices.creditCardWebViewRequest(encodedString: encodedString, creditCardUrl: creditCardUrl);
      String? webViewString;
      if (htmlString == null) {
        AppDialog.commonWarningDialog(
            themeColor: widget.webViewDetailsModel.themeColor,
            useMobileLayout: useMobileLayout,
            context: context,
            title: "Issue",
            subTitle: "Sorry, We are not able to process the transaction. Please try again.".translate(),
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonText: "Okay");
      } else {
        if (htmlString["status"].toString() == "success") {
          webViewString = htmlString["msg"];
          webController?.loadHtmlString(webViewString as String);
        } else {
          AppDialog.commonWarningDialog(
              themeColor: widget.webViewDetailsModel.themeColor,
              useMobileLayout: useMobileLayout,
              context: context,
              title: "Issue",
              subTitle: htmlString["msg"].toString(),
              buttonOnTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonText: "Okay");
        }
      }
    } else if (widget.webViewDetailsModel.paymentMethod == "debit") {
      postString = "${widget.webViewDetailsModel.transactionAmount}";
      var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
      String tempEncoded = base64.encode(utf8.encode(temp)).trim();
      var encodedFinal =
          "amount=${tempEncoded}&PUN=${widget.webViewDetailsModel.transactionId ?? ""}&type=${(widget.webViewDetailsModel.packageMode == PackageMode.debug) ? "sandbox" : "production"}";
      String? htmlString = await AppServices.debitCardWebViewRequest(encodedString: encodedFinal);
      webController?.loadHtmlString(htmlString as String);
    } else if (widget.webViewDetailsModel.paymentMethod == "sadadPay") {
      // String? htmlString = await AppServices.sadadPayWebViewRequest(
      //     token: widget.webViewDetailsModel.token!,
      //     transactionAmount: widget.webViewDetailsModel.transactionAmount!,
      //     products: widget.webViewDetailsModel.productDetail!);
      // webController.loadHtmlString(htmlString as String);
    } else if (widget.webViewDetailsModel.paymentMethod == "applePay") {
      double amount = widget.webViewDetailsModel.transactionAmount ?? 0;
      int finalamount = (amount * 100).toInt();
      String cardHolderName = widget.webViewDetailsModel.cardHolderName ?? "";
      List fullNameArr = widget.webViewDetailsModel.cardHolderName!.split("");
      String firstName = "";
      String lastName = "";
      if (fullNameArr.length > 0) {
        firstName = fullNameArr[0];
        lastName = fullNameArr.length > 1 ? fullNameArr[1] : "";
      }
      String country = "";
      String emailId = widget.webViewDetailsModel.email ?? "";
      String cellNo = widget.webViewDetailsModel.contactNumber ?? "";
      String postString = "";
      String merchantID = widget.webViewDetailsModel.merchantUserId ?? ""; //"9246722"
      String merchantSadadID = widget.webViewDetailsModel.merchantSadadId ?? ""; //"9246722";
      var strProductDetails = jsonEncode(widget.webViewDetailsModel.productDetail);
      strProductDetails = strProductDetails.replaceAll("(", "[");
      strProductDetails = strProductDetails.replaceAll(")", "]");
      strProductDetails = strProductDetails.replaceAll("\n", "");
      String? ipAddress = await NetworkInfo().getWifiIPv6();
      postString =
      "isFlutter=1&vpc_Version=1&vpc_Command=pay&vpc_Merchant=DB93443&vpc_AccessCode=F4996AF0&vpc_OrderInfo=TestOrder&vpc_Amount=$finalamount&vpc_Currency=QAR&vpc_TicketNo=6AQ89F3&vpc_ReturnURL=https://sadad.de/bankapi/25/PHP_VPC_3DS2.5 Party_DR.php&vpc_Gateway=ssl&vpc_MerchTxnRef=${widget.webViewDetailsModel.transactionId}&credit_phoneno_hidden=$country&credit_email_hidden=$country&productamount=$finalamount&vendorId=$merchantID&merchant_code=$merchantSadadID&website_ref_no=$country&return_url=$country&transactionEntityId=9&ipAddress=$ipAddress&hash=${widget.webViewDetailsModel.checksum}&firstName=$firstName&lastName=$lastName&nameOnCard=$cardHolderName&email=$emailId&mobilePhone=$cellNo&productdetail=$strProductDetails&paymentCode=${widget.webViewDetailsModel.token}";
      var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
      String encodedString = base64.encode(utf8.encode(temp)).trim();
      var htmlString = await AppServices.applePayWebviewRequest(encodedString: encodedString);
      //webController.loadRequest(Uri.parse("https://sadad.de/sadadinvoice/postdata_old.php"));
      webController?.loadHtmlString(htmlString as String);
    } else if (widget.webViewDetailsModel.paymentMethod == "googlePay") {
      Future.delayed(const Duration(seconds: 2), () {
        webController?.loadHtmlString(widget.webViewDetailsModel.htmlString as String);
      });
    }
    //if(context.mounted){
    //Navigator.pop(context);
    // }
  }

  updateTransactionCreditCard({required Map transactionDetails}) async {
    if (widget.webViewDetailsModel.paymentMethod == "credit" ||
        widget.webViewDetailsModel.paymentMethod == "applePay") {
      if (transactionDetails['vpc_MerchTxnRef'] is String) {
        // Map? data = await AppServices.updateTransactionCreditCard(transactionDetail: transactionDetails, token: widget.webViewDetailsModel.token!);
        // if (data == null) {
        //   AppDialog.commonWarningDialog(
        //       context: context,
        //       title: "Issue",
        //       subTitle: "We are not able to precessed your payment.",
        //       buttonOnTap: () {
        //         Navigator.pop(context);
        //         Navigator.pop(context);
        //       },
        //       buttonText: "Okay");
        // } else {
        //   Navigator.pop(context, data);
        // }
      } else {
        AppDialog.commonWarningDialog(
            themeColor: widget.webViewDetailsModel.themeColor,
            useMobileLayout: useMobileLayout,
            context: context,
            title: "Issue",
            subTitle: "We are not able to process your payment.",
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonText: "Okay");
        //Navigator.pop(context, transactionDetails);
      }
    } else if (widget.webViewDetailsModel.paymentMethod == "debit") {
      if (transactionDetails['vpc_MerchTxnRef'] is String) {
        // Map? data = await AppServices.updateTransactionDebitCard(
        //     transactionDetail: transactionDetails, token: widget.webViewDetailsModel.token!);
        // if (data == null) {
        //   AppDialog.commonWarningDialog(
        //       themeColor: widget.webViewDetailsModel.themeColor,
        //       useMobileLayout: useMobileLayout,
        //       context: context,
        //       title: "Issue",
        //       subTitle: "We are not able to process your payment.",
        //       buttonOnTap: () {
        //         Navigator.pop(context);
        //         Navigator.pop(context);
        //       },
        //       buttonText: "Okay");
        // } else {
        //   Navigator.pop(context, data);
        // }
      } else {
        AppDialog.commonWarningDialog(
            themeColor: widget.webViewDetailsModel.themeColor,
            useMobileLayout: useMobileLayout,
            context: context,
            title: "Issue",
            subTitle: "We are not able to process your payment.",
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonText: "Okay");
        //Navigator.pop(context, transactionDetails);
      }
    }
  }
}
