import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megga_posto_mobile/page/payment/enum/modalidade_payment.dart';
import 'package:megga_posto_mobile/utils/static/custom_colors.dart';

class CustomIconPayment {
  CustomIconPayment._privateConstructor();

  static final CustomIconPayment instance =
      CustomIconPayment._privateConstructor();

  Icon buildIcon(String paymentFormSelected) {
    switch (paymentFormSelected) {
      case ModalidadePaymentForm.NOTA:
        return _buildIcon(Icons.receipt_long, CustomColors.containerQuantity);

      case ModalidadePaymentForm.DINHEIRO:
        return _buildIcon(
            FontAwesomeIcons.moneyBill1Wave, CustomColors.confirmButton);

      case ModalidadePaymentForm.CREDITO:
        return _buildIcon(FontAwesomeIcons.creditCard, CustomColors.backButton);

      case ModalidadePaymentForm.DEBITO:
        return _buildIcon(
            FontAwesomeIcons.solidCreditCard, CustomColors.primaryColor);

      case ModalidadePaymentForm.PIX:
        return _buildIcon(Icons.pix, CustomColors.elevatedButtonPrimary);

      default:
        return _buildIcon(Icons.monetization_on, CustomColors.confirmButton);
    }
  }

  Icon _buildIcon(IconData icon, Color color) {
    return Icon(
      icon,
      color: color,
    );
  }
}
