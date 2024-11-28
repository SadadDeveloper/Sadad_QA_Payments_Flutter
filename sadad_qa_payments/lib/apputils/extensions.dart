import 'package:sadad_qa_payments/assets/locale/arabic.dart';
import 'package:sadad_qa_payments/assets/locale/english.dart';
import 'package:sadad_qa_payments/sadad_qa_payments.dart';

extension Translate on String {
  translate() {
    if (selectedLanguage.languageCode == "en") {
      return en[this];
    } else {
      return ar[this];
    }
  }
}
