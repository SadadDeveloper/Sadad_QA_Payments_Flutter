
bool isDebug = false;

class ApiEndPoint {
  static String get creditCardSettings {
    if (isDebug) {
      return test_CreditCardSettings;
    } else {
      return Live_CreditCardSettings;
    }
  }

  static String get checkCountry {
    if (isDebug) {
      return test_CheckCountry;
    } else {
      return Live_CheckCountry;
    }
  }

  static String get userMeta {
    if (isDebug) {
      return test_usermeta;
    } else {
      return Live_usermeta;
    }
  }
  static String get transectionURL {
    if (isDebug) {
      return test_TransectionURL;
    } else {
      return Live_TransectionURL;
    }
  }

  static String get generateTransaction {
    if (isDebug) {
      return test_generateTransaction;
    } else {
      return Live_generateTransaction;
    }
  }

  static String get amex_creditCardURL {
    if (isDebug) {
      return test_amex_creditCardURL;
    } else {
      return Live_amex_creditCardURL;
    }
  }

  static String get mpgs_pay_creditCardURL {
    if (isDebug) {
      return test_mpgs_pay_creditCardURL;
    } else {
      return Live_mpgs_pay_creditCardURL;
    }
  }

  static String get debitCardURL {
    if (isDebug) {
      return test_debitCardURL;
    } else {
      return Live_debitCardURL;
    }
  }

  static String get SDKLoginURL {
    if (isDebug) {
      return test_SDKLoginURL;
    } else {
      return Live_SDKLoginURL;
    }
  }

  static String get applepay_URL {
    if (isDebug) {
      return test_applepay_URL;
    } else {
      return Live_applepay_URL;
    }
  }

  static String get validateToken_URL {
    if (isDebug) {
      return test_validate_accesstoken;
    } else {
      return Live_validate_accesstoken;
    }
  }
  static String get sadadPayTransaction {
    if (isDebug) {
      return test_transaction;
    } else {
      return Live_transaction;
    }
  }

  static String get sadadPayResendOTP {
    if (isDebug) {
      return test_resendOtp;
    } else {
      return Live_resendOtp;
    }
  }
  static String get sadadPayVerifyOTP {
    if (isDebug) {
      return test_verifyOtp;
    } else {
      return Live_verifyOtp;
    }
  }
  static String get googlePayWebRequest {
    if (isDebug) {
      return test_googlePayWebView;
    } else {
      return Live_googlePayWebView;
    }
  }

// ////////////////////////////////////////
// ////////////////////////////////////////
// //// Production Server API/////////////////
// ////////////////////////////////////////
// ////==================== Production Server URL ================================
// static const Live_CreditCardSettings = "https://mapi.sadadqa.com/sdk-api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
// static const Live_CheckCountry = "https://mapi.sadadqa.com/sdk-api/usermetapreferences/checkAllowedCountry";
// static const Live_usermeta = "https://mapi.sadadqa.com/sdk-api/usermetapreferences?filter[include]=user";
// static const Live_TransectionURL = "https://mapi.sadadqa.com/sdk-api/transactions/genchecksum";
// static const Live_generateTransaction = "https://mapi.sadadqa.com/sdk-api/transactions";
// static const Live_amex_creditCardURL = "http://invoice-py.sadadqa.com/amexpayment";
// static const Live_mpgs_pay_creditCardURL = "http://invoice-py.sadadqa.com/crditcardSDK";
// static const Live_debitCardURL = "http://invoice-py.sadadqa.com/debitcardSDK";
// static const Live_SDKLoginURL = "https://mapi.sadadqa.com/sdk-api/users/login";
// static const Live_applepay_URL = "http://invoice-py.sadadqa.com/applepaySDK";
// static const Live_googlePayWebView = "http://invoice-py.sadadqa.com/googlepaySDK";
// static const Live_validate_accesstoken = "https://mapi.sadadqa.com/sdk-api/Usermetapreferences/validatetokenaccess";
// static const Live_transaction = "https://mapi.sadadqa.com/sdk-api/transactions";
// static const Live_resendOtp = "https://mapi.sadadqa.com/sdk-api/usermetaauths/resendOtp?type=login";
// static const Live_verifyOtp = "https://mapi.sadadqa.com/sdk-api/usermetaauths/verify";
//
// ////=========== Preprod Sandbox Server URL =================================
// static const test_CreditCardSettings = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
// static const test_CheckCountry = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetapreferences/checkAllowedCountry";
// static const test_usermeta = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetapreferences?filter[include]=user";
// static const test_TransectionURL = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions/genchecksum";
// static const test_generateTransaction = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions";
// static const test_amex_creditCardURL = "https://aks-invoice.sadadqa.com/amexpayment";
// static const test_mpgs_pay_creditCardURL = "https://aks-invoice.sadadqa.com/crditcardSDK";
// static const test_debitCardURL = "https://aks-invoice.sadadqa.com/debitcardSDK";
// static const test_SDKLoginURL = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/users/login";
// static const test_applepay_URL = "https://aks-invoice.sadadqa.com/applepaySDK";
// static const test_googlePayWebView = "https://aks-invoice.sadadqa.com/googlepaySDK";
// static const test_validate_accesstoken = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/Usermetapreferences/validatetokenaccess";
// static const test_transaction = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions";
// static const test_resendOtp = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetaauths/resendOtp?type=login";
// static const test_verifyOtp = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetaauths/verify";


