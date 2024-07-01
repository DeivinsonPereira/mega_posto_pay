import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/list_cancelamento_model.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../utils/auth.dart';

class CancellSell {
  final _managementController = Dependencies.managementController();
  final _configController = Dependencies.configController();
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;

  Future<void> cancel() async {
    ListCancelamentoModel cancelamento =
        _managementController.itemCancelamentoSelected;

    try {
      Uri uri = Uri.parse(Endpoints.cancelaVenda());

      var requestBody = {
        "serial": _configController.serialDevice,
        "emissao": cancelamento.emissao,
        "venda": cancelamento.idnf,
        "no_nfce": cancelamento.noNfce,
        "serie": cancelamento.serie,
        "status": cancelamento.status,
        "justificativa": _managementController.motivoController.text,
        "xml": cancelamento.xml,
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          _handleSuccess();
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

  void _handleSuccess() {
    _managementController.itemCancelamentoSelected = ListCancelamentoModel();
    _managementController.listCancelamento = [];
    _managementController.historicoController.text = '';
    _managementController.idCancelamentoSelected.value = -1;
    _managementController.update();

    const CustomCherrySuccess(message: 'Venda cancelada com sucesso.')
        .show(Get.context!);
    QuantityBack.back(4);
  }

  void _handleErrorFromApi(String message) {
    _logger.e('Erro ao cancelar a venda. $message');
    CustomCherryError(message: message).show(Get.context!);
    Get.back();
    Get.back();
  }

  void _handleError(String message) {
    _logger.e('Erro ao cancelar a venda. $message');
    const CustomCherryError(message: 'Erro ao cancelar a venda.')
        .show(Get.context!);
    Get.back();
  }
}
