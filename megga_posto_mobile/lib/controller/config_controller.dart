import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/credential_tef_model.dart';
import 'package:megga_posto_mobile/model/credentials_model.dart';
import '../model/data_pos_model.dart';

enum PcnTipoSmartPos {
  tpPosNenhum,
  tpPosSitef,
  tpPosCielo,
  tpPosStone,
  tpPosPagseguro,
}

class ConfigController extends GetxController {
  TextEditingController ipServidorController = TextEditingController();
  var ipServidor = ''.obs;
  var idUsuario = 0.obs;
  String nomeUsuario = '';
  var serialDevice = '';
  late Credentials credential;
  late DataPos dataPos;

  PcnTipoSmartPos tipoSmartPos() {
    bool isDadosCreTefNull = (dataPos.credenciaisTef?.isEmpty ?? true);
    CredentialTef credencialtef =
        isDadosCreTefNull ? CredentialTef() : dataPos.credenciaisTef![0];

    if (credencialtef.tipoIntegracaoSmartpos == 1) {
      return PcnTipoSmartPos.tpPosSitef;
    } else if (credencialtef.tipoIntegracaoSmartpos == 2) {
      return PcnTipoSmartPos.tpPosCielo;
    } else if (credencialtef.tipoIntegracaoSmartpos == 3) {
      return PcnTipoSmartPos.tpPosStone;
    } else if (credencialtef.tipoIntegracaoSmartpos == 4) {
      return PcnTipoSmartPos.tpPosPagseguro;
    }

    return PcnTipoSmartPos.tpPosNenhum;
  }

  bool isSmartPos() {
    return PcnTipoSmartPos.tpPosNenhum != tipoSmartPos();
  }
}
