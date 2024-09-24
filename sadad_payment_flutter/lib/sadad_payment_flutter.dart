library sadad_payment_flutter;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'dart:io';

import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:pay/pay.dart';
import 'package:pinput/pinput.dart';
import 'package:sadad_payment_flutter/apputils/app_formatter.dart';
import 'package:sadad_payment_flutter/apputils/appassets.dart';
import 'package:sadad_payment_flutter/apputils/appcolors.dart';
import 'package:sadad_payment_flutter/apputils/appdialogs.dart';
import 'package:sadad_payment_flutter/apputils/extensions.dart';
import 'package:sadad_payment_flutter/commonWidgets.dart';
import 'package:sadad_payment_flutter/model/checkedallowedcountrymodel.dart';
import 'package:sadad_payment_flutter/model/creditcardsettingsmodel.dart';
import 'package:sadad_payment_flutter/model/sendOtpModel.dart';
import 'package:sadad_payment_flutter/model/transactionIdDetailsModel.dart';
import 'package:sadad_payment_flutter/model/usermetapreference.dart';
import 'package:sadad_payment_flutter/model/webViewDetailsModel.dart';
import 'package:sadad_payment_flutter/payment_web_view.com.dart';
import 'package:sadad_payment_flutter/services/api_endpoint.dart';
import 'package:sadad_payment_flutter/services/appservices.dart';

Locale selectedLanguage = PlatformDispatcher.instance.locale;
bool useMobileLayout = false;

class PaymentScreen extends StatefulWidget {
  Color? themeColor;
  Color? paymentButtonColor;
  Color? paymentButtonTextColor;
  List<PaymentType> paymentTypes;
  String token;
  String mobile;
  String email;
  String customerName;
  double amount;
  Image image;
  bool isWalletEnabled;
  String titleText;
  List<Map> productDetail;
  PackageMode packageMode;

  String orderId;

  PaymentScreen(
      {super.key,
      required this.themeColor,
      required this.customerName,
      required this.titleText,
      required this.paymentButtonColor,
      required this.paymentButtonTextColor,
      required this.mobile,
      required this.token,
      required this.email,
      required this.isWalletEnabled,
      required this.productDetail,
      required this.amount,
      required this.packageMode,
      required this.image,
      required this.orderId,
      this.paymentTypes = const [PaymentType.creditCard, PaymentType.debitCard, PaymentType.sadadPay]});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Color primaryColor = AppColors.primaryColor;
  List<CreditCardSettingsModel> creditCardSettingsModel = [];
  PaymentType selectedPaymentMethod = PaymentType.creditCard;
  UserMetaPreference? userMetaPreference;
  String credit_card_bankpage_type = "";
  String is_american_express = "";
  String is_cybersourse_visa = "";
  String is_cybersourse_mastercard = "";
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController sadadPayCellNumberController = TextEditingController();
  TextEditingController sadadPayPasswordController = TextEditingController();
  TextEditingController sadadPayOTPController = TextEditingController();
  bool rememberMe = false;
  bool isObscure = true;
  String token = "";
  bool isLoading = true;
  bool sadadPayOTPSent = false;
  int counter = 59;
  Timer? timer;
  String cardType = "";
  SendOtpModel? sendOtpModel;
  final sadadPayForm = GlobalKey<FormState>();
  final creditCardForm = GlobalKey<FormState>();
  final creditCardHolderForm = GlobalKey<FormState>();
  final creditCardNumberForm = GlobalKey<FormState>();
  final expiryValidityForm = GlobalKey<FormState>();
  final cvvForm = GlobalKey<FormState>();
  FocusNode creditCardHolderFocus = FocusNode();
  String checkSum = "";

