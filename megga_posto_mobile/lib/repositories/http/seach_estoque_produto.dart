import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/estoque_produto.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

class SeachEstoqueProduto {
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;
  final _configController = Dependencies.configController();
  final _managementFeatures = ManagementFeatures.instance;

  SeachEstoqueProduto._privateConstructor();

  static final SeachEstoqueProduto instance =
      SeachEstoqueProduto._privateConstructor();

  Future<void> search() async {
    try {
      Uri uri = Uri.parse(Endpoints.estoqueProduto());

      var bodyRequest = {"setor_id": _configController.dataPos.setorId ?? 0};

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(bodyRequest))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<EstoqueProduto> estoqueProdutos = [];
          for (var estoque in data['data']) {
            estoqueProdutos.add(EstoqueProduto.fromMap(estoque));
          }
          _handleSucces(estoqueProdutos);
          return;
        }
        _handleError(data['message']);
        return;
      }
      _handleError(response.statusCode.toString());
      return;
    } catch (e) {
      _handleError(e.toString());
    }
  }

  _handleSucces(List<EstoqueProduto> data) {
    _managementFeatures.setListEstoque(data);
  }

  _handleError(String message) {
    _logger.e('Erro ao buscar itens do estoque. $message');
    const CustomCherryError(message: 'Erro ao buscar itens do estoque.')
        .show(Get.context!);
  }
}
