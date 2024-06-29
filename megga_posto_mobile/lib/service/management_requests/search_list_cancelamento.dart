import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/list_cancelamento_model.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

class SearchListCancelamento {
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = Logger();
  final _configController = Dependencies.configController();
  final _managementFeatures = ManagementFeatures.instance;

  Future<void> search() async {
    try {
      Uri uri = Uri.parse(Endpoints.retornaListaCancelamento());

      var requestBody = {
        "patendente_id": _configController.idUsuario.value,
        "pcaixa_id": _configController.dataPos.caixaId,
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          List<ListCancelamentoModel> cancelamentos = [];
          for (var item in result['data']) {
            cancelamentos.add(ListCancelamentoModel.fromMap(item));
          }
          _handleSuccess(cancelamentos);
          return;
        }
        _handleErrorFromApi(result['message']);
        return;
      }
      _handleError(response.statusCode.toString());
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleSuccess(List<ListCancelamentoModel> cancelamentos) {
    _managementFeatures.setListCancelamento(cancelamentos);
  }

  void _handleErrorFromApi(String message) {
    _logger.e('Erro ao buscar a lista de vendas para cancelamento. $message');
    CustomCherryError(message: message).show(Get.context!);
    Get.back();
  }

  void _handleError(String message) {
    _logger.e('Erro ao buscar a lista de vendas para cancelamento. $message');
    const CustomCherryError(
            message: 'Erro ao buscar a lista de vendas para cancelamento.')
        .show(Get.context!);
    Get.back();
  }
}