  RegExp emailCheckOne = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-.]+\.[a-zA-Z]+");

  bool checkEmailLastPartContainNumber(String email) {
    final values = email.split('.');
    String pattern = r'^[a-z A-Z]+$';
    RegExp regex = RegExp(pattern);
    if (values.length > 0 && regex.hasMatch(values.last)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.paymentTypes.isEmpty && !widget.isWalletEnabled) {
      widget.paymentTypes = [PaymentType.creditCard, PaymentType.debitCard, PaymentType.sadadPay];
      selectedPaymentMethod = widget.paymentTypes.first;
    } else if (widget.paymentTypes.isNotEmpty) {
      selectedPaymentMethod = widget.paymentTypes.first;
    }
    isDebug = PackageMode.debug == widget.packageMode;
    creditCardHolderFocus.addListener(() {
      if (creditCardHolderFocus.previousFocus()) {
        creditCardHolderForm.currentState!.validate();
      }
    });

    widget.amount = roundOffToXDecimal(widget.amount, numberOfDecimal: 2);

    creditCardSettingsAndValidation(token: widget.token);
    sadadPayPasswordController.clear();
    cardHolderNameController.clear();
    sadadPayOTPController.clear();
    expiryController.clear();
    cvvController.clear();
    sadadPayCellNumberController.clear();
    cardNumberController.clear();
    primaryColor = widget.themeColor!;
  }

  String getImagePath(String cardType) {
    if (cardType == "Mastercard") {
      return AssetPath.masterCard;
    } else if (cardType == "Visa") {
      return AssetPath.visa;
    } else if (cardType == "Amex") {
      return AssetPath.americanExpress;
    } else {
      return "";
    }
  }

  //
  // initOTPCounter() async {
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     counter--;
  //     if (counter < 1) {
  //       timer.cancel();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    useMobileLayout = shortestSide < 600;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [topContainer(), middleContainer(), bottomContainer()],
              ),
            ),
          )),
    );
  }

  Widget middleContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: useMobileLayout ? 12 : 52),
      child: Column(
        children: [
          if (widget.isWalletEnabled && widget.paymentTypes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    endIndent: 15,
                    indent: 50,
                    thickness: 2,
                    height: 10,
                    color: Color(0xFFE4E4E4),
                  ),
                ),
                Text("Or Pay Using".translate(),
                    style: TextStyle(color: AppColors.black, fontSize: useMobileLayout ? 12 : 17)),
                const Expanded(
                  child: Divider(
                    endIndent: 50,
                    indent: 15,
                    thickness: 2,
                    height: 10,
                    color: AppColors.dividerColor,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (widget.paymentTypes.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.paymentTypes.contains(PaymentType.creditCard))
                  cardContainer(useMobileLayout,
                      text: "Credit Card".translate(), type: PaymentType.creditCard, imagePath: AssetPath.creditCard),
                if (widget.paymentTypes.contains(PaymentType.debitCard))
                  cardContainer(useMobileLayout,
                      text: "Debit Card".translate(), type: PaymentType.debitCard, imagePath: AssetPath.debitIcon),
                if (widget.paymentTypes.contains(PaymentType.sadadPay))
                  cardContainer(useMobileLayout,
                      text: "Sadad Pay".translate(), type: PaymentType.sadadPay, imagePath: AssetPath.sadadWallet)
              ],
            ),
            const SizedBox(height: 12),
            Directionality(
                textDirection: selectedLanguage == const Locale("ar") ? TextDirection.rtl : TextDirection.ltr,
                child: getSelectedPaymentMethod(selectedMethod: selectedPaymentMethod))
          ]
        ],
      ),
    );
  }

  Widget topContainer() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: useMobileLayout ? size.width * 0.56 + kToolbarHeight : size.width * 0.40 + kToolbarHeight,
      width: double.infinity,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          height: useMobileLayout ? size.width * 0.5 + kToolbarHeight : size.width * 0.38 + kToolbarHeight,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
          child: Padding(
            padding: EdgeInsets.all(isDebug == true ? 0 : 12),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              isDebug == true
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Test Mode",
                          style: TextStyle(color: AppColors.black, fontSize: useMobileLayout ? 16 : 20),
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(4)),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            AppDialog.commonWarningDialogWithTwoButton(
                                themeColor: widget.themeColor ?? AppColors.primaryColor,
                                useMobileLayout: useMobileLayout,
                                context: context,
                                title: "Cancel Payment".translate(),
                                subTitle: "Want to cancel this transaction?".translate(),
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
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.16,
                              maxWidth: MediaQuery.of(context).size.width * 0.43),
                          height: MediaQuery.of(context).size.width * 0.16,
                          padding: const EdgeInsets.all(8),
                          decoration:
                              BoxDecoration(color: AppColors.transparent, borderRadius: BorderRadius.circular(6)),
                          child: widget.image,
                        ),
                        const SizedBox(height: 9),
                        Text(
                          widget.titleText ?? "",
                          style: TextStyle(color: AppColors.white, fontSize: useMobileLayout ? 16 : 20),
                        )
                      ],
                    ),
                    Expanded(
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(maxWidth: useMobileLayout ? 100 : 200),
                        position: PopupMenuPosition.under,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(selectedLanguage.languageCode == "en" ? "En" : "Ar",
                                style: TextStyle(color: Colors.white, fontSize: useMobileLayout ? 12 : 18)),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.dividerColor)
                          ],
                        ),
                        itemBuilder: (context) {
                          return [
                            commonPopupMenuItem(
                                text: "English",
                                onTap: () {
                                  setState(() {
                                    selectedLanguage = const Locale("en");
                                  });
                                },
                                value: "en"),
                            commonPopupMenuItem(
                                text: "Arabic",
                                onTap: () {
                                  setState(() {
                                    selectedLanguage = const Locale("ar");
                                  });
                                },
                                value: "ar"),
                          ];
                        },
                      ),
                    ),
                    // Expanded(
                    //   child: InkWell(
                    //     onTap: () {},
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: const [Text("Eng", style: TextStyle(color: Colors.white, fontSize: 12)), Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.white)],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              // const SizedBox(height: 0),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColors.black54, borderRadius: BorderRadius.circular(20)),
                  height: 40,
                  child: selectedLanguage.languageCode == "en"
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                            "Select an option to pay ".translate(),
                            style: TextStyle(color: AppColors.white, fontSize: useMobileLayout ? 12 : 17),
                          ),
                          priceWidget(price: roundOffToXDecimal(widget.amount, numberOfDecimal: 2).toString())
                        ])
                      : Row(mainAxisSize: MainAxisSize.min, children: [
                          priceWidget(price: roundOffToXDecimal(widget.amount, numberOfDecimal: 2).toString()),
                          Text(
                            "Select an option to pay ".translate(),
                            style: TextStyle(color: AppColors.white, fontSize: useMobileLayout ? 12 : 17),
                          )
                        ])),
              const SizedBox(height: 25)
            ]),
          ),
        ),
        if (widget.isWalletEnabled)
          Align(
            alignment: Alignment.bottomCenter,
            child: Platform.isIOS
                ? InkWell(
                    onTap: () {
                      // if let merchantID = arrUserMetaPreferences["userId"] as? Int{
                      // UserDefaults.standard.set(merchantID, forKey: "MerchantUserID")
                      // }
                      // if let arrUsers = arrUserMetaPreferences["user"] as? [String:Any], let merchantID = arrUsers["SadadId"] as? String{
                      // UserDefaults.standard.set(merchantID, forKey: "MerchantSadadID")
                      // }
                      if (widget.packageMode == PackageMode.release) {
                        if (userMetaPreference?.user?.sadadId == "" || userMetaPreference?.userId == "") {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Column(
                                    children: [
                                      Text("Merchant has no permission to use SDK. Please contact to administrator."
                                          .translate()),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Okay".translate()))
                                    ],
                                  ),
                                );
                              });
                        } else {
                          WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
                            themeColor: widget.themeColor ?? primaryColor,
                            merchantSadadId: userMetaPreference?.user?.sadadId,
                            checksum: checkSum,
                            merchantUserId: userMetaPreference?.userId,
                            cardHolderName: "cardholdername",
                            email: widget.email,
                            paymentMethod: "applePay",
                            contactNumber: widget.mobile,
                            transactionAmount: widget.amount,
                            orderID: widget.orderId,
                            productDetail: widget.productDetail,
                            transactionId: "",
                            token: widget.token,
                          );
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
                            },
                          ));
                        }
                      } else {
                        AppDialog.commonWarningDialog(
                            themeColor: widget.themeColor ?? AppColors.primaryColor,
                            useMobileLayout: useMobileLayout,
                            context: context,
                            title: "Sandbox mode".translate(),
                            subTitle: "Sorry, Apple pay is not allowed in sandbox.".translate(),
                            buttonOnTap: () {
                              Navigator.pop(context);
                            },
                            buttonText: "Okay".translate());
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(10)),
                      height: useMobileLayout ? 50 : 65,
                      margin: EdgeInsets.symmetric(horizontal: useMobileLayout ? 40 : 62),
                      child:
                          Center(child: Image.asset(AssetPath.applePay, package: 'sadad_payment_flutter', height: 22)),
                    ),
                  )
                : /*InkWell(
                          onTap: () {
                            if (userMetaPreference?.user?.sadadId == "" || userMetaPreference?.userId == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Column(
                                        children: [
                                          Text("Merchant has no permission to use SDK. Please contact to administrator.".translate()),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Okay".translate()))
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
                                merchantSadadId: userMetaPreference?.user?.sadadId,
                                checksum: checkSum,
                                merchantUserId: userMetaPreference?.userId,
                                cardHolderName: "cardholdername",
                                email: widget.email,
                                paymentMethod: "googlepay",
                                contactNumber: widget.mobile,
                                transactionAmount: widget.amount,
                                productDetail: widget.productDetail,
                                transactionId: "",
                                token: widget.token,
                              );
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
                                },
                              )).then((value) {
                                Navigator.pop(context, value);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [BoxShadow(color: AppColors.black12, blurRadius: 5, blurStyle: BlurStyle.outer)]),
                            height: 55,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(child: Image.asset(AssetPath.gPay, package: 'sadad_payment_flutter', height: 22)),
                          ),
                        )*/
                // Google pay Dev testSPSQNB01
                // Google pay Live SPSQNB01

                // Live Environment
                //         "merchantInfo": {
                // "merchantId": "BCR2DN6TR6Y7Z2CJ",
                // "merchantName": "Sadad Payment Solutions"
                // },
                //"environment":"PRODUCTION",

                ///////////////
                GooglePayButton(
                    height: useMobileLayout ? 50 : 65,
                    width: MediaQuery.of(context).size.width - (useMobileLayout ? 80 : 124),
                    paymentConfiguration: PaymentConfiguration.fromJsonString('''{
   "provider":"google_pay",
   "data":{
      "environment":"PRODUCTION",
      "apiVersion":2,
      "apiVersionMinor":0,
      "allowedPaymentMethods":[
         {
             "merchantInfo": {
                "merchantId": "BCR2DN6TR6Y7Z2CJ",
                "merchantName": "Sadad Payment Solutions"
             },
            "type":"CARD",
            "tokenizationSpecification":{
               "type":"PAYMENT_GATEWAY",
               "parameters":{
                  "gateway":"mpgs",
                  "gatewayMerchantId":"SPSQNB01"
               }
            },
            "parameters":{
               "allowedCardNetworks":[
                  "VISA",
                  "MASTERCARD"
               ],
               "allowedAuthMethods":[
                  "PAN_ONLY",
                  "CRYPTOGRAM_3DS"
               ],
               "billingAddressRequired":false,
               "billingAddressParameters":{
                  "format":"FULL",
                  "phoneNumberRequired":true
               }
            }
         }
      ],

      "transactionInfo":{
         "countryCode":"QA",
         "currencyCode":"QAR"
      }
   }
}'''),
                    paymentItems: [
                      PaymentItem(
                        label: "Total".translate(),
                        amount: widget.amount.toString() ?? "",
                        status: PaymentItemStatus.final_price,
                        type: PaymentItemType.total,
                      )
                    ],
                    type: GooglePayButtonType.plain,
                    margin: EdgeInsets.symmetric(horizontal: useMobileLayout ? 20 : 62),
                    onPaymentResult: (result) async {
                      AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
                      var tokenData = result["paymentMethodData"]["tokenizationData"]["token"];
                      String? ipAddress = await NetworkInfo().getWifiIPv6();
                      double amount = widget.amount ?? 0;
                      int finalamount = (amount * 100).toInt();
                      String cardHolderName = "" ?? "";
                      String firstName = "";
                      String lastName = "";
                      String country = "";
                      String emailId = widget.email ?? "";
                      String cellNo = widget.mobile ?? "";
                      //String checkSumLocal = checkSum;
                      // As per basecamp requirement remove checksum from Rishabh
                      String merchantID = userMetaPreference?.userId ?? ""; //"9246722"
                      String merchantSadadID = userMetaPreference?.user?.sadadId ?? ""; //"9246722";
                      var strProductDetails = jsonEncode(widget.productDetail);
                      strProductDetails = strProductDetails.replaceAll("(", "[");
                      strProductDetails = strProductDetails.replaceAll(")", "]");
                      strProductDetails = strProductDetails.replaceAll("\n", "");
                      var lang = selectedLanguage.languageCode == "en" ? "en" : "ar";
                      var postString =
                          "issandboxmode=${(widget.packageMode == PackageMode.debug) ? "1" : "0"}&isLanguage=$lang&website_ref_no_credit=${widget.orderId}&isFlutter=1&vpc_Version=1&mobileOS=${Platform.isIOS ? "1" : "2"}&vpc_Command=pay&paymentToken=$tokenData&walletProvider=GOOGLE_PAY&vpc_Merchant=DB93443&vpc_AccessCode=F4996AF0&vpc_OrderInfo=TestOrder&vpc_Amount=$finalamount&vpc_Currency=QAR&vpc_TicketNo=6AQ89F3&vpc_ReturnURL=https://sadad.de/bankapi/25/PHP_VPC_3DS2.5 Party_DR.php&vpc_Gateway=ssl&vpc_MerchTxnRef=${""}&credit_phoneno_hidden=$country&credit_email_hidden=$country&productamount=$finalamount&vendorId=$merchantID&merchant_code=$merchantSadadID&website_ref_no=$country&return_url=$country&transactionEntityId=9&ipAddress=$ipAddress&firstName=$firstName&lastName=$lastName&nameOnCard=$cardHolderName&email=$emailId&mobilePhone=$cellNo&productdetail=$strProductDetails&paymentCode=${widget.token}";
                      // var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
                      // String encodedString = base64.encode(utf8.encode(temp)).trim();
                      // var postString =
                      //     "is_Flutter=1&vpc_Version=1&deviceIp=$ipAddress&transactionmodeId=5&MID=${userMetaPreference?.user?.sadadId.toString() ?? userMetaPreference?.userId}&vpc_Command=pay&vpc_Merchant=${userMetaPreference?.user?.sadadId.toString()}&vpc_AccessCode=F4996AF0&vpc_MerchTxnRef=6AQ89F3&vpc_OrderInfo=Test Order&vpc_Amount=${widget.amount}&vpc_Currency=QAR&vpc_TicketNo=6AQ89F3&vpc_ReturnURL=https://sadad.de/bankapi/25/PHP_VPC_3DS 2.5 Party_DR.php&vpc_Gateway=ssl&vpc_MerchTxnRef=SD417921222270&transactionEntityId=9&email=demo@gmail.com&mobilePhone=9749898989898&city=&country=&walletProvider=GOOGLE_PAY&paymentToken=$tokenData&carduser_id=${userMetaPreference?.userId}";
                      var temp = CryptLib.instance.encryptPlainTextWithRandomIV(postString, "XDRvx?#Py^5V@3jC");
                      String encodedString = base64.encode(utf8.encode(temp)).trim();

                      var htmlString2 = await AppServices.googlePayment(encrypt_string: encodedString);
                      // Map? htmlString = await AppServices.googlePayCompletion(
                      //   encodedString: encodedString,
                      //   googlePayURL: ApiEndPoint.googlePayWebRequest,
                      // );
                      Navigator.pop(context);
                      // if (htmlString == null) {
                      //   AppDialog.commonWarningDialog(
                      //       themeColor: widget.themeColor ?? AppColors.primaryColor,
                      //       useMobileLayout: useMobileLayout,
                      //       context: context,
                      //       title: "Issue".translate(),
                      //       subTitle:
                      //           "Sorry, We are not able to process the transaction. Please try again.".translate(),
                      //       buttonOnTap: () {
                      //         Navigator.pop(context);
                      //         Navigator.pop(context);
                      //       },
                      //       buttonText: "Okay".translate());
                      // } else {
                      //   if (htmlString["status"].toString() == "success") {
                      //webViewString = htmlString["msg"];
                      //webController.loadHtmlString(webViewString as String);
    if (htmlString2.toString().contains("<div")) {
                        //if(true) {
                        WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
                          themeColor: widget.themeColor ?? primaryColor,
                          merchantSadadId: userMetaPreference?.user?.sadadId,
                          checksum: checkSum,
                          merchantUserId: userMetaPreference?.userId,
                          cardHolderName: "cardholdername",
                          email: widget.email,
                          paymentMethod: "googlePay",
                          contactNumber: widget.mobile,
                          transactionAmount: widget.amount,
                          productDetail: widget.productDetail,
                          transactionId: "",
                          token: widget.token,
                          htmlString:htmlString2,//htmlString?["msg"],
                        );
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
                          },
                        ));
                      } else {
                        AppDialog.commonWarningDialog(
                            themeColor: widget.themeColor ?? AppColors.primaryColor,
                            useMobileLayout: useMobileLayout,
                            context: context,
                            title: "Issue".translate(),
                            subTitle:
                                "Sorry, We are not able to process the transaction. Please try again.".translate(),
                            buttonOnTap: () {
                              Navigator.pop(context);
                              },
                            buttonText: "Okay".translate());
                      }
                      // } else {
                      //   AppDialog.commonWarningDialog(
                      //       themeColor: widget.themeColor ?? AppColors.primaryColor,
                      //       useMobileLayout: useMobileLayout,
                      //       context: context,
                      //       title: "Issue".translate(),
                      //       subTitle: htmlString["msg"].toString(),
                      //       buttonOnTap: () {
                      //         Navigator.pop(context);
                      //         Navigator.pop(context);
                      //       },
                      //       buttonText: "Okay".translate());
                      // }
                      //}
                      //print("html String $htmlString");
                    },
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          )
      ]),
    );
  }

  PopupMenuItem commonPopupMenuItem({required Function() onTap, required String value, required String text}) {
    return PopupMenuItem(
      padding: const EdgeInsets.only(left: 10),
      height: useMobileLayout ? 30 : 50,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: useMobileLayout ? 20 : 30,
            width: useMobileLayout ? 20 : 30,
            child: Radio(
              activeColor: widget.themeColor,
              value: value,
              groupValue: selectedLanguage.languageCode,
              onChanged: null,
              fillColor: MaterialStateProperty.all(widget.themeColor),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: useMobileLayout ? 14 : 20),
          ),
        ],
      ),
    );
  }

  Widget priceWidget({required String price, double? fontSizeForLabel, double? fontSizeForPrice}) {
    return selectedLanguage.languageCode == "ar"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" ر.ق ",
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForLabel ?? 10,
                      fontWeight: FontWeight.w900,
                      fontFeatures: [const FontFeature.superscripts()])),
              Text(price,
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForPrice ?? 15,
                      fontWeight: FontWeight.w900)),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(price,
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForPrice ?? 15,
                      fontWeight: FontWeight.w900)),
              Text("QAR",
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForLabel ?? 10,
                      fontWeight: FontWeight.w900,
                      fontFeatures: [const FontFeature.superscripts()])),
            ],
          );
  }

  Widget payButtonPriceWidget({required String price, double? fontSizeForLabel, double? fontSizeForPrice}) {
    return selectedLanguage.languageCode == "ar"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" ر.ق ",
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForLabel ?? 10,
                      fontWeight: FontWeight.w900,
                      fontFeatures: [const FontFeature.superscripts()])),
              Text(selectedLanguage.languageCode == "en" ? "Pay".translate() + price : price,
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForPrice ?? 15,
                      fontWeight: FontWeight.w900)),
              selectedLanguage.languageCode == "ar"
                  ? Text("Pay".translate(),
                      style: TextStyle(
                          color: widget.paymentButtonTextColor ?? Colors.white,
                          fontSize: fontSizeForPrice ?? 15,
                          fontWeight: FontWeight.w900))
                  : SizedBox(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedLanguage.languageCode == "en" ? "Pay".translate() + price : price,
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForPrice ?? 15,
                      fontWeight: FontWeight.w900)),
              Text("QAR ",
                  style: TextStyle(
                      color: widget.paymentButtonTextColor ?? Colors.white,
                      fontSize: fontSizeForLabel ?? 10,
                      fontWeight: FontWeight.w900,
                      fontFeatures: [const FontFeature.superscripts()])),
              selectedLanguage.languageCode == "ar"
                  ? Text("Pay".translate(),
                      style: TextStyle(
                          color: widget.paymentButtonTextColor ?? Colors.white,
                          fontSize: fontSizeForPrice ?? 15,
                          fontWeight: FontWeight.w900))
                  : SizedBox(),
            ],
          );
  }

  Widget cardContainer(bool useMobileLayout,
      {required String text, required String imagePath, required PaymentType type}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedPaymentMethod = type;
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          clipBehavior: Clip.hardEdge,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              // BoxShadow(
              //     color: Colors.black12,
              //     offset: Offset(0, 3),
              //     blurStyle: BlurStyle.inner,
              //     blurRadius: 5)
            ],
          ),
          height: useMobileLayout ? 60 : 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.white, boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, blurStyle: BlurStyle.outer),
            BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurStyle: BlurStyle.inner, blurRadius: 5)
          ]),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage(imagePath, package: 'sadad_payment_flutter'),
                          size: 25, color: selectedPaymentMethod == type ? widget.themeColor : AppColors.grey),
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(text,
                              style: TextStyle(fontSize: useMobileLayout ? 12 : 18, fontWeight: FontWeight.w500))),
                      Container(height: 8)
                    ]),
              ),
              Container(height: 7.5, color: selectedPaymentMethod == type ? primaryColor : AppColors.transparent)
            ],
          ),
        ),
      ),
    );
  }

  getSelectedPaymentMethod({required PaymentType selectedMethod}) {
    switch (selectedMethod) {
      case PaymentType.creditCard:
        return creditCardContainer();
      case PaymentType.debitCard:
        return debitCardContainer();
      case PaymentType.sadadPay:
        return sadadPayContainer();
    }
  }

  Widget creditCardContainer() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
          border: Border.all(color: AppColors.borderColor),
          boxShadow: const [
            BoxShadow(color: AppColors.black12, offset: Offset(0, 0), blurRadius: 5, blurStyle: BlurStyle.outer)
          ]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Focus(
          onFocusChange: (hasFocus) {
            if (cardHolderNameController.text != "") {
              creditCardHolderForm.currentState?.validate();
            }
          },
          child: Form(
            key: creditCardHolderForm,
            child: CommonWidgets.commonUnderLineTextField(
                useMobileLayout: useMobileLayout,
                helperText: null,
                validator: (p0) {
                  List values = p0?.trim().split(" ") ?? [];
                  if (p0!.isEmpty) {
                    return "Please enter the card holder name".translate();
                  } else if (values.length != 2) {
                    return "Card holder name is wrong.".translate();
                  } else if (values.length == 1) {
                    return "Please enter full card holder name.".translate();
                  } else {
                    return null;
                  }
                },
                controller: cardHolderNameController,
                labelText: "Card Holder Name".translate(),
                keyboardType: TextInputType.text,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))],
                themeColor: widget.themeColor ?? primaryColor,
                maxlength: 100),
          ),
        ),
        Focus(
          onFocusChange: (hasFocus) {
            if (cardNumberController.text != "") {
              creditCardNumberForm.currentState?.validate();
            }
          },
          child: Form(
            key: creditCardNumberForm,
            child: CommonWidgets.commonUnderLineTextField(
                useMobileLayout: useMobileLayout,
                helperText: null,
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                validator: (p0) {
                  cardType = getCardType(p0!);
                  if (p0.length > 6 && p0.replaceAll('-', '').substring(0, 6) == '639950') {
                    return "Select the Debit Card option to pay via Himyan card".translate();
                  } else if (cardType == "Amex" || cardType == "Visa" || cardType == "Mastercard") {
                    if (cardType == "Amex" && p0.length < 15 ||
                        (cardType == "Visa" && p0.length < 16) ||
                        (cardType == "Mastercard" && p0.length < 16)) {
                      return "Please enter a valid credit card number.".translate();
                    } else {
                      return null;
                    }
                  } else {
                    return "This card is not supported".translate();
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(19),
                  CreditCardFormatter(isRtl: selectedLanguage.languageCode == "ar")
                ],
                controller: cardNumberController,
                maxlength: 19,
                labelText: "Card Number".translate(),
                onChanged: (cardNumber) {
                  setState(() {
                    cardType = getCardType(cardNumber);
                  });
                },
                suffixIcon: cardNumberController.text.isEmpty
                    //? const SizedBox()
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(AssetPath.masterCard, package: 'sadad_payment_flutter', height: 19),
                          Image.asset(AssetPath.visa, package: 'sadad_payment_flutter', height: 19),
                          Image.asset(AssetPath.americanExpress, package: 'sadad_payment_flutter', height: 19)
                        ],
                      )
                    : getImagePath(cardType).isEmpty
                        ? const SizedBox()
                        : Image.asset(getImagePath(cardType), package: 'sadad_payment_flutter', height: 19),
                themeColor: widget.themeColor ?? primaryColor),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (expiryController.text != "") {
                    expiryValidityForm.currentState?.validate();
                  }
                },
                child: Form(
                  key: expiryValidityForm,
                  child: CommonWidgets.commonUnderLineTextField(
                      useMobileLayout: useMobileLayout,
                      hintText: "MM/YY",
                      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ExpiryDateFormatter() /*TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.length > 2 && (newValue.text.contains("/") == false)) {
                            print("base:::${newValue.selection.baseOffset}");
                            print("${newValue.selection.baseOffset}");
                            String text = newValue.text.replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}/");
                            return TextEditingValue(
                                text: text,
                                selection: TextSelection.collapsed(offset: (oldValue.text.length < newValue.text.length) ? newValue.selection.baseOffset + 1 : newValue.selection.baseOffset - 1),
                                composing: newValue.composing);
                          } else {
                            return newValue;
                          }
                        })*/
                      ],
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please enter the expiry date.".translate();
                        } else if (p0.length < 5) {
                          return "Please enter a valid expiry date.".translate();
                        } else if (int.parse(p0.split("/").first) > 12 || int.parse(p0.split("/").first) < 1) {
                          return "Please enter a valid expiry date.".translate();
                        } else {
                          int currentYear = DateTime.now().year;
                          int enteredYear =
                              int.parse(currentYear.toString()[0] + currentYear.toString()[1] + p0.split("/").last);
                          int enteredMonth = int.parse(p0.split("/").first);
                          DateTime date = DateTime(enteredYear, enteredMonth + 1);

                          if (date.isBefore(DateTime.now())) {
                            return "Please enter a valid expiry date.".translate();
                          } else {
                            return null;
                          }
                        }
                      },
                      controller: expiryController,
                      labelText: "Expiry".translate(),
                      themeColor: widget.themeColor ?? primaryColor,
                      maxlength: 5),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (cvvController.text != "") {
                    cvvForm.currentState?.validate();
                  }
                },
                child: Form(
                  key: cvvForm,
                  child: CommonWidgets.commonUnderLineTextField(
                      useMobileLayout: useMobileLayout,
                      isObscure: true,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return "Please enter the CVV.".translate();
                        } else if (p0.length < (cardType == "Amex" ? 4 : 3)) {
                          return "Please enter a valid CVV.".translate();
                        } else {
                          return null;
                        }
                      },
                      controller: cvvController,
                      maxlength: cardType == "Amex" ? 4 : 3,
                      labelText: "CVV",
                      suffixIcon: InkWell(
                          onTap: () {
                            cvvDialog();
                          },
                          child: ImageIcon(
                            const AssetImage(AssetPath.cvvIconPNG, package: 'sadad_payment_flutter'),
                            size: 25,
                            color: widget.themeColor,
                          )),
                      // child: SvgPicture.asset(AssetPath.cvvIconSVG,
                      //     package: 'sadad_payment_flutter', color: widget.themeColor)),
                      themeColor: widget.themeColor ?? primaryColor),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        paymentButton(
          type: "credit",
          title: " ${roundOffToXDecimal(widget.amount, numberOfDecimal: 2)}",
          onTap: () async {
            if (expiryValidityForm.currentState!.validate()) {}
            if (creditCardHolderForm.currentState!.validate()) {}
            if (creditCardNumberForm.currentState!.validate()) {}
            if (cvvForm.currentState!.validate()) {}

            if (expiryValidityForm.currentState!.validate() &&
                creditCardHolderForm.currentState!.validate() &&
                creditCardNumberForm.currentState!.validate() &&
                cvvForm.currentState!.validate()) {
              String cardType = getCardType(cardNumberController.text);
              String firstSixDigit = cardNumberController.text.replaceAll("-", "").substring(0, 6);
              // if (cardType == "Amex" && is_american_express == "0") {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text("American Express card not allowed for your merchant.".translate()),
              //   ));
              // } else {
              //   AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
              //
              //   String? ipAddress = await NetworkInfo().getWifiIPv6();
              //   String merchantID = userMetaPreference?.userId ?? ""; //"9246722"
              //   String? cardNumberWithoutSpace = cardNumberController.text.replaceAll("-", "");
              //   List tempExpiryDate = expiryController.text.split("/");
              //   var expiryDate = tempExpiryDate.last.toString() + tempExpiryDate.first.toString();
              //   var lang = selectedLanguage.languageCode == "en" ? "en" : "ar";
              //
              //   var response = await AppServices.CreditCardPayment(
              //       hash: checkSum,
              //       card_type: cardType,
              //       token: widget.token,
              //       cardsixdigit: firstSixDigit,
              //       mobileNumber: widget.mobile,
              //       orderId: widget.orderId,
              //       txnAmount: widget.amount,
              //       productDetail: widget.productDetail,
              //       is_american_express: is_american_express == "0" ? false : true,
              //       is_cybersourse_visa: int.parse(is_cybersourse_visa),
              //       credit_card_bankpage_type: credit_card_bankpage_type,
              //       is_cybersourse_mastercard: int.parse(is_cybersourse_mastercard),
              //       ipAddress: ipAddress ?? "",
              //       merchantID: merchantID,
              //       expiryDate: expiryDate,
              //       lang: lang,
              //       mobileos: Platform.isIOS ? "1" : "2",
              //       isAmexAllowed: is_american_express == "0" ? false : true,
              //       cvv: cvvController.text,
              //       email: widget.email,
              //       cardnumber: cardNumberWithoutSpace,
              //       cardHolderName: cardHolderNameController.text,
              //       lastname: cardHolderNameController.text.split(" ").last,
              //       firstname: cardHolderNameController.text.split(" ").first,
              //       issandboxmode: (widget.packageMode == PackageMode.debug) ? "1" : "0",
              //       userMetaPreference: userMetaPreference!);
              //
              //   Navigator.pop(context);
              //   if (response["msg"] != null) {
              //     WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
              //         themeColor: widget.themeColor ?? primaryColor,
              //         packageMode: widget.packageMode ?? PackageMode.release,
              //         token: widget.token,
              //         isAmexEnableForAdmin: is_american_express == "0" ? false : true,
              //         isMasterEnableForCyber: userMetaPreference?.isallowedtocybersourcemastercard ?? false ? 0 : 1,
              //         isVisaEnableForCyber: userMetaPreference?.isallowedtocybersourcevisa ?? false ? 0 : 1,
              //         merchantUserId: userMetaPreference?.userId,
              //         isMasterEnableForCyberAdmin: int.parse(is_cybersourse_mastercard),
              //         isVisaEnableForCyberAdmin: int.parse(is_cybersourse_visa),
              //         creditcardType: cardType,
              //         sadadId: "",
              //         cardnumber: cardNumberController.text,
              //         expiryDate: expiryController.text,
              //         cvv: cvvController.text,
              //         cardHolderName: cardHolderNameController.text,
              //         customerName: widget.customerName,
              //         transactionAmount: (widget.amount * 100),
              //         transactionId: "",
              //         contactNumber: widget.mobile,
              //         paymentMethod: "credit",
              //         email: widget.email,
              //         isWebContentAvailable: true,
              //         webContent: response["msg"]);
              //     Navigator.push(context, MaterialPageRoute(
              //       builder: (context) {
              //         return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
              //       },
              //     ));
              //   } else {
              //     AppDialog.commonWarningDialog(
              //         themeColor: widget.themeColor ?? AppColors.primaryColor,
              //         useMobileLayout: useMobileLayout,
              //         context: context,
              //         title: "Error".translate(),
              //         subTitle: response["message"],
              //         buttonOnTap: () {
              //           Navigator.pop(context);
              //         },
              //         buttonText: "Okay".translate());
              //   }
              // }
              if (cardType == "Amex" && is_american_express == "0") {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("American Express card not allowed for your merchant.".translate()),
                ));
              }
              else {
                AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
                CheckedAllowedCountryModel? data =
                    await AppServices.checkAllowedCountry(cardsixdigit: firstSixDigit, token: widget.token);

                ///change on live
                if (data?.isAllowed == true) {
                  // pass securedata parameter
                  var response = await AppServices.GenerateCreditCardTransectionID(
                      hash: checkSum,
                      card_type: cardType,
                      token: widget.token,
                      cardsixdigit: firstSixDigit,
                      mobileNumber: widget.mobile,
                      orderId: widget.orderId,
                      txnAmount: widget.amount,
                      productDetail: widget.productDetail,
                      is_american_express: is_american_express == "0" ? false : true,
                      is_cybersourse_visa: int.parse(is_cybersourse_visa),
                      credit_card_bankpage_type: credit_card_bankpage_type,
                      is_cybersourse_mastercard: int.parse(is_cybersourse_mastercard),
                      userMetaPreference: userMetaPreference!);

                  Navigator.pop(context);
                  if (response is String) {
                    AppDialog.commonWarningDialog(
                        themeColor: widget.themeColor ?? AppColors.primaryColor,
                        useMobileLayout: useMobileLayout,
                        context: context,
                        title: "Error".translate(),
                        subTitle: response,
                        buttonOnTap: () {
                          Navigator.pop(context);
                        },
                        buttonText: "Okay".translate());
                  } else if (response is TransactionIdDetailsModel) {
                    // String sadad_id = response.sadadId ?? "";
                    //String invoiceNumber = response.invoicenumber ?? "";
                    WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
                        themeColor: widget.themeColor ?? primaryColor,
                        packageMode: widget.packageMode ?? PackageMode.release,
                        token: widget.token,
                        isAmexEnableForAdmin: is_american_express == "0" ? false : true,
                        isMasterEnableForCyber: userMetaPreference?.isallowedtocybersourcemastercard ?? false ? 0 : 1,
                        isVisaEnableForCyber: userMetaPreference?.isallowedtocybersourcevisa ?? false ? 0 : 1,
                        merchantUserId: userMetaPreference?.userId,
                        isMasterEnableForCyberAdmin: int.parse(is_cybersourse_mastercard),
                        isVisaEnableForCyberAdmin: int.parse(is_cybersourse_visa),
                        creditcardType: cardType,
                        sadadId: response.sadadId ?? "",
                        cardnumber: cardNumberController.text,
                        expiryDate: expiryController.text,
                        cvv: cvvController.text,
                        cardHolderName: cardHolderNameController.text,
                        customerName: widget.customerName,
                        transactionAmount: (widget.amount * 100),
                        transactionId: response.invoicenumber.toString(),
                        contactNumber: widget.mobile,
                        paymentMethod: "credit",
                        email: widget.email);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
                      },
                    ));
                  }
                } else {
                  Navigator.pop(context);
                  AppDialog.commonWarningDialog(
                      themeColor: widget.themeColor ?? AppColors.primaryColor,
                      useMobileLayout: useMobileLayout,
                      context: context,
                      title: "Not Allowed".translate(),
                      subTitle: "Transaction is not allowed from your country.".translate(),
                      buttonOnTap: () {
                        Navigator.pop(context);
                      },
                      buttonText: "Okay".translate());
                }
              }
            }
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        commonSecurityText()
      ]),
    );
  }

  Widget sadadPayContainer() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: AppColors.borderColor),
          boxShadow: const [
            BoxShadow(color: AppColors.black12, offset: Offset(0, 0), blurRadius: 5, blurStyle: BlurStyle.outer)
          ]),
      child: Form(
        key: sadadPayForm,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AssetPath.sadadLogo,
                    package: 'sadad_payment_flutter',
                    width: 50,
                  ),
                  const SizedBox(height: 5),
                  Text("Login with your Sadad account".translate(),
                      style: TextStyle(fontSize: useMobileLayout ? 10 : 15, color: AppColors.black.withOpacity(0.5)))
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Image.asset(
              //       AssetPath.sadadLogo,
              //       package: 'sadad_payment_flutter',
              //       width: 50,
              //     ),
              //     SizedBox(height: 5),
              //     Text("Or Scan", style: TextStyle(fontSize: 10, color: AppColors.black.withOpacity(0.5)))
              //   ],
              // ),
            ],
          ),
          const SizedBox(height: 15),
          IgnorePointer(
            ignoring: sadadPayOTPSent,
            child: Column(
              children: [
                CommonWidgets.commonUnderLineTextField(
                    useMobileLayout: useMobileLayout,
                    helperText: null,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return "Please enter the mobile number.".translate();
                      } else if (p0.length < 8) {
                        return "Mobile number should be 8 digits or more.".translate();
                      } else {
                        return null;
                      }
                    },
                    onChanged: (p0) {
                      setState(() {});
                    },
                    maxlength: 8,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                    readOnly: sadadPayOTPSent,
                    controller: sadadPayCellNumberController,
                    themeColor: widget.themeColor ?? primaryColor,
                    labelText: "Mobile Number".translate()),
                CommonWidgets.commonUnderLineTextField(
                    useMobileLayout: useMobileLayout,
                    helperText: null,
                    validator: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return "Please enter the password.".translate();
                      } else {
                        return null;
                      }
                    },
                    onChanged: (p0) {
                      setState(() {});
                    },
                    readOnly: sadadPayOTPSent,
                    controller: sadadPayPasswordController,
                    isObscure: isObscure,
                    maxlength: 15,
                    themeColor: widget.themeColor ?? primaryColor,
                    labelText: "Password".translate(),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isObscure) {
                              isObscure = false;
                            } else {
                              isObscure = true;
                            }
                          });
                        },
                        child: Image.asset(isObscure ? AssetPath.icEyeClose : AssetPath.icEyeOpen,
                            package: 'sadad_payment_flutter', color: widget.themeColor, height: 20),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 35),
          paymentButton(
            enabled: sadadPayPasswordController.text.isNotEmpty && (sadadPayCellNumberController.text.length == 8),
            type: "sadadPay",
            title: " ${roundOffToXDecimal(widget.amount, numberOfDecimal: 2)}",
            onTap: () async {
              if (sadadPayForm.currentState?.validate() ?? false) {
                AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
                sendOtpModel = await AppServices.sadadPayLoginV6(
                    token: widget.token,
                    password: sadadPayPasswordController.text,
                    cellnumber: sadadPayCellNumberController.text,
                    issandboxmode: (widget.packageMode == PackageMode.debug) ? "1" : "0");
                Navigator.pop(context);
                if (sendOtpModel != null) {
                  sadadPayOTPSent = true;
                  counter = 59;
                  // initOTPCounter();
                  otpVerificationDialog();
                  setState(() {});
                } else {
                  AppDialog.commonWarningDialog(
                      themeColor: widget.themeColor ?? AppColors.primaryColor,
                      useMobileLayout: useMobileLayout,
                      context: context,
                      title: "Issue".translate(),
                      subTitle: "Either your registered mobile number or password is wrong.".translate(),
                      buttonOnTap: () {
                        Navigator.pop(context);
                      },
                      buttonText: "Okay".translate());
                }
              }

              // var amount = widget.amount.toString();
              // var values = amount.split('.');
              // if (values.length > 1) {
              //   if (values[1].length > 2) {
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           return AlertDialog(
              //             actions: [
              //               InkWell(
              //                   onTap: () {
              //                     Navigator.pop(context);
              //                   },
              //                   child: Text("Okay".translate()))
              //             ],
              //             title: Text("Please enter amount upto 2 decimal points".translate()),
              //           );
              //         });
              //   } else {
              //     SadadPayMinAmountCheckModel? sadadPayMinAmountCheckModel = await AppServices.sadadPayMinAmountCheck(token: widget.token);
              //     if (sadadPayMinAmountCheckModel == null) {
              //       showDialog(
              //           context: context,
              //           builder: (context) {
              //             return AlertDialog(
              //               actions: [
              //                 InkWell(
              //                     onTap: () {
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text("Okay".translate()))
              //               ],
              //               title: Text("Something went wrong. Please try again".translate()),
              //             );
              //           });
              //     } else {
              //       double value = double.parse(sadadPayMinAmountCheckModel.value);
              //       if (AppConstant.transactionAmount < value) {
              //         showDialog(
              //             context: context,
              //             builder: (context) {
              //               return AlertDialog(
              //                 actions: [
              //                   InkWell(
              //                       onTap: () {
              //                         Navigator.pop(context);
              //                       },
              //                       child: Text("Okay".translate()))
              //                 ],
              //                 title: Text("The Given Transaction Amount is less than ".translate() + "${value}." + " Please try with valid amount!".translate()),
              //               );
              //             });
              //       } else {
              //         WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
              //             packageMode: widget.packageMode ?? PackageMode.release,
              //             token: widget.token,
              //             isAmexEnableForAdmin: is_american_express == "0" ? true : false,
              //             isMasterEnableForCyber: userMetaPreference?.isallowedtocybersourcemastercard ?? false ? 0 : 1,
              //             isVisaEnableForCyber: userMetaPreference?.isallowedtocybersourcevisa ?? false ? 0 : 1,
              //             isMasterEnableForCyberAdmin: int.parse(is_cybersourse_mastercard),
              //             isVisaEnableForCyberAdmin: int.parse(is_cybersourse_visa),
              //             creditcardType: "",
              //             sadadId: "",
              //             cardnumber: controller.cardNumberController.text,
              //             expiryDate: controller.expiryController.text,
              //             cvv: controller.cvvController.text,
              //             cardHolderName: controller.cardHolderNameController.text,
              //             customerName: widget.customerName,
              //             transactionAmount: (widget.amount * 100),
              //             transactionId: "",
              //             contactNumber: widget.mobile,
              //             productDetail: widget.productDetail,
              //             paymentMethod: "sadadPay",
              //             email: widget.email);
              //         Navigator.push(context, MaterialPageRoute(
              //           builder: (context) {
              //             return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
              //           },
              //         )).then((value) {
              //           Navigator.pop(context, value);
              //         });
              //       }
              //     }
              //   }
              // }
            },
          ),
          const SizedBox(height: 15),
          commonSecurityText()
        ]),
      ),
    );
  }

  Widget debitCardContainer() {
    return Container(
      height: 370,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: AppColors.borderColor),
          boxShadow: const [
            BoxShadow(color: AppColors.black12, offset: Offset(0, 0), blurRadius: 5, blurStyle: BlurStyle.outer)
          ]),
      child: Column(children: [
        Row(
          children: [
            Image.asset(AssetPath.debitNaps, package: 'sadad_payment_flutter', width: 85),
            const SizedBox(width: 16),
            Image.asset(AssetPath.debitHimyan, package: 'sadad_payment_flutter', width: 85),
            // Text(
            //   "Debit Card".translate(),
            //   style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
        const SizedBox(
          height: 13,
        ),
        // const SizedBox(height: 15),
        Text(
          "When you choose to complete your payment using a debit card issued in Qatar, you will be temporarily redirected to the QPay website. Once the transaction is completed, you'll be taken back to the Sadad to view your confirmation."
              .translate(),
          style: TextStyle(
              fontFamily: "openSans",
              fontSize: useMobileLayout ? 12 : 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: AppColors.black.withOpacity(0.7),
              height: 1.7),
        ),
        const Spacer(),
        paymentButton(
          type: "Debit",
          title: " ${roundOffToXDecimal(widget.amount, numberOfDecimal: 2)}",
          onTap: () async {
            var response = await AppServices.GenerateDebitCardTransactionID(
                hash: checkSum,
                token: widget.token,
                mobileNumber: widget.mobile,
                txnAmount: widget.amount,
                productDetail: widget.productDetail,
                orderId: widget.orderId,
                userMetaPreference: userMetaPreference!);
            if (response is int) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Text(response.toString()),
                    );
                  });
            } else if (response is TransactionIdDetailsModel) {
              WebViewDetailsModel webViewDetailsModel = WebViewDetailsModel(
                  themeColor: widget.themeColor ?? primaryColor,
                  packageMode: widget.packageMode,
                  token: widget.token,
                  isAmexEnableForAdmin: is_american_express == "0" ? false : true,
                  isMasterEnableForCyber: userMetaPreference?.isallowedtocybersourcemastercard ?? false ? 0 : 1,
                  isVisaEnableForCyber: userMetaPreference?.isallowedtocybersourcevisa ?? false ? 0 : 1,
                  isMasterEnableForCyberAdmin: int.parse(is_cybersourse_mastercard),
                  isVisaEnableForCyberAdmin: int.parse(is_cybersourse_visa),
                  creditcardType: "",
                  sadadId: response.sadadId ?? "",
                  cardnumber: cardNumberController.text,
                  expiryDate: expiryController.text,
                  cvv: cvvController.text,
                  cardHolderName: cardHolderNameController.text,
                  customerName: widget.customerName,
                  transactionAmount: (widget.amount * 100),
                  transactionId: response.invoicenumber.toString(),
                  contactNumber: widget.mobile,
                  paymentMethod: "debit",
                  email: widget.email);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return PaymentWebViewScreen(webViewDetailsModel: webViewDetailsModel);
                },
              ));
            }
          },
        ),
        const SizedBox(height: 15),
        commonSecurityText()
      ]),
    );
  }

  bottomContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            securityContainer(AssetPath.mcAfee),
            securityContainer(AssetPath.comodoSecure),
            securityContainer(AssetPath.symantec),
            securityContainer(AssetPath.pciDss)
          ]),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(const AssetImage(AssetPath.lock, package: 'sadad_payment_flutter'),
                  size: useMobileLayout ? 10 : 15, color: widget.themeColor),
              const SizedBox(width: 3),
              Text("100% secured Payment ".translate(),
                  style: TextStyle(fontSize: useMobileLayout ? 10 : 15, color: AppColors.greyTextColor)),
              Text(
                "Powered by Sadad".translate(),
                style: TextStyle(fontSize: useMobileLayout ? 10 : 15, color: primaryColor),
              )
            ],
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  commonSecurityText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: ImageIcon(const AssetImage(AssetPath.lock, package: 'sadad_payment_flutter'),
              size: useMobileLayout ? 10 : 15, color: widget.themeColor),
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Wrap(children: [
            Text("Payment is Secured with 256bit SSL encryption ".translate(),
                style: TextStyle(fontSize: useMobileLayout ? 10 : 15, color: AppColors.greyTextColor)),
            Text(
              "(You are safe)".translate(),
              style: TextStyle(fontSize: useMobileLayout ? 10 : 15, color: primaryColor),
            )
          ]),
        )
      ],
    );
  }

  Widget securityContainer(String imagepath) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: AppColors.borderColor, borderRadius: BorderRadius.circular(5)),
      child: Image.asset(imagepath, width: MediaQuery.of(context).size.width * 0.20, package: 'sadad_payment_flutter'),
    );
  }

  Widget paymentButton({required String title, required Function() onTap, required String type, bool enabled = true}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            foregroundDecoration: BoxDecoration(color: enabled ? null : Colors.white54),
            decoration: BoxDecoration(
                color: widget.paymentButtonColor ?? primaryColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.paymentButtonBorder)),
            height: useMobileLayout ? 50 : 65,
            child: Center(
                child: payButtonPriceWidget(
                    price: title,
                    fontSizeForLabel: useMobileLayout ? null : 15,
                    fontSizeForPrice: useMobileLayout ? null : 24)),
          )),
    );
  }

  Future<void> creditCardSettingsAndValidation({required String token}) async {
    await Future.delayed(Duration.zero, () {});
    //check email
    if (!emailCheckOne.hasMatch(widget.email) || !checkEmailLastPartContainNumber(widget.email)) {
      AppDialog.commonWarningDialog(
          themeColor: widget.themeColor ?? AppColors.primaryColor,
          context: context,
          title: "Error".translate(),
          subTitle: "Invalid email.".translate(),
          buttonText: "Okay".translate(),
          buttonOnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          useMobileLayout: useMobileLayout);
      return;
    }
    //check title
    if (widget.titleText.length > 30) {
      if (context.mounted) {
        AppDialog.commonWarningDialog(
            themeColor: widget.themeColor ?? AppColors.primaryColor,
            context: context,
            title: "Invalid Title".translate(),
            subTitle: "Title must be shorter then 30 characters".translate(),
            buttonText: "Okay".translate(),
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            useMobileLayout: useMobileLayout);
      }

      return;
    }
    if (widget.orderId.isEmpty) {
      if (context.mounted) {
        AppDialog.commonWarningDialog(
            themeColor: widget.themeColor ?? AppColors.primaryColor,
            context: context,
            title: "Invalid Order ID".translate(),
            subTitle: "Order id must not be empty".translate(),
            buttonText: "Okay".translate(),
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            useMobileLayout: useMobileLayout);
      }
      return;
    }
    RegExp regexOrderId = RegExp(r"^[a-zA-Z0-9-._]+$");
    if (regexOrderId.hasMatch(widget.orderId) == false) {
      if (context.mounted) {
        AppDialog.commonWarningDialog(
            themeColor: widget.themeColor ?? AppColors.primaryColor,
            context: context,
            title: "Invalid Order ID".translate(),
            subTitle:
                "Order IDs should include only alphanumeric characters, hyphens (-), dots (.), and underscores (_)."
                    .translate()
                    .translate(),
            buttonText: "Okay".translate(),
            buttonOnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            useMobileLayout: useMobileLayout);
      }
      return;
    }

    //check mobile
    widget.mobile = widget.mobile.replaceAll("+", "");
    //print("checkmobile ===>> ${widget.mobile.length < 8 || widget.mobile.length > 15}");
    if (widget.mobile.length < 8 || widget.mobile.length > 15) {
      AppDialog.commonWarningDialog(
          themeColor: widget.themeColor ?? AppColors.primaryColor,
          context: context,
          title: "Please enter a valid mobile number.".translate(),
          subTitle: "Please ensure that your mobile number contains between 8 and 16 digits.".translate(),
          buttonText: "Okay".translate(),
          buttonOnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          useMobileLayout: useMobileLayout);
      return;
    }
    //convert amount
    if (widget.amount.toString().split(".")[1].length > 2) {
      AppDialog.commonWarningDialog(
          themeColor: widget.themeColor ?? AppColors.primaryColor,
          context: context,
          title: "Invalid amount format".translate(),
          subTitle: "Transaction amount should contains up to 2 decimal points.".translate(),
          buttonText: "Okay".translate(),
          buttonOnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          useMobileLayout: useMobileLayout);
      return;
    }
    widget.amount = roundOffToXDecimal(widget.amount, numberOfDecimal: 2);
    // check payment type
    if (!widget.isWalletEnabled && widget.paymentTypes.isEmpty) {
      widget.paymentTypes = [PaymentType.creditCard, PaymentType.debitCard, PaymentType.sadadPay];
    }
    AppDialog.showProcess(context, widget.themeColor ?? primaryColor);

    var settings = await AppServices.SDKSettingAPI(
        token: token,
        mobileNumber: widget.mobile,
        amouont: widget.amount,
        product_detail: widget.productDetail,
        issandboxmode: (widget.packageMode == PackageMode.debug) ? "1" : "0");

    if (settings?["usermetaprefrences"] != null) {
      userMetaPreference = UserMetaPreference.fromJson(settings?["usermetaprefrences"].first);
      List cardSetting = settings?["settings"];
      creditCardSettingsModel = cardSetting.map((e) => CreditCardSettingsModel.fromJson(e)).toList();
      checkSum = settings?['checksum']['hash'];

      creditCardSettingsModel.forEach((element) {
        if (element.key == "credit_card_bankpage_type") {
          credit_card_bankpage_type = element.value ?? "";
        } else if (element.key == 'is_american_express') {
          is_american_express = element.value ?? "";
        } else if (element.key == 'is_cybersourse_visa') {
          is_cybersourse_visa = element.value ?? "";
        } else if (element.key == 'is_cybersourse_mastercard') {
          is_cybersourse_mastercard = element.value ?? "";
        }
      });
      for (var element in creditCardSettingsModel) {
        if (element.key == "sdk_min_amount") {
          int minAmount = int.parse(element.value.toString());
          if (minAmount > widget.amount) {
            AppDialog.commonWarningDialog(
                themeColor: widget.themeColor ?? AppColors.primaryColor,
                context: context,
                title: "Invalid amount".translate(),
                subTitle: "The Given Transaction Amount is less than ".translate() + "$minAmount.",
                buttonText: "Okay".translate(),
                buttonOnTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                useMobileLayout: useMobileLayout);
          }
        }
      }
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      AppDialog.commonWarningDialog(
          themeColor: widget.themeColor ?? AppColors.primaryColor,
          useMobileLayout: useMobileLayout,
          context: context,
          title: "Something went wrong",
          subTitle: settings?["message"] ?? "",
          buttonOnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          buttonText: "Okay".translate());
    }
  }

  cvvDialog() {
    showDialog(
      barrierColor: AppColors.white.withOpacity(0.86),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(15),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  Container(
                    height: 300,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
                    decoration:
                        BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 8,
                      )
                    ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AssetPath.cvvCard,
                            package: 'sadad_payment_flutter', width: MediaQuery.of(context).size.width * 0.45),
                        const SizedBox(height: 15),
                        Text("What is CVV?".translate(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 15),
                        Text(
                          "CVV is the three-digit number on the back of your credit card.".translate(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.iconColor,
                                size: 18,
                              ))))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  otpVerificationDialog() {
    TextEditingController sadadPayOTPController = TextEditingController();
    String? errorText;
    showDialog(
      barrierColor: AppColors.white.withOpacity(0.95),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStatee) {
          return Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SizedBox(
              width: useMobileLayout ? null : 450,
              height: useMobileLayout ? 280 : 360,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: useMobileLayout ? 270 : 320,
                    decoration:
                        BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ]),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(useMobileLayout ? 20 : 40),
                          child: Text("OTP Verification".translate(),
                              style:
                                  const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                        /*PinFieldAutoFill(
                          controller: sadadPayOTPController,
                          textInputAction: TextInputAction.go,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                          decoration: BoxLooseDecoration(
                            radius: const Radius.circular(4),
                            errorText: errorText,
                            hintText: '------',
                            strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                          ),
                          codeLength: 6,
                          onCodeSubmitted: (code) async {},
                          onCodeChanged: (code) async {
                            // setState(() {
                            //   errorText = null;
                            // });
                            print(code!.length);
                            if (code.length == 6) {
                              AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
                              // bool? success = await AppServices.sadadPayVerifyOtp(
                              //     token: widget.token, otp: code, userId: sendOtpModel!.userId!.toString());
                              //Navigator.pop(context);
                              //if (success!) {
                                String? ipAddress = await NetworkInfo().getWifiIPv6();
                                Map? data = await AppServices.sadadPayTransactionV6(
                                    ipAddress: ipAddress ?? "",
                                    sadadId: sendOtpModel!.id!,
                                    userId: sendOtpModel!.userId!,
                                    token: widget.token,
                                    orderId: widget.orderId,
                                    amount: widget.amount,issandboxmode: (widget.packageMode == PackageMode.debug) ? "1" : "0",
                                    productDetails: widget.productDetail, otp: code);
                                Navigator.pop(context);
                                if (data?["statusCode"] != null) {
                                  AppDialog.commonWarningDialog(
                                      themeColor: widget.themeColor ?? AppColors.primaryColor,
                                      useMobileLayout: useMobileLayout,
                                      context: context,
                                      title: "Issue".translate(),
                                      subTitle: data?["message"],
                                      buttonOnTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      buttonText: "Okay".translate());
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context, data);
                                }
                              // } else {
                              //   // setStatee(() {
                              //   //   errorText = "You have entered Invalid OTP.".translate();
                              //   // });
                              //   Navigator.pop(context);
                              //   sadadPayOTPController.clear();
                              //   AppDialog.commonWarningDialog(
                              //       themeColor: widget.themeColor ?? AppColors.primaryColor,
                              //       useMobileLayout: useMobileLayout,
                              //       context: context,
                              //       title: "Issue".translate(),
                              //       subTitle: "You have entered Invalid OTP.".translate(),
                              //       buttonOnTap: () {
                              //         Navigator.pop(context);
                              //       },
                              //       buttonText: "Okay".translate());
                              // }
                            }
                          },
                        ),*/
                        LayoutBuilder(
                          builder: (context, constraints) {

                            final size = (min(constraints.maxWidth, 275) - 30) / 6;

                            return   Pinput(
                              // validator: (s) {
                              //   debugPrint("S ::$s");
                              //   return ((s ?? '').length < 6) ? null : 'Pin is incorrect';
                              // },
                              // pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                              // showCursor: true,
                              keyboardType: TextInputType.number,

                              length: 6,
                              defaultPinTheme: PinTheme(
                                  textStyle: const TextStyle(fontSize: 20),
                                  height: 40,
                                  width: size,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8)
                                  )
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                              ],
                              textInputAction: TextInputAction.go,
                              onCompleted: (pin) async {
                                if (pin.length == 6) {
                                  AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
                                  // bool? success = await AppServices.sadadPayVerifyOtp(
                                  //     token: widget.token, otp: code, userId: sendOtpModel!.userId!.toString());
                                  //Navigator.pop(context);
                                  //if (success!) {
                                  String? ipAddress = await NetworkInfo().getWifiIPv6();
                                  Map? data = await AppServices.sadadPayTransactionV6(
                                      ipAddress: ipAddress ?? "",
                                      sadadId: sendOtpModel!.id!,
                                      userId: sendOtpModel!.userId!,
                                      token: widget.token,
                                      orderId: widget.orderId,
                                      amount: widget.amount,issandboxmode: (widget.packageMode == PackageMode.debug) ? "1" : "0",
                                      productDetails: widget.productDetail, otp: pin);
                                  Navigator.pop(context);
                                  if (data?["statusCode"] != null) {
                                    AppDialog.commonWarningDialog(
                                        themeColor: widget.themeColor ?? AppColors.primaryColor,
                                        useMobileLayout: useMobileLayout,
                                        context: context,
                                        title: "Issue".translate(),
                                        subTitle: data?["message"],
                                        buttonOnTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        buttonText: "Okay".translate());
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pop(context, data);
                                  }
                                  // } else {
                                  //   // setStatee(() {
                                  //   //   errorText = "You have entered Invalid OTP.".translate();
                                  //   // });
                                  //   Navigator.pop(context);
                                  //   sadadPayOTPController.clear();
                                  //   AppDialog.commonWarningDialog(
                                  //       themeColor: widget.themeColor ?? AppColors.primaryColor,
                                  //       useMobileLayout: useMobileLayout,
                                  //       context: context,
                                  //       title: "Issue".translate(),
                                  //       subTitle: "You have entered Invalid OTP.".translate(),
                                  //       buttonOnTap: () {
                                  //         Navigator.pop(context);
                                  //       },
                                  //       buttonText: "Okay".translate());
                                  // }
                                }
                              },
                            );
                          }
                        ),
                        SizedBox(height: useMobileLayout ? 20 : 40),
                        StatefulBuilder(
                          builder: (context, setState) {
                            initOTPCounter() async {
                              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                                setState(() {
                                  counter--;
                                });
                                if (counter < 1) {
                                  timer.cancel();
                                }
                              });
                            }

                            if (counter == 59) {
                              initOTPCounter();
                            }
                            return RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: counter > 0
                                      ? "OTP is valid Upto ".translate()
                                      : "Didn't receive the OTP? ".translate(),
                                  style: TextStyle(color: AppColors.black, fontSize: useMobileLayout ? 13 : 18)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      //print(counter);
                                      if (counter < 1) {
                                        if (counter == 0) {
                                          AppDialog.showProcess(context, widget.themeColor ?? primaryColor);
                                          bool success = await AppServices.sadadPayResendOtpV6(
                                              token: sendOtpModel!.id!,
                                              issandboxmode: (widget.packageMode == PackageMode.debug) ? "1" : "0");
                                          Navigator.pop(context);
                                          if (success) {
                                            counter = 59;
                                            // initOTPCounter();
                                            sadadPayOTPController.clear();
                                          } else {
                                            AppDialog.commonWarningDialog(
                                                themeColor: widget.themeColor ?? AppColors.primaryColor,
                                                useMobileLayout: useMobileLayout,
                                                context: context,
                                                title: "Issue".translate(),
                                                subTitle: "We are not able to process your payment.".translate(),
                                                buttonOnTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                buttonText: "Okay".translate());
                                          }
                                        }
                                      }
                                      setState(() {});
                                    },
                                  text: counter > 0 ? counter.toString() : "Resend".translate(),
                                  style: TextStyle(
                                      color: widget.themeColor,
                                      fontSize: useMobileLayout ? 13 : 18,
                                      fontWeight: FontWeight.w600)),
                              if (counter > 0)
                                TextSpan(
                                    text: " ${"seconds".translate()}",
                                    style: TextStyle(color: AppColors.black, fontSize: useMobileLayout ? 13 : 18)),
                            ]));
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          sadadPayOTPSent = false;
                          counter = 59;
                          timer!.cancel();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: useMobileLayout ? 60 : 70,
                          width: useMobileLayout ? 60 : 70,
                          child: Image.asset(AssetPath.icClose, package: "sadad_payment_flutter", fit: BoxFit.fill),
                        ),
                      ))
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<bool> checkTokenIsValidOrNot() async {
    return await AppServices.checkAccessToken(token: widget.token);
  }

  double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
    // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
    String numbersAfterDecimal = number.toString().split('.')[1];
    if (numbersAfterDecimal != '0' && numbersAfterDecimal.length > 2) {
      int existingNumberOfDecimal = numbersAfterDecimal.length;
      double incrementValue = 1 / (10 * pow(10, existingNumberOfDecimal));
      if (number < 0) {
        number -= incrementValue;
      } else {
        number += incrementValue;
      }
    }

    return double.parse(number.toStringAsFixed(numberOfDecimal));
  }
}

