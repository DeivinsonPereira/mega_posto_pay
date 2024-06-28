import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';

import '../../../../common/custom_elevated_button.dart';

class CustomButtonsDialog {
  CustomButtonsDialog._privateConstructor();

  static final CustomButtonsDialog instance =
      CustomButtonsDialog._privateConstructor();

  Widget buildButton(String text, Color colorButton, Function() function) {
    return SizedBox(
      height: 50,
      child: CustomElevatedButton(
        colorButton: colorButton,
        radious: 0,
        text: text,
        textStyle: CustomTextStyles.whiteBoldStyle(20),
        function: function,
      ),
    );
  }
}
