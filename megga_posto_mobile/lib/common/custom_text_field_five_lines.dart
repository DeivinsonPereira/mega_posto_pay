import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/utils/format_txt.dart';

class CustomTextFieldFiveLines extends StatelessWidget {
  final TextEditingController controller;
  String? textHint;
  int? maxLines;
  CustomTextFieldFiveLines({
    super.key,
    required this.controller,
    this.textHint = '',
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [UpperCaseTxt()],
      keyboardType: TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        hintText: textHint,
      ),
      controller: controller,
    );
  }
}