  // ////////////////////////////////////////
  // ////////////////////////////////////////
  // //// Pre-prod Server API////////////////
  // ////////////////////////////////////////
  ////==================== Preprod Server URL ================================
  static const Live_CreditCardSettings = "https://aks-mapi.sadadqa.com/sdk-api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
  static const Live_CheckCountry = "https://aks-mapi.sadadqa.com/sdk-api/usermetapreferences/checkAllowedCountry";
  static const Live_usermeta = "https://aks-mapi.sadadqa.com/sdk-api/usermetapreferences?filter[include]=user";
  static const Live_TransectionURL = "https://aks-mapi.sadadqa.com/sdk-api/transactions/genchecksum";
  static const Live_generateTransaction = "https://aks-mapi.sadadqa.com/sdk-api/transactions";
  static const Live_amex_creditCardURL = "https://aks-invoice.sadadqa.com/amexpayment";
  static const Live_mpgs_pay_creditCardURL = "https://aks-invoice.sadadqa.com/crditcardSDK";
  static const Live_debitCardURL = "https://aks-invoice.sadadqa.com/debitcardSDK";
  static const Live_SDKLoginURL = "https://aks-mapi.sadadqa.com/sdk-api/users/login";
  static const Live_applepay_URL = "https://aks-invoice.sadadqa.com/applepaySDK";
  static const Live_googlePayWebView = "https://aks-invoice.sadadqa.com/googlepaySDK";
  static const Live_validate_accesstoken = "https://aks-mapi.sadadqa.com/sdk-api/Usermetapreferences/validatetokenaccess";
  static const Live_transaction = "https://aks-mapi.sadadqa.com/sdk-api/transactions";
  static const Live_resendOtp = "https://aks-mapi.sadadqa.com/sdk-api/usermetaauths/resendOtp?type=login";
  static const Live_verifyOtp = "https://aks-mapi.sadadqa.com/sdk-api/usermetaauths/verify";

  ////=========== Preprod Sandbox Server URL =================================
  static const test_CreditCardSettings = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
  static const test_CheckCountry = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetapreferences/checkAllowedCountry";
  static const test_usermeta = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetapreferences?filter[include]=user";
  static const test_TransectionURL = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions/genchecksum";
  static const test_generateTransaction = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions";
  static const test_amex_creditCardURL = "https://aks-invoice.sadadqa.com/amexpayment";
  static const test_mpgs_pay_creditCardURL = "https://aks-invoice.sadadqa.com/crditcardSDK";
  static const test_debitCardURL = "https://aks-invoice.sadadqa.com/debitcardSDK";
  static const test_SDKLoginURL = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/users/login";
  static const test_applepay_URL = "https://aks-invoice.sadadqa.com/applepaySDK";
  static const test_googlePayWebView = "https://aks-invoice.sadadqa.com/googlepaySDK";
  static const test_validate_accesstoken = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/Usermetapreferences/validatetokenaccess";
  static const test_transaction = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions";
  static const test_resendOtp = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetaauths/resendOtp?type=login";
  static const test_verifyOtp = "https://aks-mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetaauths/verify";


