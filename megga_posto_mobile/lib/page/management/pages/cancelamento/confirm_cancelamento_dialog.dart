import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_back_button.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/common/custom_header_dialog.dart';
import 'package:megga_posto_mobile/common/custom_text_field_five_lines.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/page/management/pages/cancelamento/logic/logic_cancel_sell.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

class ConfirmCancelamentoDialog extends StatelessWidget {
  const ConfirmCancelamentoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _managementController = Dependencies.managementController();

    Widget _buildHeader() {
      return const CustomHeaderDialog(text: 'Confirmar Cancelamento');
    }

    Widget _buildText() {
      return Center(
        child: Text(
          'Digite o motivo do cancelamento',
          style: CustomTextStyles.blackBoldStyle(18),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget _buildTextField() {
      return CustomTextFieldFiveLines(
        controller: _managementController.motivoController,
        maxLines: 2,
        textHint: 'Digite aqui...',
      );
    }

    Widget _buildContent() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildText(),
            const SizedBox(height: 20),
            _buildTextField(),
          ],
        ),
      );
    }

    Widget _buildButtonBack() {
      return CustomBackButton(
          text: 'Voltar',
          function: () {
            LogicCancelSell().backButton();
          });
    }

    Widget _buildButtonConfirm() {
      return CustomContinueButton(
          text: 'Confirmar',
          function: () {
            LogicCancelSell().sendCancel();
          });
    }

    Widget _buildButtons() {
      return Row(
        children: [
          Expanded(child: _buildButtonBack()),
          Expanded(child: _buildButtonConfirm()),
        ],
      );
    }

    Widget _buildBody() {
      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildButtons(),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 0,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(0),
      child: SizedBox(
        height: Get.size.height * 0.5,
        width: Get.size.width * 0.95,
        child: _buildBody(),
      ),
    );
  }
}
