import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/methods/bill/bill_get.dart';
import 'package:megga_posto_mobile/utils/methods/payment/payment_features.dart';
import 'package:pixpdv_sdk/pixpdv_sdk.dart';

import '../../../../model/credential_pix_model.dart';
import '../../../../page/payment/pages/pix_pdv_payment/pix_pdv_payment_dialog.dart';
import '../../../../utils/singletons_instances.dart';

class PaymentPixPdv {
  final _configController = Dependencies.configController();
  final _billGet = BillGet();
  final _logger = SingletonsInstances().logger;
  final _dio = SingletonsInstances().dio;
  final _paymentFeatures = PaymentFeatures();
  late final PixPdvSdk _instancePix;

  PaymentPixPdv._();

  static Future<PaymentPixPdv> create() async {
    var paymentPixPdv = PaymentPixPdv._();
    await paymentPixPdv._initializePixSdk();
    return paymentPixPdv;
  }

  // Inicializa a variável _instancePix
  Future<void> _initializePixSdk() async {
    PixPdvSdk? configPixPdv = await _configurePix();
    if (configPixPdv == null) return;
    _instancePix = configPixPdv;
  }

  // retorna o pagamento pixPdv
  Future<void> payment() async {
    try {
      StatusTokenResult? resultStatus = await _getStatus(_instancePix);

      if (resultStatus != null) {
        _logger.d('Configurações de pix estão corretas.');
        QrDinamicoResult? result = await _qrCodePix(_instancePix);

        if (result != null) {
          //  await InsertDataPix().insert(result);
          _logger.d('QrCode gerado com sucesso.');

          Get.back();

          var imageBytes =
              base64Decode(result.qrDinamicoResultData!.qrcodeBase64!);

          await Get.dialog(
            barrierDismissible: false,
            PixPdvPaymentDialog(
              sdk: _instancePix,
              qrdinamico: result,
              imageQrCodeBase64: imageBytes,
              textPix: result.qrDinamicoResultData!.qrcode!,
            ),
          );
        } else {
          _logger.e('Erro ao gerar o QrCode.');
        }
      } else {
        _logger.e('Configurações de pix estão incorretas.');
      }
    } catch (e) {
      _logger.e('Erro ao executar a verificação de status: $e');
    }
  }

  // Configura o pix e retorna um objeto do tipo PixPdvSdk
  Future<PixPdvSdk?> _configurePix() async {
    _logger.i('Configurando o pix...');

    try {
      CredentialPix? credentials = _configController.dataPos.credenciaisPix?[0];

      if (credentials == null) {
        _handleError();
        return null;
      }

      PixPDVTokenModel token = PixPDVTokenModel(
        enviroment: PixPDVEnviroment
            .homologacao, // aqui devo mudar para o de produção quando for para produção
        userName: credentials.clientId,
        password: credentials.token,
        secretKey: credentials.apiKey,
      );

      PixPdvSdk pixPdvSdk = PixPdvSdk(
        dio: _dio,
        token: token,
      );

      return pixPdvSdk;
    } catch (e) {
      _logger.d('Erro ao configurar pix. $e');
      return null;
    }
  }

  // Gera o QrCode dinamico do pix
  Future<QrDinamicoResult?> _qrCodePix(PixPdvSdk sdk) async {
    try {
      QrDinamicoResult qrdinamico = await sdk.qrdinamico(
        bodyData: QrDinamicoData(
          valor: _billGet
              .getTotalValueFromCart(), // TODO : colocar o valor correto
          minutos: 5,
          mensagem: 'Teste de QRCODE Dinamico',
          imagem: true,
        ),
      );
      return qrdinamico;
    } catch (e) {
      _logger.d('Erro ao gerar QRCODE. $e');
      return null;
    }
  }

  // Testa as configurações e valida o token
  Future<StatusTokenResult?> _getStatus(PixPdvSdk sdk) async {
    CredentialPix? cnpj = _configController.dataPos.credenciaisPix?[0];

    if (cnpj == null) return null;

    try {
      StatusTokenResult statustoken =
          await sdk.statustoken(bodyData: StatusTokenData(cnpj: cnpj.clientId));
      return statustoken;
    } catch (e) {
      _logger.d('Erro ao buscar status. $e');
      return StatusTokenResult();
    }
  }

  Future<void> _handleError() async {
    _logger.d('Credenciais de pix não encontradas.');
    Future.delayed(const Duration(seconds: 3), () {
      QuantityBack.back(2);
      _paymentFeatures.clearEnteredValue();
      const CustomCherryError(message: 'Credenciais de pix não encontradas.')
          .show(Get.context!);
    });
  }
}
