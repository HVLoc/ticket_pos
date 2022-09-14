import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/services.dart';

String formatNameCompany(String nameCompany) {
  AppStr.mapTitle.forEach((key, value) {
    if (nameCompany.toUpperCase().contains(key)) {
      nameCompany = nameCompany.replaceAll(RegExp(key), value);
    }
  });
  return nameCompany;
}

String formatInvoiceNo(num number) {
  String invoiceNo = number.toInt().toString();

  if (invoiceNo.isEmpty) {
    return '';
  }
  final int count = 7 - invoiceNo.length;

  for (int index = 0; index < count; index++) {
    invoiceNo = '0' + invoiceNo;
  }
  return invoiceNo;
}

class TaxCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 11) {
      String newString;
      if (newValue.text.endsWith('-')) {
        newString = newValue.text;
      } else {
        newString = newValue.text.substring(0, 10) +
            '-' +
            newValue.text.substring(10, 11);
      }

      if (oldValue.text.length == 12) {
        newString = newString.substring(0, 10);
      }
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length),
      );
    }
    if (newValue.text.endsWith('-') && newValue.text.length != 11) {
      return oldValue;
    }
    return newValue;
  }
}

String twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

String formatBySeconds(Duration duration) =>
    twoDigits(duration.inSeconds.remainder(60));

String formatByMinutes(Duration duration) {
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return '$twoDigitMinutes:${formatBySeconds(duration)}';
}

String formatByHours(Duration duration) {
  return '${twoDigits(duration.inHours)}:${formatByMinutes(duration)}';
}

String formatMessError(dynamic mess) {
  try {
    return mess.values.first;
  } catch (e) {
    return AppStr.errorInternalServer;
  }
}
