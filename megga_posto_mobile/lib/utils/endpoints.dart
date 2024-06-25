import 'package:get/get.dart';

import 'dependencies.dart';

abstract class Endpoints {
  static var configController = Dependencies.configController();
  static var ip = configController.ipServidor;
  static String postLogin() {
    if (ip.isNotEmpty) {
      return '${ip}login';
    }
    return '';
  }

  static String loginNfc() {
    if (ip.isNotEmpty) {
      return '${ip}login_nfc';
    }
    return '';
  }

  static String resumeSupply() {
    if (ip.isNotEmpty) {
      return '${ip}retorna_abastecimento_atendente';
    }
    return '';
  }

  static String supplyPump() {
    if (ip.isNotEmpty) {
      return '${ip}retorna_abastecimento_por_bico_atendente';
    }
    return '';
  }

  static String products() {
    if (ip.isNotEmpty) {
      return '${ip}retorna_produto';
    }
    return '';
  }

  static String paymentForm() {
    if (ip.isNotEmpty) {
      return '${ip}retorna_forma_pagamento';
    }
    return '';
  }

  static String credentials() {
    if (ip.isNotEmpty) {
      return '${ip}retorna_dados_credenciais_fidelidade';
    }
    return '';
  }

  static String credetialPix() {
    if (ip.isNotEmpty) {
      return '${ip}retorna_dados_smart_pos';
    }
    return '';
  }

  static String venda() {
    if (ip.isNotEmpty) {
      return '${ip}grava_venda';
    }
    return '';
  }

  static String penseBankPix(String suffix) {
    late String endpoint;

    int? ambiente = configController.dataPos.credenciaisPix?[0].ambiente;

    if(ambiente == null) return '';

      if(ambiente == 0 || ambiente == 2) {
        endpoint = 'https://sandbox.pensebank.com.br/$suffix';
      }

      if(ambiente == 1) {
        endpoint = 'https://api.pensebank.com.br/$suffix';
      }
      
      return endpoint;
      
  }
}
