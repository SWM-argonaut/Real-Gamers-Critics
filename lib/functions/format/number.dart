import 'package:intl/intl.dart';

formatedNumber(int n) {
  return NumberFormat('###,###,###,###')
      .format(n)
      .replaceAll(' ', '')
      .toString();
}
