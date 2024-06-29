import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/produto_vendido_model.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/method_quantity_back.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../common/custom_cherry.dart';
import '../../utils/dependencies.dart';

class SearchProdutoVendido {
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;
  final _managementFeatures = ManagementFeatures.instance;
  final _configController = Dependencies.configController();

  Future<void> search() async {
    try {
      Uri uri = Uri.parse(Endpoints.produtoVendido());

      var requestBody = {
        "caixa_id": _configController.dataPos.caixaId,
        "atendente_id": _configController.idUsuario.value
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          List<ProdutoVendidoModel> produtosVendidos = [];
          for (var item in result['data']) {
            produtosVendidos.add(ProdutoVendidoModel.fromMap(item));
          }
          _handleSuccess(produtosVendidos);
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

  void _handleSuccess(data) {
    _managementFeatures.updateListProdutoVendido(data);
    QuantityBack.back(2);
  }

  void _handleError(String message) {
    _logger.e('Erro ao buscar o produto. $message');
    const CustomCherryError(message: 'Erro ao buscar o produto.')
        .show(Get.context!);
    Get.back();
  }

  void _handleErrorFromApi(String message) {
    _logger.e('Erro ao buscar o produto. $message');
    CustomCherryError(message: message).show(Get.context!);
    Get.back();
  }
}
