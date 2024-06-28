import 'package:megga_posto_mobile/utils/dependencies.dart';

class CustomHeaderPrint {
  CustomHeaderPrint._privateConstructor();

  static final CustomHeaderPrint instance =
      CustomHeaderPrint._privateConstructor();

  String getHeader() {
    final _configController = Dependencies.configController();

    String text = '\n\n';

    text += '${_configController.dataPos.razaoSocial}\n';
    text += '${_configController.dataPos.nomeFantasia}\n\n';

    text += 'CNPJ: ${_configController.dataPos.cnpj}\n';
    text += 'I.E.: ${_configController.dataPos.iscricaoEstadual}\n';
    text +=
        '${_configController.dataPos.tipoLogradouro} ${_configController.dataPos.logradouro} ${_configController.dataPos.numero}\n';
    text +=
        '${_configController.dataPos.nomeDoMunicipio} ${_configController.dataPos.fed_uf}\n\n';

    return text;
  }
}
