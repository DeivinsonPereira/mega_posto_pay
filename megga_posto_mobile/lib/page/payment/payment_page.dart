// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_continue_button.dart';
import 'package:megga_posto_mobile/common/custom_header_app_bar.dart';
import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/controller/payment_controller.dart';
import 'package:megga_posto_mobile/model/payment_executed_model.dart';
import 'package:megga_posto_mobile/page/payment/components/custom_icon_payment.dart';
import 'package:megga_posto_mobile/page/payment/components/dialogs/dialog_choose_payment.dart';
import 'package:megga_posto_mobile/page/payment/enum/payment_type.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_get.dart';

import '../../common/custom_back_button.dart';
import '../../common/container_total/custom_container_total.dart';
import 'logic/logic_back_buttom.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    Dependencies.paymentController();
    final _paymentGet = PaymentGet();
    final _paymentType = PaymentType.instance;
    final _customIconPayment = CustomIconPayment.instance;

    // Constrói o título da página
    Widget _buildTitle() {
      return Text(
        'PAGAMENTO',
        style: CustomTextStyles.blackBoldStyle(40),
      );
    }

    Widget _buildRemainingValue() {
      return Obx(() => Text(
            'Restante R\$ ${FormatNumbers.formatNumbertoString(_paymentGet.getRemainingValue())}',
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

    Widget _buildPaymentName(String name) {
      return Text(
        name,
        style: CustomTextStyles.blackStyle(18),
      );
    }

    Widget _buildPaymentValue(PaymentExecuted paymentExecutedSelected) {
      return Text(
        'R\$ ${FormatNumbers.formatNumbertoString(paymentExecutedSelected.valorIntegral)}',
        style: CustomTextStyles.blackStyle(18),
      );
    }

    Widget _buildLinePayment(
        String name, PaymentExecuted paymentExecutedSelected) {
      return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Row(
            children: [
              _customIconPayment.buildIcon(name),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPaymentName(name),
                    _buildPaymentValue(paymentExecutedSelected),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildListPaymentExecuted() {
      return GetBuilder<PaymentController>(builder: (_) {
        return ListView.builder(
            itemCount: _.listPaymentsSelected.length,
            itemBuilder: (context, index) {
              PaymentExecuted paymentExecutedSelected =
                  _.listPaymentsSelected[index];
              String namePayment = _paymentType
                  .doctoToPaymentType(paymentExecutedSelected.tipoDocto ?? '');
              return _buildLinePayment(namePayment, paymentExecutedSelected);
            });
      });
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
            SizedBox(height: Get.size.height * 0.03),
            Expanded(
              child: _buildListPaymentExecuted(),
            ),
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
