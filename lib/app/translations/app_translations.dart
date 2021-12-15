import 'en_translations.dart';
import 'vi_translations.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> 
  translations = 
{
    'en' : en,
    'vi' : vi
};
}