import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_features.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../common/custom_cherry.dart';
import '../../model/resumo_financeiro.dart';
import '../../utils/dependencies.dart';

class ReturnResumoFinanceiro {
  final _ioClient = SingletonsInstances().ioClient;
  final _configController = Dependencies.configController();
  final _managementFeatures = ManagementFeatures.instance;
  final _logger = SingletonsInstances().logger;

  Future<void> returnResumoFinanceiro() async {
    try {
      Uri uri = Uri.parse(Endpoints.retornaResumoFinanceiro());

      var requestBody = {
        "pcaixa_id": _configController.dataPos.caixaId,
        "patendente_id": _configController.idUsuario.value
      };

      var response = await _ioClient
          .post(uri, headers: Auth.header, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['success'] == true) {
          List<ResumoFinanceiro> resumoFinanceiro = [];

          for (var item in result['data']) {
            resumoFinanceiro.add(ResumoFinanceiro.fromMap(item));
          }
          _handleSuccess(Get.context!, resumoFinanceiro);
          return;
        }
        _handleErrorFromApi(Get.context!, result['message']);
        return;
      }
      _handleError(Get.context!, response.statusCode.toString());
    } catch (e) {
      _handleError(Get.context!, e.toString());
      return;
    }
  }

  void _handleErrorFromApi(BuildContext context, String message) {
    CustomCherryError(message: message).show(context);
    Get.back();
  }

  void _handleError(BuildContext context, String message) {
    _logger.e('Erro ao buscar o resumo. $message');
    const CustomCherryError(message: 'Erro ao buscar o resumo').show(context);
    Get.back();
  }

  void _handleSuccess(BuildContext context, List<ResumoFinanceiro> result) {
    _managementFeatures.updateResumoFinanceiro(result);
    Get.back();
  }
}
