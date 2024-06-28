// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/common/custom_text_style.dart';

class HeaderDialogs extends StatelessWidget {
  final String title;
  const HeaderDialogs({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.size.height * 0.07,
      color: const Color.fromARGB(255, 9, 78, 112),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: CustomTextStyles.whiteBoldStyle(18)),
        ],
      ),
    );
  }
}
