import 'package:intl/intl.dart';

extension NumExtension on num? {
  String toCurrency({String locale = 'vi_VN', String symbol = '₫'}) {
    if (this == null) {
      return "";
    }
    final format = NumberFormat.currency(locale: locale, symbol: symbol);
    return format.format(this);
  }

  String toRoundedString({int decimalPlaces = 1}) {
    if (this == null) {
      return "";
    }
    return this!.toStringAsFixed(decimalPlaces);
  }

  
}