enum PaymentType { creditCard, debitCard, sadadPay }

enum PackageMode { release, debug }

String getCardType(String cardNumber) {
  ///^5[1-5][0-9]{14}$|^2(?:2(?:2[1-9]|[3-9][0-9])|[3-6][0-9][0-9]|7(?:[01][0-9]|20))[0-9]{12}$/
  cardNumber = cardNumber.replaceAll("-", "");
  if (cardNumber.contains(
      RegExp(r'^5[1-5][0-9]{14}$|^2(?:2(?:2[1-9]|[3-9][0-9])|[3-6][0-9][0-9]|7(?:[01][0-9]|20))[0-9]{12}$'))) {
    return "Mastercard";
  } else if (cardNumber.contains(RegExp(r'^4[0-9]{6,}([0-9]{3})?$'))) {
    return "Visa";
  } else if (cardNumber.contains(RegExp(r'^3[47][0-9]{5,}$'))) {
    return "Amex";
  } else if (cardNumber.contains(RegExp(r'^(36|38|30[0-5])'))) {
    return "DINERS_CLUB";
  } else if (cardNumber.contains(RegExp(r'^(5018|5020|5038|5[6-9]|6020|6304|6703|6759|676[1-3])'))) {
    return "MAESTRO";
  } else if (cardNumber.contains(RegExp(r'^(?:2131|1800|35\d{3})\d{11}$'))) {
    return "JCB";
  } else if (cardNumber.contains(RegExp(
      r'^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$'))) {
    return "Discover Card";
  } else if (cardNumber.contains(RegExp(r'^(62[0-9]{14,17})$'))) {
    return "Union Pay Card";
  } else if (cardNumber.contains(RegExp(r'^6(?!011)(?:0[0-9]{14}|52[12][0-9]{12})$'))) {
    return "Rupay";
  }
  return "";

  //639950 start number of himyan
}
