// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters, must_be_immutable
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_get.dart';

import '../../controller/payment_controller.dart';
import '../../utils/dependencies.dart';
import '../custom_text_style.dart';

class CustomContainerTotal extends StatelessWidget {
  const CustomContainerTotal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dependencies.paymentController();
    final _billGet = BillGet();
    double widthTotal = Get.size.width;

    // Constrói o texto total
    Widget _buildTextTotal() {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          'TOTAL',
          style: CustomTextStyles.blackBoldStyle(25),
        ),
      );
    }

    // Constrói o valor total
    Widget _buildValueTotal(PaymentController _) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Obx(() => Text(
              FormatNumbers.formatNumbertoString(
                _billGet.getTotalToPay(),
              ),
              style: CustomTextStyles.blackBoldStyle(24),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
      );
    }

    Widget _buildInformations(double width, String text, Widget textValue) {
      return SizedBox(
        width: width,
        height: Get.size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: CustomTextStyles.blackStyle(12),
            ),
            textValue,
          ],
        ),
      );
    }

    Widget _buildSubtotal() {
      return _buildInformations(
          widthTotal * 0.3,
          'Subtotal',
          Obx(() => Text(
                FormatNumbers.formatNumbertoString(
                    _billGet.getTotalValueFromCart()),
                style: CustomTextStyles.blackStyle(12),
              )));
    }

    Widget _buildDiscount() {
      return Expanded(
          child: _buildInformations(
              widthTotal * 0.25,
              'Desconto',
              Text(
                FormatNumbers.formatNumbertoString(0),
                style: CustomTextStyles.blackStyle(12),
              )));
    }

    Widget _buildExtra() {
      return _buildInformations(
          widthTotal * 0.3,
          'Acréscimo',
          Text(
            FormatNumbers.formatNumbertoString(0),
            style: CustomTextStyles.blackStyle(12),
          ));
    }

    // Constrói a linha de conteúdo
    Widget _buildLineContent(PaymentController _) {
      return Column(
        children: [
          Row(
            children: [
              _buildSubtotal(),
              const Text(' | '),
              _buildDiscount(),
              const Text(' | '),
              _buildExtra(),
            ],
          ),
          Expanded(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextTotal(),
                  _buildValueTotal(_),
                ]),
          ),
        ],
      );
    }

    // Constrói o texto total
    Widget _buildLineTextTotal(PaymentController _) {
      return SizedBox(
        width: Get.size.width,
        child: _buildLineContent(_),
      );
    }

    // Constrói o corpo
    Widget _buildBody(PaymentController _) {
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildLineTextTotal(_),
            ),
          ),
        ],
      );
    }

    // Constrói o container total
    return GetBuilder<PaymentController>(
      builder: (_) {
        return Container(
          width: Get.size.width,
          height: Get.size.height * 0.15,
          decoration: BoxDecoration(
              color: Colors.white, border: Border.all(color: Colors.black)),
          child: _buildBody(_),
        );
      },
    );
  }
}
