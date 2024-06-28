import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../common/custom_cherry.dart';
import '../../utils/dependencies.dart';

class ReturnResumoFinanceiro {
  final _ioClient = SingletonsInstances().ioClient;
  final _configController = Dependencies.configController();
  final _logger = SingletonsInstances().logger;

  Future<void> returnResumoFinanceiro(BuildContext context) async {
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

        _handleSuccess(context, result);

        return;
      }

      _handleError(context, response.statusCode.toString());
    } catch (e) {
      _handleError(context, e.toString());
      return;
    }
  }

  void _handleErrorFromApi(BuildContext context, String message) {
    CustomCherryError(message: message).show(context);
  }

  void _handleError(BuildContext context, String message) {
    _logger.e('Erro ao buscar o resumo. $message');
    const CustomCherryError(message: 'Erro ao buscar o resumo').show(context);
  }

  void _handleSuccess(BuildContext context, dynamic result) {}
}
