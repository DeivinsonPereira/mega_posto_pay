// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/page/management/dialogs/components/custom_buttons_dialog.dart';
import 'package:megga_posto_mobile/page/management/dialogs/components/header_dialogs.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

class ReportDialog extends StatelessWidget {
  final String textHeader;
  final Function() function;
  const ReportDialog({
    Key? key,
    required this.textHeader,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _customButtons = CustomButtonsDialog.instance;

    Widget _buildHeader() {
      return HeaderDialogs(title: textHeader);
    }

    Widget _buildContent() {
      return const SizedBox(child: Center(child: Text('Imagem do pdf')));
    }

    Widget _buildButtonBack() {
      return _customButtons.buildButton(
          'VOLTAR', CustomColors.backButton, () => Get.back());
    }

    Widget _buildContinue() {
      return _customButtons.buildButton(
          'IMPRIMIR', CustomColors.confirmButton, () => function());
    }

    Widget _buildLineButtons() {
      return Row(
        children: [
          Expanded(child: _buildButtonBack()),
          Expanded(child: _buildContinue()),
        ],
      );
    }

    Widget _buildBody() {
      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildLineButtons(),
        ],
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SizedBox(
        height: Get.size.height * 0.8,
        width: Get.size.width * 0.9,
        child: _buildBody(),
      ),
    );
  }
}
