import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_back_button.dart';
import 'package:megga_posto_mobile/common/custom_header_dialog.dart';

import '../../../../common/custom_text_style.dart';
import '../../../../utils/dependencies.dart';
import '../custom_card_payment_form.dart';

class DialogChoosePayment extends StatelessWidget {
  const DialogChoosePayment({super.key});

  @override
  Widget build(BuildContext context) {
    final _paymentController = Dependencies.paymentController();

    Widget _buildHeader() {
      return const CustomHeaderDialog(text: 'Formas de pagamento');
    }

    Widget _buildText() {
      return Text(
        'Escolha uma forma de pagamento',
        style: CustomTextStyles.blackBoldStyle(24),
        textAlign: TextAlign.center,
      );
    }

    Widget _buildPaymentForms() {
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1.9,
          ),
          itemCount: _paymentController.paymentFormsDocto.length,
          itemBuilder: (context, index) {
            String paymentFormSelected =
                _paymentController.paymentFormsDocto[index];
            return CustomCardPaymentForm(
              paymentFormSelected: paymentFormSelected,
              index: index,
            );
          });
    }

    Widget _buildBackButton() {
      return Row(children: [
        Expanded(
            child:
                CustomBackButton(text: 'Voltar', function: () => Get.back())),
      ]);
    }

    Widget _buildBody() {
      return Column(
        children: [
          _buildHeader(),
          _buildText(),
          const SizedBox(height: 10),
          Expanded(child: _buildPaymentForms()),
          _buildBackButton(),
        ],
      );
    }

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: SizedBox(
        height: Get.size.height * 0.7,
        width: Get.size.width * 0.9,
        child: _buildBody(),
      ),
    );
  }
}
