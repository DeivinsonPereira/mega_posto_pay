import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_back_button.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/common/custom_header_dialog.dart';
import 'package:megga_posto_mobile/page/payment/components/page/signatures/logic/confirm_button_signature.dart';
import 'package:signature/signature.dart';

class SignaturePage extends StatelessWidget {
  const SignaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _logicButtons = LogicButtonSignature.instance;
    final SignatureController _signatureController = SignatureController(
      penStrokeWidth: 4,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );
    

    Widget _buildHeader() {
      return const CustomHeaderDialog(text: 'Assinatura');
    }

    Widget _buildCampAssignature() {
      return Signature(
        controller: _signatureController,
        backgroundColor: Colors.transparent,
        width: Get.size.width,
      );
    }

    Widget _buildBackButton() {
      return CustomBackButton(
          text: 'Voltar',
          function: () => _logicButtons.backButton());
    }

    Widget _buildContinueButton() {
      return CustomContinueButton(
          text: 'Confirmar',
          function: () async => _logicButtons.continueButton(context, _signatureController));
    }

    Widget _buildLineButtons() {
      return Row(
        children: [
          Expanded(child: _buildBackButton()),
          Expanded(child: _buildContinueButton()),
        ],
      );
    }

    Widget _buildBody() {
      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildCampAssignature()),
          _buildLineButtons(),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }
}
