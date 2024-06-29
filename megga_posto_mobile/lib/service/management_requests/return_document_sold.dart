import 'dart:convert';

import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/return_sold_document.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../common/custom_cherry.dart';
import '../../utils/dependencies.dart';

class ReturnDocumentSold {
  final _ioClient = SingletonsInstances().ioClient;
  final _configController = Dependencies.configController();
  final _managementController = Dependencies.managementController();

  ReturnDocumentSold._privateConstructor();

  static final ReturnDocumentSold instance =
      ReturnDocumentSold._privateConstructor();

  Future<double> getTotal() async {
    try {
      Uri uri = Uri.parse(Endpoints.retornaSaldoDocumento());

      ReturnSoldDocument returnModel = ReturnSoldDocument(
        atendente_id: _configController.idUsuario.value,
        caixa_id: _configController.dataPos.caixaId ?? 0,
        documento_id: _managementController.docto.value.codigo,
      );

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: returnModel.toJson())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success'] == true) {
          return result['data']['valor'];
        }
        _handleError();
        return 0.0;
      }

      _handleError();
      return 0.0;
    } catch (e) {
      _handleError();
      return 0.0;
    }
  }

  void _handleError() {
    const CustomCherryError(message: 'Erro ao registrar o documento.')
        .show(Get.context!);
  }
}
