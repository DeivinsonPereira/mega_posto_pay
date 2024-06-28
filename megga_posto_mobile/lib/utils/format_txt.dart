// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/services.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';

//transforma os textos em minusculo
class LowerCaseTxt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue txtOld, TextEditingValue txtNew) {
    return txtNew.copyWith(text: txtNew.text.toLowerCase());
  }
}

//transforma os textos em maiusculo
class UpperCaseTxt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue txtOld, TextEditingValue txtNew) {
    return txtNew.copyWith(text: txtNew.text.toUpperCase());
  }
}

class NumberBrl extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: 'R\$ 0,00');
    }

    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    double value = double.parse(newText) / 100;

    String formatted = FormatNumbers.formatNumbertoString(value);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
