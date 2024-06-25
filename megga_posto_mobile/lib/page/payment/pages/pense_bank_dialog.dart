// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:megga_posto_mobile/common/custom_text_style.dart';
import 'package:megga_posto_mobile/service/print/execute_print.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../common/custom_elevated_button.dart';
import '../../../common/custom_header_dialog.dart';
import '../../../utils/method_quantity_back.dart';
import '../../../utils/methods/payment/payment_features.dart';
import '../../../utils/static/custom_colors.dart';

class PenseBankDialog extends StatelessWidget {
  final String textPix;
  const PenseBankDialog({
    Key? key,
    required this.textPix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _paymentFeatures = PaymentFeatures();
    double sizeTextButtom = Get.size.height * 0.03;

    //  _pixPdv.isolateMonitoring(context, qrdinamico, sdk);

    //Constrói a imagem do QrCode
    Widget _buildImageQrCode() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: QrImageView(
                data: textPix,
                version: QrVersions.auto,
                size: Get.size.height * 0.35)),
      );
    }

    // Constrói o cabecalho
    Widget _buildHeader() {
      return const CustomHeaderDialog(
        text: 'PIX',
      );
    }

    // Constrói o botão de voltar
    Widget _buildButonBack() {
      return SizedBox(
        height: 40,
        child: CustomElevatedButton(
            text: 'Voltar',
            textStyle: CustomTextStyles.whiteBoldStyle(sizeTextButtom),
            function: () {
              _paymentFeatures.clearEnteredValue();
              //      isolatePixPdvManager.kill();
              QuantityBack.back(2);
            },
            radious: 0,
            colorButton: CustomColors.elevatedButtonSecondary),
      );
    }

    // Constrói o botão de imprimir
    Widget _buildButonPrint() {
      return SizedBox(
        height: 40,
        child: CustomElevatedButton(
            text: 'Imprimir',
            textStyle: CustomTextStyles.whiteBoldStyle(sizeTextButtom),
            function: () async => await ExecutePrint.instance
                .printQrCodeAndText(textPix, DateTime.now(), context),
            radious: 0,
            colorButton: CustomColors.confirmButton),
      );
    }

    // Constrói o botão de voltar e imprimir
    Widget _buildButonBackAndPrint() {
      return Row(children: [
        Expanded(
          child: _buildButonBack(),
        ),
        Expanded(
          child: _buildButonPrint(),
        )
      ]);
    }

    // Constrói o conteudo do dialog
    Widget _buildContent() {
      return SizedBox(
        height: Get.size.height * 0.5,
        width: Get.size.width * 0.5,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildImageQrCode()),
            _buildButonBackAndPrint(),
          ],
        ),
      );
    }

    // retorna o dialog do pix
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        ),
      ),
      child: _buildContent(),
    );
  }
}
