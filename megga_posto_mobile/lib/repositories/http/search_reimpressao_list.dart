import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/list_reimpressao.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';

import '../../utils/singletons_instances.dart';

class SearchReimpressaoList {
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;
  final _configController = Dependencies.configController();
  final _managementFeatures = ManagementFeatures.instance;

  SearchReimpressaoList._privateConstructor();

  static final SearchReimpressaoList instance =
      SearchReimpressaoList._privateConstructor();

  Future<void> search() async {
    try {
      Uri uri = Uri.parse(Endpoints.returnaListaReimpressao());

      var bodyRequest = {
        "atendente_id": _configController.idUsuario.value,
        "caixa_id": _configController.dataPos.dadosCaixa?[0].caixaId
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(bodyRequest))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<ListReimpressao> listReimpressao = [];
          for (var reimpressao in data['data']) {
            listReimpressao.add(ListReimpressao.fromMap(reimpressao));
          }
          _handleSucces(listReimpressao);
          return;
        }
        _handleErrorResponseApi(data['message']);
        return;
      }
      _handleError(response.statusCode.toString());
      return;
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleSucces(List<ListReimpressao> data) {
    _managementFeatures.setListReimpressao(data);
  }

  void _handleErrorResponseApi(String message) {
    _logger.e('Erro ao buscar itens de reimpressao. $message');
    CustomCherryError(message: message).show(Get.context!);
  }

  void _handleError(String message) {
    _logger.e('Erro ao buscar itens de reimpressao. $message');
    const CustomCherryError(message: 'Erro ao buscar itens de reimpressao.')
        .show(Get.context!);
  }
}
