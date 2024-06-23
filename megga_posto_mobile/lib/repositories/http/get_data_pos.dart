// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';

import '../../model/data_pos_model.dart';
import '../../utils/auth.dart';
import '../../utils/dependencies.dart';
import '../../utils/endpoints.dart';
import '../../utils/methods/config/config_features.dart';

class GetDataPos {
  final _configFeatures = ConfigFeatures.instance;
  final _confiController = Dependencies.configController();
  final _logger = Logger();

  Future<bool> getDataPos(BuildContext context) async {
    Uri uri = Uri.parse(Endpoints.endpointCredetialPix());

    HttpClient client = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    IOClient ioClient = IOClient(client);

    try {
      var bodyRequest = {
        "pserial": _confiController.serialDevice,
      };

      var response = await ioClient
          .post(
            uri,
            body: jsonEncode(bodyRequest),
            headers: Auth.header,
          )
          .timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          _handleSuccess(data);
          return true;
        } else {
          _handleError(data['message']);
          return false;
        }
      } else {
        _handleError('status code: ${response.statusCode}');
        return false;
      }
    } on TimeoutException catch (e) {
      _handleError(e.message!);
      return false;
    } catch (e) {
      _handleError(e.toString());
      return false;
    }
  }

  Future<void> _handleSuccess(dynamic data) async {
    _logger.i('Informações da POS obtidas com sucesso!');
    _configFeatures.setDataPos(DataPos.fromMap(data['data']));
  }

  Future<void> _handleError(String message) async {
    _logger.e('Erro ao buscar credenciais. $message');
    CustomCherryError(message: message).show(Get.context!);
    return;
  }
}
