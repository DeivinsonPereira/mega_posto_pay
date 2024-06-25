// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

import '../../model/supply_pump_model.dart';
import '../../utils/auth.dart';
import '../../utils/endpoints.dart';

class GetSupplyPump {
  final _configController = Dependencies.configController();
  final _logger = SingletonsInstances().logger;

  Future<List<SupplyPump>> getSupplyPump(
      BuildContext context, int idSupplyPump) async {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    IOClient ioClient = IOClient(client);

    Uri uri = Uri.parse(Endpoints.supplyPump());

    try {
      var bodyRequest = {
        "pidbico": idSupplyPump,
        "pidatendente": _configController.idUsuario.value,
        "pcaixa_id": _configController.dataPos.dadosCaixa?[0].caixaId ?? 0
      };

      var response = await ioClient.post(
        uri,
        body: jsonEncode(bodyRequest),
        headers: Auth.header,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<SupplyPump> supplies = [];
          for (var supply in data['data']) {
            supplies.add(SupplyPump.fromMap(supply));
          }
          return supplies;
        } else {
          _logger.e('Erro ao buscar abastecimentos. ${data['message']}');
          return [];
        }
      } else {
        _logger.e('Erro ao buscar abastecimentos. ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _logger.e('Erro ao buscar abastecimentos. erro: $e');
      return [];
    }
  }
}
