import 'package:flutter/material.dart';
import 'package:sadad_qa_payments/apputils/appcolors.dart';
import 'package:sadad_qa_payments/apputils/appstrings.dart';

class AppDialog {
  static showProcess(BuildContext context, Color progressColor) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: AppColors.transparent,
          child: WillPopScope(
            child: Center(
                child: CircularProgressIndicator(
              color: progressColor,
            )),
            onWillPop: () => Future.value(false),
          ),
        );
      },
    );
  }

  static commonWarningDialog(
      {required final BuildContext context,
      required String title,
      required String subTitle,
      required String buttonText,
      required Color themeColor,
      required Function() buttonOnTap,
      required bool useMobileLayout}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Dialog(
            backgroundColor: AppColors.transparent,
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(fontSize: useMobileLayout ? 20 : 24, fontFamily: AppConstant.robotoText),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subTitle,
                      style: const TextStyle(fontSize: 15, fontFamily: AppConstant.robotoText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: buttonOnTap,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration:
                            BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          buttonText,
                          style: const TextStyle(color: AppColors.white, fontSize: 16),
                        )),
                      ),
                    ),
                    const SizedBox(height: 8)
                  ],
                )),
          ),
        );
      },
    );
  }

  static commonWarningDialogWithTwoButton(
      {required final BuildContext context,
      required String title,
      required String subTitle,
      required String positiveButtonText,
      required String negativeButtonText,
      required Color themeColor,
      required Function() positiveButtonOnTap,
      required Function() negativeButtonOnTap,
      required bool useMobileLayout}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
            backgroundColor: AppColors.transparent,
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: useMobileLayout ? 18 : 22,
                        fontFamily: AppConstant.robotoText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subTitle,
                      style: const TextStyle(fontSize: 15, fontFamily: AppConstant.robotoText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: positiveButtonOnTap,
                          child: Container(
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                                color: AppColors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              positiveButtonText,
                              style: const TextStyle(color: AppColors.black, fontSize: 16),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: negativeButtonOnTap,
                          child: Container(
                            height: 40,
                            width: 110,
                            decoration:
                                BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              negativeButtonText,
                              style: const TextStyle(color: AppColors.white, fontSize: 16),
                            )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8)
                  ],
                )),
          ),
        );
      },
    );
  }
}
