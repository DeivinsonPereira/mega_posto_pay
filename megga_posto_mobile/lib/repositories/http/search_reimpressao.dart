import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/model/reimpressao_cupom.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

class SearchReimpressao {
  final _ioClient = SingletonsInstances().ioClient;
  final _logger = SingletonsInstances().logger;
  final _managementFeatures = ManagementFeatures.instance;
  final _managementController = Dependencies.managementController();

  SearchReimpressao._privateConstructor();

  static final SearchReimpressao instance =
      SearchReimpressao._privateConstructor();

  Future<void> search() async {
    try {
      Uri uri = Uri.parse(Endpoints.reimprimeCupom());

      var bodyRequest = {
        "id": _managementController.itemReimpressaoSelected.idnf
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(bodyRequest))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          ReimpressaoCupom cumpom = ReimpressaoCupom.fromMap(data['data']);

          _handleSucces(cumpom);
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

  _handleSucces(ReimpressaoCupom data) {
    _managementFeatures.setItemReimpressao(data);
  }

  _handleError(String message) {
    _logger.e('Erro ao buscar itens da reimpressão. $message');
    const CustomCherryError(message: 'Erro ao buscar itens da reimpressão.')
        .show(Get.context!);
  }
}
