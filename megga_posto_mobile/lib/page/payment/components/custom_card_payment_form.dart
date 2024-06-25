// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_get.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../../common/custom_colors_list.dart';
import '../logic/logic_add_payment.dart';

class CustomCardPaymentForm extends StatelessWidget {
  final String paymentFormSelected;
  final int index;
  const CustomCardPaymentForm({
    super.key,
    required this.paymentFormSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final _paymentGet = PaymentGet();
    final _paymentFeatures = PaymentFeatures();
    final _logicWidget = SingletonsInstances().logicWidgets;
    LogicAddPayment _logicAddPayment = LogicAddPayment();

    // Constrói o texto do card
    Widget _buildText() {
      return _logicWidget.buildText(paymentFormSelected);
    }

    // Constrói o icone do card
    Widget _buildIcon() {
      return _logicWidget.buildIcon(paymentFormSelected);
    }

    // Constrói o conteúdo do card
    Widget _buildContent() {
      return SizedBox(
        height: Get.size.height * 0.1,
        child: Column(
          children: [
            Expanded(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buildText(),
                SizedBox(width: Get.size.width * 0.01),
                _buildIcon(),
              ]),
            ),
            Container(
              height: 10,
              width: Get.size.width,
              decoration: BoxDecoration(
                  color: CustomColorsList.colorList[index],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            )
          ],
        ),
      );
    }

    // Constrói o Card
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          if (_paymentGet.isPaymentNotaExists(paymentFormSelected)) {
            const CustomCherryError(
              message: 'Não pode adicionar mais de um pagamento de nota.',
            ).show(context);
            return;
          }
          _paymentFeatures.replaceIsAutoFillToTrue();
          _logicAddPayment.add(paymentFormSelected);
        },
        child: Card(
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: _buildContent()),
      ),
    );
  }
}