  // //////////////////////////////////////
  // //////////////////////////////////////
  // //Dev Server API/////////////////
  // //////////////////////////////////////
  // //==================== Dev Server Live URL ================================
  // static const Live_CreditCardSettings =
  //     "http://176.58.99.102:3003/sdk-api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
  // static const Live_CheckCountry = "http://176.58.99.102:3003/sdk-api/usermetapreferences/checkAllowedCountry";
  // static const Live_usermeta = "http://176.58.99.102:3003/sdk-api/usermetapreferences";
  // static const Live_TransectionURL = "http://176.58.99.102:3003/sdk-api/transactions/genchecksum";
  // static const Live_generateTransaction = "http://176.58.99.102:3003/sdk-api/transactions";
  // static const Live_amex_creditCardURL = "https://sadad.de/sadadinvoice/amexpayment";
  // static const Live_mpgs_pay_creditCardURL = "https://sadad.de/sadadinvoice/crditcardSDK"; //
  // static const Live_debitCardURL = "https://sadad.de/sadadinvoice/debitcardSDK";
  // static const Live_applepay_URL = "https://sadad.de/sadadinvoice/applepaySDK";
  // static const Live_SDKLoginURL = "http://176.58.99.102:3003/sdk-api/users/login";
  // static const Live_verifyOtp = "http://176.58.99.102:3003/sdk-api/usermetaauths/verify";
  // static const Live_resendOtp = "http://176.58.99.102:3003/sdk-api/usermetaauths/resendOtp?type=login";
  // static const Live_transaction = "http://sadad.de:3003/sdk-api/transactions";
  // static const Live_validate_accesstoken = "http://176.58.99.102:3003/sdk-api/Usermetapreferences/validatetokenaccess";
  // static const Live_googlePayWebView = "https://sadad.de/sadadinvoice/googlepaySDK";
  //
  // //////Dev Server SandBoxAPI/////////////////
  // static const test_CreditCardSettings =
  //     "http://176.58.99.102:3002/sdk-sandbox_api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
  // static const test_CheckCountry = "http://176.58.99.102:3002/sdk-sandbox_api/usermetapreferences/checkAllowedCountry";
  // static const test_usermeta = "http://176.58.99.102:3002/sdk-sandbox_api/usermetapreferences";
  // static const test_TransectionURL = "http://176.58.99.102:3002/sdk-sandbox_api/transactions/genchecksum";
  // static const test_generateTransaction = "http://176.58.99.102:3002/sdk-sandbox_api/transactions";
  // static const test_amex_creditCardURL = "https://sadad.de/sadadinvoice/amexpayment";
  // static const test_mpgs_pay_creditCardURL = "https://sadad.de/sadadinvoice/crditcardSDK"; //
  // static const test_debitCardURL = "https://sadad.de/sadadinvoice/debitcardSDK";
  // static const test_applepay_URL = "https://sadad.de/sadadinvoice/applepaySDK";
  // static const test_SDKLoginURL = "http://176.58.99.102:3002/sdk-sandbox_api/users/login";
  // static const test_verifyOtp = "http://176.58.99.102:3002/sdk-sandbox_api/usermetaauths/verify";
  // static const test_resendOtp = "http://176.58.99.102:3002/sdk-sandbox_api/usermetaauths/resendOtp?type=login";
  // static const test_transaction = "http://sadad.de:3002/sdk-sandbox_api/transactions";
  // static const test_validate_accesstoken = "http://176.58.99.102:3002/sdk-sandbox_api/Usermetapreferences/validatetokenaccess";
  // static const test_googlePayWebView = "https://sadad.de/sadadinvoice/googlepaySDK";




