import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:sadad_qa_payments/apputils/appdialogs.dart';
import 'package:sadad_qa_payments/apputils/extensions.dart';
import 'package:sadad_qa_payments/model/webViewDetailsModel.dart';
import 'package:sadad_qa_payments/sadad_qa_payments.dart';
import 'package:sadad_qa_payments/services/appservices.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentWebViewScreen extends StatefulWidget {
  final WebViewDetailsModel webViewDetailsModel;

  const PaymentWebViewScreen({Key? key, required this.webViewDetailsModel}) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeUrl();
  }

  String country = "";
  String city = "";
  String postString = "";
  String creditCardUrl = "";
  bool isCyberSorurce = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if(didPop) return;
        onBack();
      },
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: widget.webViewDetailsModel.themeColor,
            leading:  IconButton(
              onPressed: () => onBack(),
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
            ),
          ),
          body: Stack(
            children: [
              if (isLoading) ...[
                Center(
                  child: CircularProgressIndicator(
                    color: widget.webViewDetailsModel.themeColor,
                  ),
                )
              ],
              WebViewWidget(controller: webController),
            ],
          )),
    );
  }

  WebViewController webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setUserAgent(
        "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1")
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ),
    );

  //..loadRequest(Uri.parse('https://flutter.dev'));

  Future<void> makeUrl() async {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   AppDialog.showTransactionProcess(context, widget.webViewDetailsModel.themeColor);
    // });
    // await Future.delayed(Duration(days: 1));
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
    webController.addJavaScriptChannel(
      "IOSMyHandler",
      onMessageReceived: (p0) {
        Map tempMessage = jsonDecode(p0.message);
        Navigator.pop(context, tempMessage);
        Navigator.pop(context, tempMessage);
        // updateTransactionCreditCard(transactionDetails: tempMessage);
        // print("tempMessage::$tempMessage");
      },
    );
    webController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webController.setNavigationDelegate(NavigationDelegate(
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
    ));
    webController.setOnConsoleMessage((message) {
      debugPrint(message.message);
    },);

    // webController.addJavaScriptChannel(
    //   "",
    //   onMessageReceived: (p0) {
    //     print(p0);
    //     Map tempMessage = jsonDecode(p0.message);
    //     updateTransactionCreditCard(transactionDetails: tempMessage);
    //     print("tempMessage::$tempMessage");
    //   },
    // );

    // int amount = (widget.webViewDetailsModel.transactionAmount!).toInt();
    if (widget.webViewDetailsModel.paymentMethod == "credit") {
      if (widget.webViewDetailsModel.isWebContentAvailable == true) {
        String? webViewString = widget.webViewDetailsModel.webContent;
        webController.loadHtmlString(webViewString as String);
      } else {}
    } else if (widget.webViewDetailsModel.paymentMethod == "debit") {
      if (widget.webViewDetailsModel.isWebContentAvailable == true) {
        String? webViewString = widget.webViewDetailsModel.webContent;
        webController.loadHtmlString(webViewString as String);
      } else {
        // postString = "${widget.webViewDetailsModel.transactionAmount}";
        // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
        // String tempEncoded = base64.encode(utf8.encode(temp)).trim();
        // var lang = selectedLanguage.languageCode == "en" ? "en" : "ar";
        // var mobileos = Platform.isIOS ? "1" : "2";
        //
        // Map<String, dynamic> body = {
        //   "issandboxmode": '${(widget.webViewDetailsModel.packageMode == PackageMode.debug) ? "1" : "0"}',
        //   "amount": (widget.webViewDetailsModel.transactionAmount!).toInt(),
        //   "isLanguage": '${lang}',
        //   "PUN": '${widget.webViewDetailsModel.transactionId ?? ""}',
        //   "SID": '${widget.webViewDetailsModel.sadadId}',
        //   "merchant_code": '${widget.webViewDetailsModel.sadadId}',
        //   "mobileos": '${mobileos}',
        // };
        //
        // var encodedFinal =
        //     "issandboxmode=${(widget.webViewDetailsModel.packageMode == PackageMode.debug)
        //     ? "1"
        //     : "0"}&amount=${tempEncoded}&isLanguage=${lang}&PUN=${widget.webViewDetailsModel.transactionId ??
        //     ""}&SID=${widget.webViewDetailsModel.sadadId}&merchant_code=${widget.webViewDetailsModel.sadadId}";
        // Map? htmlString = await AppServices.debitCardWebViewRequest(encodedString: body);
        // String? webViewString;
        // if (htmlString == null && context.mounted) {
        //   AppDialog.commonWarningDialog(
        //       themeColor: widget.webViewDetailsModel.themeColor,
        //       useMobileLayout: useMobileLayout,
        //       context: context,
        //       title: "Issue".translate(),
        //       subTitle: "Sorry, We are not able to process the transaction. Please try again.".translate(),
        //       buttonOnTap: () {
        //         Navigator.pop(context);
        //         Navigator.pop(context);
        //       },
        //       buttonText: "Okay");
        // } else {
        //   if (htmlString?["status"].toString() == "success") {
        //     webViewString = htmlString?["msg"];
        //     webController.loadHtmlString(webViewString as String);
        //   } else {
        //     AppDialog.commonWarningDialog(
        //         themeColor: widget.webViewDetailsModel.themeColor,
        //         useMobileLayout: useMobileLayout,
        //         context: context,
        //         title: "Issue".translate(),
        //         subTitle: htmlString?["msg"].toString() ?? "",
        //         buttonOnTap: () {
        //           Navigator.pop(context);
        //           Navigator.pop(context);
        //         },
        //         buttonText: "Okay");
        //   }
        // }
      }
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
      if (fullNameArr.isNotEmpty) {
        firstName = fullNameArr[0];
        lastName = fullNameArr.length > 1 ? fullNameArr[1] : "";
      }
      String country = "";
      String emailId = widget.webViewDetailsModel.email ?? "";
      String cellNo = widget.webViewDetailsModel.contactNumber ?? "";
      // String postString = "";
      String merchantID = widget.webViewDetailsModel.merchantUserId ?? ""; //"9246722"
      String merchantSadadID = widget.webViewDetailsModel.merchantSadadId ?? ""; //"9246722";
      var strProductDetails = jsonEncode(widget.webViewDetailsModel.productDetail);
      strProductDetails = strProductDetails.replaceAll("(", "[");
      strProductDetails = strProductDetails.replaceAll(")", "]");
      strProductDetails = strProductDetails.replaceAll("\n", "");
      String? ipAddress = await NetworkInfo().getWifiIPv6();
      var lang = selectedLanguage.languageCode == "en" ? "en" : "ar";
      postString =
          "isFlutter=1&isLanguage=$lang&website_ref_no_credit=${widget.webViewDetailsModel.orderID}&hash=${widget.webViewDetailsModel.checksum}&vpc_Version=1&vpc_Command=pay&vpc_Merchant=DB93443&vpc_AccessCode=F4996AF0&vpc_OrderInfo=TestOrder&vpc_Amount=$finalamount&vpc_Currency=QAR&vpc_TicketNo=6AQ89F3&vpc_ReturnURL=https://sadad.de/bankapi/25/PHP_VPC_3DS2.5 Party_DR.php&vpc_Gateway=ssl&vpc_MerchTxnRef=${widget.webViewDetailsModel.transactionId}&credit_phoneno_hidden=$country&credit_email_hidden=$country&productamount=$finalamount&vendorId=$merchantID&merchant_code=$merchantSadadID&website_ref_no=$country&return_url=$country&transactionEntityId=9&ipAddress=$ipAddress&firstName=$firstName&lastName=$lastName&nameOnCard=$cardHolderName&email=$emailId&mobilePhone=$cellNo&productdetail=$strProductDetails&paymentCode=${widget.webViewDetailsModel.token}";
      // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
      // String encodedString = base64.encode(utf8.encode(temp)).trim();
      // var htmlString = await AppServices.applePayWebviewRequest(encodedString: encodedString);
      // webController.loadHtmlString(htmlString as String);

      var test = await AppServices.applePayment(
          token: widget.webViewDetailsModel.token.toString(),
          mobileNumber: widget.webViewDetailsModel.contactNumber.toString(),
          txnAmount: widget.webViewDetailsModel.transactionAmount ?? 0.0,
          productDetail: widget.webViewDetailsModel.productDetail,
          checksum: widget.webViewDetailsModel.checksum.toString(),
          orderId: widget.webViewDetailsModel.orderID.toString(),
          ipAddress: ipAddress.toString(),
          merchantID: widget.webViewDetailsModel.merchantUserId.toString(),
          lang: lang,
          email: widget.webViewDetailsModel.email.toString(),
          firstname: "firstname",
          issandboxmode: (widget.webViewDetailsModel.packageMode == PackageMode.debug) ? "1" : "0",
          transactionId: widget.webViewDetailsModel.transactionId.toString(),
          merchantSadadID: merchantSadadID);
      if (test.toString().contains("div")) {
        webController.loadHtmlString(test as String);
      } else {
        AppDialog.commonWarningDialog(
            themeColor: widget.webViewDetailsModel.themeColor,
            useMobileLayout: useMobileLayout,
            context: context,
            title: "Issue".translate(),
            subTitle: test?["message"].toString() ?? "",
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonText: "Okay");
      }
      //     {
      //       "token":"",
      //   "mobileNumber": "9714407618",
      //   "orderId": "sd1111111011",
      //   "txnAmount" : 10,
      //   "ProductDetails" : [],
      //   "ipAddress" : "0.0.0.1",
      //   "merchantID" : 552,
      //   "lang" : "ar",
      //   "emailId" : "test@gmail.com",
      //   "cardHolderName" : "test sadad",
      //   "issandboxmode" : "0",
      //   "country" : "ind",
      //   "merchantSadadID" : "123456",
      //   "checksum" : "sfdekfdnbwjfengtrh5nkvnfknjn kfenrknf",
      //   "transactionId" : "1234"
      //
      // }
    } else if (widget.webViewDetailsModel.paymentMethod == "googlePay") {
      Future.delayed(const Duration(seconds: 2), () {
        webController.loadHtmlString(widget.webViewDetailsModel.htmlString as String);
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
            title: "Issue".translate(),
            subTitle: "We are not able to process your payment.".translate(),
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonText: "Okay".translate());
        //Navigator.pop(context, transactionDetails);
      }
    } else if (widget.webViewDetailsModel.paymentMethod == "debit") {
      if (transactionDetails['vpc_MerchTxnRef'] is String) {
        // Map? data = await AppServices.updateTransactionDebitCard(
        //     transactionDetail: transactionDetails, token: widget.webViewDetailsModel.token!);
        // if (data == null && context.mounted) {
        //   AppDialog.commonWarningDialog(
        //       themeColor: widget.webViewDetailsModel.themeColor,
        //       useMobileLayout: useMobileLayout,
        //       context: context,
        //       title: "Issue".translate(),
        //       subTitle: "We are not able to process your payment.".translate(),
        //       buttonOnTap: () {
        //         Navigator.pop(context);
        //         Navigator.pop(context);
        //       },
        //       buttonText: "Okay".translate());
        // } else {
        //   Navigator.pop(context, data);
        // }
      } else {
        AppDialog.commonWarningDialog(
            themeColor: widget.webViewDetailsModel.themeColor,
            useMobileLayout: useMobileLayout,
            context: context,
            title: "Issue".translate(),
            subTitle: "We are not able to process your payment.".translate(),
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonText: "Okay".translate());
        //Navigator.pop(context, transactionDetails);
      }
    }
  }

  void onBack() {
    AppDialog.commonWarningDialogWithTwoButton(
        themeColor: widget.webViewDetailsModel.themeColor,
        useMobileLayout: useMobileLayout,
        context: context,
        title: "Transaction in Progress".translate(),
        subTitle: "Are you sure you want to cancel this transaction? Any progress will be lost, and the transaction will not be completed.".translate(),
        negativeButtonOnTap: () {
          Navigator.pop(context);
        },
        negativeButtonText: "Back".translate(),
        positiveButtonOnTap: () {
          Map<String, String> cancelPayment = {
            'status': 'cancelled transaction',
            'message': 'Transaction cancelled by the user.',
          };
          //Map tempMessage = jsonDecode(p0.message);
          //print("tempMessage::$cancelPayment");
          Navigator.pop(context, cancelPayment);
          Navigator.pop(context, cancelPayment);
        },
        positiveButtonText: "Yes, cancel".translate());
  }
}
