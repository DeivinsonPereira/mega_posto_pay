// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

import '../../components/custom_buttons_dialog.dart';

class CustomLineButtonsManagement extends StatelessWidget {
  final Function() function;
  const CustomLineButtonsManagement({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customButtons = CustomButtonsDialog.instance;

    Widget _buildButtonBack() {
      return _customButtons.buildButton(
          'VOLTAR', CustomColors.backButton, () => Get.back());
    }

    Widget _buildContinue() {
      return _customButtons.buildButton(
          'IMPRIMIR', CustomColors.confirmButton, () => function());
    }

    return Row(
      children: [
        Expanded(child: _buildButtonBack()),
        Expanded(child: _buildContinue()),
      ],
    );
  }
}