  /////////// Python API ///////////
  static const settingAPI = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/settings";
  static const creditCardPayment = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/creditcard";
  static const applePay = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/applepay";
  static const googlePay = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/googlepay";
  static const sadadPayLogin = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/login";
  static const sadadPayTransationV6 = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/transaction";
  static const sadadPayResendOTPV6 = "https://aks-apiv6.sadadqatar.com/api-v6/SDKPayment/resendotp";



  // // ////////////////////////////////////////
  // // ////////////////////////////////////////
  // // //// Production Server API////////////////
  // // ////////////////////////////////////////
  // ////==================== Production Server URL ================================
  // static const Live_CreditCardSettings = "https://mapi.sadadqa.com/sdk-api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
  // static const Live_CheckCountry = "https://mapi.sadadqa.com/sdk-api/usermetapreferences/checkAllowedCountry";
  // static const Live_usermeta = "https://mapi.sadadqa.com/sdk-api/usermetapreferences?filter[include]=user";
  // static const Live_TransectionURL = "https://mapi.sadadqa.com/sdk-api/transactions/genchecksum";
  // static const Live_generateTransaction = "https://mapi.sadadqa.com/sdk-api/transactions";
  // static const Live_amex_creditCardURL = "https://sadadqa.com/amexpayment";
  // static const Live_mpgs_pay_creditCardURL = "https://sadadqa.com/crditcardSDK";
  // static const Live_debitCardURL = "https://sadadqa.com/debitcardSDK";
  // static const Live_SDKLoginURL = "https://mapi.sadadqa.com/sdk-api/users/login";
  // static const Live_applepay_URL = "https://sadadqa.com/applepaySDK";
  // static const Live_googlePayWebView = "https://sadadqa.com/googlepaySDK";
  // static const Live_validate_accesstoken = "https://mapi.sadadqa.com/sdk-api/Usermetapreferences/validatetokenaccess";
  // static const Live_transaction = "https://mapi.sadadqa.com/sdk-api/transactions";
  // static const Live_resendOtp = "https://mapi.sadadqa.com/sdk-api/usermetaauths/resendOtp?type=login";
  // static const Live_verifyOtp = "https://mapi.sadadqa.com/sdk-api/usermetaauths/verify";
  //
  // ////=========== Production Sandbox Server URL =================================
  // static const test_CreditCardSettings = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/settings?filter[where][or][0][key]=ENABLE_CREDIT_CARD&filter[where][or][1][key]=ENABLE_DEBIT_CARD&filter[where][or][2][key]=credit_card_bankpage_type&filter[where][or][3][key]=is_apple_pay_payment&filter[where][or][4][key]=is_google_pay_payment&filter[where][or][5][key]=is_american_express&filter[where][or][6][key]=is_cybersourse_visa&filter[where][or][7][key]=is_cybersourse_mastercard&filter[where][or][8][key]=sdk_min_amount";
  // static const test_CheckCountry = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetapreferences/checkAllowedCountry";
  // static const test_usermeta = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetapreferences?filter[include]=user";
  // static const test_TransectionURL = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions/genchecksum";
  // static const test_generateTransaction = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions";
  // static const test_amex_creditCardURL = "https://sadadqa.com/amexpayment";
  // static const test_mpgs_pay_creditCardURL = "https://sadadqa.com/crditcardSDK";
  // static const test_debitCardURL = "https://sadadqa.com/debitcardSDK";
  // static const test_SDKLoginURL = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/users/login";
  // static const test_applepay_URL = "https://sadadqa.com/applepaySDK";
  // static const test_googlePayWebView = "https://sadadqa.com/googlepaySDK";
  // static const test_validate_accesstoken = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/Usermetapreferences/validatetokenaccess";
  // static const test_transaction = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/transactions";
  // static const test_resendOtp = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetaauths/resendOtp?type=login";
  // static const test_verifyOtp = "https://mapi-sandbox.sadadqa.com/sdk-sandbox_api/usermetaauths/verify";
}
