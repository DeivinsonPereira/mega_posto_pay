import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_back_button.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/common/custom_header_dialog.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/page/payment/components/page/signatures/logic/logic_pre_camera_buttons.dart';

class PreCameraDialog extends StatelessWidget {
  const PreCameraDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildHeader() {
      return const CustomHeaderDialog(text: 'Tirar foto');
    }

    Widget _buildContent() {
      return Center(
        child: Text(
          'Tirar foto do cliente?',
          style: CustomTextStyles.blackBoldStyle(18),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget _buildBackButton() {
      return CustomBackButton(
          text: 'Não', function: () => LogicPreCameraButtons().backButton());
    }

    Widget _buildContinueButton() {
      return CustomContinueButton(
          text: 'Sim',
          function: () => LogicPreCameraButtons().continueButton());
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
          Expanded(child: _buildContent()),
          _buildLineButtons(),
        ],
      );
    }

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SizedBox(
        height: Get.size.height * 0.4,
        width: Get.size.width,
        child: _buildBody(),
      ),
    );
  }
}
