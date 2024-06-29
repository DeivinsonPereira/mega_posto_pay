import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/grava_vale_post_model.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';

import '../../utils/auth.dart';
import '../../utils/dependencies.dart';
import '../../utils/endpoints.dart';
import '../../utils/method_quantity_back.dart';
import '../../utils/singletons_instances.dart';

class RecordSalaryAdvance {
  final _configController = Dependencies.configController();
  final _managementController = Dependencies.managementController();
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;

  Future<void> record() async {
    try {
      Uri uri = Uri.parse(Endpoints.gravaVale());

      GravaValePostModel bodyRequest = GravaValePostModel(
          idconta_salario: _configController.dataPos.idContaSalario ?? 0,
          replicate_caixa_id: _configController.dataPos.dadosCaixa?[0].replicateCaixaId ?? '0',
          caixa_id: _configController.dataPos.caixaId ?? 0,
          atendente_id: _configController.idUsuario.value,
          nome_atendente: _configController.nomeUsuario,
          historico: _managementController.historicoController.text,
          valor: FormatNumbers.formatStringToDouble(_managementController.valorController.text) > 0
              ? FormatNumbers.formatStringToDouble(_managementController.valorController.text)
              : 0,
          idconta_pista: _configController.dataPos.idContaPista ?? 0,
          documento_id: _managementController.docto.value.codigo,
          pdv_id: _configController.dataPos.id ?? 0);

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
    const CustomCherrySuccess(message: 'Vale registrado com sucesso.')
        .show(Get.context!);
    QuantityBack.back(2);
  }

  void _handleError(String message) {
    _logger.e('Erro: $message');
    const CustomCherryError(message: 'Erro ao registrar o vale.')
        .show(Get.context!);
    Get.back();
  }
}