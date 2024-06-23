// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/common/custom_header_app_bar.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/page/payment/components/dialogs/dialog_choose_payment.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_get.dart';

import '../../common/custom_back_button.dart';
import '../../common/container_total/custom_container_total.dart';
import 'logic/logic_back_buttom.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    var _paymentGet = PaymentGet();

    // Constrói o título da página
    Widget _buildTitle() {
      return Text(
        'PAGAMENTO',
        style: CustomTextStyles.blackBoldStyle(40),
      );
    }

    Widget _buildRemainingValue() {
      return Obx(() => Text(
            'Restante R\$ ${FormatNumbers.formatNumbertoString(_paymentGet.getRemainingValueRestanding())}',
            style: CustomTextStyles.blackBoldStyle(24),
          ));
    }

    Widget _buildBackButton() {
      return CustomBackButton(
        function: () => LogicBackButtom().backButtom(),
        text: 'Voltar',
      );
    }

    Widget _buildContinueButton() {
      return CustomContinueButton(
          text: 'Pagar',
          function: () => Get.dialog(
              barrierDismissible: false, const DialogChoosePayment()));
    }

    // constrói o corpo dos botões de voltar e continuar
    Widget _buildBackAndContinueButtonBody() {
      return Row(children: [
        Expanded(
          child: _buildBackButton(),
        ),
        Expanded(
          child: _buildContinueButton(),
        )
      ]);
    }

    // Constrói o corpo da página
    Widget _buildBody() {
      return SizedBox(
        child: Column(
          children: [
            CustomHeaderAppBar(isPayment: true),
            _buildTitle(),
            _buildRemainingValue(),
            const Expanded(child: SizedBox()),
            const CustomContainerTotal(),
            _buildBackAndContinueButtonBody(),
          ],
        ),
      );
    }

    // Constrói o Scaffold
    return Scaffold(
      body: _buildBody(),
    );
  }
}
