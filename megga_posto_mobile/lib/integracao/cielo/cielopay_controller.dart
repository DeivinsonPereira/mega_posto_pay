import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:megga_posto_mobile/integracao/cielo/model/cielopay_response_success_model.dart';

import 'dart:core';

import 'package:megga_posto_mobile/integracao/padrao/paypadrao_enums.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_retorno_model.dart';

class CieloPayController extends GetxController {
  Function(Uri?, String?)? retornoPagto;

  static const platformMethodChannel = MethodChannel("com.pagamento");
  static const MethodChannel _channel = MethodChannel("DATA_RETURN");

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    if (call.method == 'pgto_return') {
      final map = call.arguments;
      if (retornoPagto != null) {
        retornoPagto!(Uri.tryParse(''), map.toString());
      }
    } else if (call.method == 'cancel_return') {
      final map = call.arguments;
      // ignore: avoid_print
      if (retornoPagto != null) {
        retornoPagto!(Uri.tryParse(''), map.toString());
      }
    }
  }

  // CieloPayController({
  //   required this.ctlGeral,
  //   required this.repPay,
  // });

  void setRetornoPagto(Function(Uri?, String?) value) {
    retornoPagto = value;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  @override
  void onClose() {}

  String formatarNumero(double numero) {
    int numeroFormatado = (numero * 100).round();
    return numeroFormatado.toString();
  }

  Future<void> sendDeeplinkCancel(
      {required double valor,
      required String orderid,
      required String itk,
      required String atk}) async {
    String message = "";
    try {
      await platformMethodChannel.invokeMethod('cancelamento', {
        "orderid": orderid,
        "autcode": itk,
        "cielocode": atk,
        "amount": int.tryParse(formatarNumero(valor)) ?? 0,
      });
    } on PlatformException catch (e) {
      message = "Erro ao enviar: ${e.message}.";
    }
    debugPrint(message);
  }

  Future<void> sendDeeplinkPagto(
      {required PayPadraoPagtoType tipopgto,
      int? qtdeParcela,
      required double valor,
      String orderId = ''}) async {
    String message = "";
    int typePgto = 2;

    /*
          Tipo Transação
           1 - Crédito à Vista
           2 - Débito
           3 - PIX
           10 - Alimentação
           20 - Refeição
         */

    try {
      if (tipopgto == PayPadraoPagtoType.credito) {
        typePgto = 1;
      } else if (tipopgto == PayPadraoPagtoType.pix) {
        typePgto = 3;
      } else if (tipopgto == PayPadraoPagtoType.voucher) {
        typePgto = 10;
      }

      try {
        await platformMethodChannel.invokeMethod('pagamento', {
          "amount": int.tryParse(formatarNumero(valor)) ?? 0,
          "parcela": qtdeParcela ?? 0,
          "typetransacao": typePgto
        });
      } on PlatformException catch (e) {
        message = "Erro ao enviar: ${e.message}.";
      }
    } on PlatformException catch (e) {
      message = "Erro ao enviar: ${e.message}.";
    }
    debugPrint(message);
  }

  Future<void> printBmp(Uint8List img) async {
    String message = "";
    try {
      await platformMethodChannel.invokeMethod('print_img', {"img": img});
    } on PlatformException catch (e) {
      message = "Erro ao enviar: ${e.message}.";
    }
    debugPrint(message);
  }

  PayPadraoRetornoCancelModel retornoStoneCancel(String retorno) {
    PayPadraoRetornoCancelModel info = PayPadraoRetornoCancelModel();
    info.aprovado = true;
    info.isTrans = true;
    return info;
  }

  Future<PayPadraoRetornoModel> retornoCielo(String retorno) async {
    PayPadraoRetornoModel info = PayPadraoRetornoModel();
    CieloPayCheckoutResponseSuccess? infoSucess;

    info.isTrans = false;
    info.isOk = false;
    info.isTrans = true;
    infoSucess = CieloPayCheckoutResponseSuccess.fromJson(retorno);

    if (infoSucess.id != null) {
      DateTime data = _parseData(infoSucess.createdAt ?? '');
      String dataFormatada = DateFormat("dd/MM/yyyy HH:mm:ss").format(data);

      info.isOk = true;
      info.valorpago = 0;
      info.transacaoid = infoSucess.id;

      if (infoSucess.payments != null) {
        for (var pgto in infoSucess.payments!) {
          info.valorpago = (info.valorpago ?? 0) + ((pgto.amount ?? 0) / 100);
          info.itk = pgto.authCode;
          info.atk = pgto.cieloCode;
          info.bandeira = pgto.brand;
          info.authorizationCode = pgto.authCode;
          info.dataPagto = dataFormatada; 
          info.msg = pgto.description;
          info.cartaoNum = pgto.paymentFields?.pan;
          info.parcelas =
              int.tryParse(pgto.paymentFields?.numberOfQuotas ?? '0');
          info.cliente = '';
          info.tipoPagamento = pgto.paymentFields?.primaryProductName;
          info.provedor = 'Cielo';
        }
      }
    }
    return info;
  }

  DateTime _parseData(String dataString) {
    RegExp regex = RegExp(
        r'(\w{3}) (\d{1,2}), (\d{4}) (\d{1,2}):(\d{1,2}):(\d{1,2}) (\w{2})');
    Match? match = regex.firstMatch(dataString);

    if (match == null) {
      throw const FormatException("Formato de data inválido");
    }

    int month = _parseMonth(match.group(1) ?? '');
    int day = int.parse(match.group(2) ?? '');
    int year = int.parse(match.group(3) ?? '');
    int hour = int.parse(match.group(4) ?? '');
    int minute = int.parse(match.group(5) ?? '');
    int second = int.parse(match.group(6) ?? '');
    String period = match.group(7) ?? '';

    if (period == 'PM') {
      hour += 12;
    }

    return DateTime(year, month, day, hour, minute, second);
  }

  int _parseMonth(String monthString) {
    switch (monthString) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
        return 6;
      case 'Jul':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        throw const FormatException("Mês inválido");
    }
  }
}
