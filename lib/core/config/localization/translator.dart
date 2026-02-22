import 'localization_data.dart';
import 'language_bloc.dart';

class Translator {
  static String translate(String key, AppLanguage language) {
    if (language == AppLanguage.urdu) {
      return LocalizationData.urdu[key] ?? key;
    }
    return LocalizationData.english[key] ?? key;
  }
}

extension TranslationExtension on String {
  String tr(AppLanguage language) => Translator.translate(this, language);
}
