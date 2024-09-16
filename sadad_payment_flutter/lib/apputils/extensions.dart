import 'dart:ui';

import 'package:sadad_payment_flutter/assets/locale/arabic.dart';
import 'package:sadad_payment_flutter/assets/locale/english.dart';
import 'package:sadad_payment_flutter/sadad_payment_flutter.dart';

extension Translate on String {
  translate() {
    if (selectedLanguage.languageCode == "en") {
      return en[this];
    } else {
      return ar[this];
    }
  }
}
