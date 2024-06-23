// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/common/custom_dropbox.dart';
import 'package:megga_posto_mobile/common/custom_text_field_five_lines.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/model/moviment_register_model.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

import '../components/custom_buttons_dialog.dart';
import '../components/header_dialogs.dart';

class CashMovimentDialog extends StatelessWidget {
  final Function() function;
  final String textHeader;
  const CashMovimentDialog({
    Key? key,
    required this.function,
    required this.textHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _managementController = Dependencies.managementController();
    final _managementFeatures = ManagementFeatures.instance;
    final _customButtons = CustomButtonsDialog.instance;

    Widget _buildHeader() {
      return HeaderDialogs(
        title: textHeader,
      );
    }

    Widget _buildTotalValue() {
      return SizedBox(
        height: 60,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Text('SALDO: R\$ 0,00',
                style: CustomTextStyles.blackBoldStyle(24))),
      );
    }

    Widget _buildLegendDocto() {
      return Text('DOCUMENTO', style: CustomTextStyles.blackBoldStyle(16));
    }

    Widget _buildDropboxDocumento() {
      return CustomDropbox<Docto>(
        value: _managementController.docto,
        items: _managementController.listDocto,
        sizeDropbox: Get.size.width * 0.78,
        onChanged: (Docto newValue) =>
            _managementFeatures.updateDocto(newValue),
        displayValue: (Docto newValue) => newValue.descricao,
      );
    }

    Widget _buildLegendHistorico() {
      return Text('HISTÓRICO', style: CustomTextStyles.blackBoldStyle(16));
    }

    Widget _buildTextFieldHistorico() {
      return CustomTextFieldFiveLines(
          controller: _managementController.historicoController,
          maxLines: 5,
          textHint: 'HISTÓRICO');
    }

    Widget _buildContent() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendDocto(),
            _buildDropboxDocumento(),
            const SizedBox(height: 20),
            _buildLegendHistorico(),
            _buildTextFieldHistorico(),
          ],
        ),
      );
    }

    Widget _buildButtonBack() {
      return _customButtons.buildButton(
          'VOLTAR', CustomColors.backButton, () => Get.back());
    }

    Widget _buildContinue() {
      return _customButtons.buildButton(
          'SALVAR', CustomColors.confirmButton, () => function());
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
          _buildTotalValue(),
          Expanded(child: _buildContent()),
          _buildLineButtons(),
        ],
      );
    }

    return SingleChildScrollView(
      child: Dialog(
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
      ),
    );
  }
}
