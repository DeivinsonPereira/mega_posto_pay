import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/cash_supply_post_model.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../utils/format_numbers.dart';

class RecordCashSupply {
  final _configController = Dependencies.configController();
  final _managementController = Dependencies.managementController();
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;

  Future<void> record() async {
    try {
      Uri uri = Uri.parse(Endpoints.suprimento());

      CashSupplyPostModel bodyRequest = CashSupplyPostModel(
          caixa_id: _configController.dataPos.caixaId ?? 0,
          atendente_id: _configController.idUsuario.value,
          nome_atendente: _configController.nomeUsuario,
          historico: _managementController.historicoController.text,
          valor: FormatNumbers.formatStringToDouble(_managementController.valorController.text) > 0
              ? FormatNumbers.formatStringToDouble( _managementController.valorController.text)
              : 0,
          idconta_caixa: _configController.dataPos.idContaCaixa ?? 0,
          idconta_pista: _configController.dataPos.idContaPista ?? 0);

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: bodyRequest.toJson())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          _handleSuccess();
          return;
        }
        _handleError(result['message']);
        return;
      }
      _handleError(response.statusCode.toString());
      return;
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleSuccess() {
    const CustomCherrySuccess(message: 'Suprimento registrado com sucesso.')
        .show(Get.context!);
    QuantityBack.back(2);
  }

  void _handleError(String message) {
    _logger.e('Error $message');
    const CustomCherryError(message: 'Erro ao registrar o suprimento.')
        .show(Get.context!);
    Get.back();
  }
}
