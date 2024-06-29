import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../common/custom_cherry.dart';
import '../../model/expense_post_model.dart';
import '../../utils/dependencies.dart';
import '../../utils/method_quantity_back.dart';

class RecordExpense {
  final _configController = Dependencies.configController();
  final _managementController = Dependencies.managementController();
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;

  Future<void> record() async {
    try {
      Uri uri = Uri.parse(Endpoints.gravaDespesa());

      ExpensePostModel bodyRequest = ExpensePostModel(
          caixa_id: _configController.dataPos.caixaId ?? 0,
          atendente_id: _configController.idUsuario.value,
          historico: _managementController.historicoController.text,
          valor: FormatNumbers.formatStringToDouble(
                      _managementController.valorController.text) >
                  0
              ? FormatNumbers.formatStringToDouble(
                  _managementController.valorController.text)
              : 0,
          conta_id: _configController.dataPos.idContaCaixa ?? 0,
          idconta_pista: _configController.dataPos.idContaPista ?? 0,
          documento_id: _managementController.docto.value.codigo);

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
    const CustomCherrySuccess(message: 'Despesa registrada com sucesso.')
        .show(Get.context!);
    QuantityBack.back(2);
  }

  void _handleError(String message) {
    _logger.e('Erro: $message');
    const CustomCherryError(message: 'Erro ao registrar a despesa.')
        .show(Get.context!);
    Get.back();
  }
}
