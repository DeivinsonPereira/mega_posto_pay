import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/repositories/http/search_reimpressao.dart';
import 'package:megga_posto_mobile/service/print/common/custom_header_print.dart';
import 'package:megga_posto_mobile/utils/date_time_formatter.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/format_numbers.dart';
import 'package:megga_posto_mobile/utils/format_string.dart';
import 'package:megga_posto_mobile/utils/methods/management/management_get.dart';

import '../../utils/utilPdfBmp.dart';
import 'execute_print.dart';

class PrintManagement {
  final _customHaderPrint = CustomHeaderPrint.instance;
  final _managementController = Dependencies.managementController();
  final _configController = Dependencies.configController();
  final _loginController = Dependencies.loginController();
  final _executePrint = ExecutePrint();
  final String spaceMinus = '-----------------------------\n';
  final String spaceEquals = '=============================\n';
  String data = DatetimeFormatter.formatDate(DateTime.now());
  String hora = DatetimeFormatter.formatHour(DateTime.now());

  Future<void> printStock() async {
    String text1 = _customHaderPrint.getHeader();

    String text2 = spaceEquals;
    text2 += 'COMPROVANTE - ESTOQUE\n';
    text2 += 'Data: $data - Hora: $hora\n';
    text2 += spaceEquals;
    text2 += 'LISTAGEM DO ESTOQUE/CONFERENCIA\n';
    text2 += spaceMinus;

    text2 += 'PRODUTO   | ESTOQUE |    | CONTAGEM |\n';
    text2 += spaceMinus;

    String text3 = '';
    //for (var item in _managementController.listEstoque) {

    for (var i = 0; i < _managementController.listEstoque.length; i++) {
      int sizeName = 27 -
          FormatString.maxLengthText(
                  _managementController.listEstoque[i].nomeProduto, 24)
              .length;
      int sizeQtd = 5 -
          _managementController.listEstoque[i].estoqueQuantidadeFisico
              .toString()
              .length;

      text3 +=
          '${FormatString.maxLengthText(_managementController.listEstoque[i].nomeProduto, 24)}${''.padRight(sizeName)}${''.padLeft(sizeQtd)}${_managementController.listEstoque[i].estoqueQuantidadeFisico}_______\n';
    }

    text3 += '\n\n\n\n\n\n\n\n\n\n';

    if (kDebugMode) {
      print(text1);
      print(text2);
      print(text3);
    }

    ExecutePrint().printTextCashRegister(text1, text2, text3, Get.context!);
  }

  Future<void> printProdutoVendido() async {
    String text1 = _customHaderPrint.getHeader();

    String text2 = spaceEquals;
    text2 += 'COMPROVANTE - ESTOQUE\n';
    text2 += 'Data: $data - Hora: $hora\n';
    text2 += spaceEquals;
    text2 += 'LISTAGEM DO ESTOQUE/CONFERENCIA\n';
    text2 += spaceMinus;

    text2 += 'PRODUTO   | ESTOQUE |    | CONTAGEM |\n';
    text2 += spaceMinus;

    String text3 = '';
    //for (var item in _managementController.listEstoque) {

    for (var i = 0;
        i < _managementController.listProdutosVendidos.length;
        i++) {
      int sizeName = 27 -
          FormatString.maxLengthText(
                  _managementController.listProdutosVendidos[i].nome ?? '', 24)
              .length;
      int sizeQtd = 10 -
          _managementController.listProdutosVendidos[i].quantidade
              .toString()
              .length;

      text3 +=
          '${FormatString.maxLengthText(_managementController.listProdutosVendidos[i].nome ?? '', 24)}${''.padRight(sizeName)}${''.padLeft(sizeQtd)}${_managementController.listProdutosVendidos[i].quantidade}_______\n';
    }

    text3 += '\n\n\n\n\n\n\n\n\n\n';

    if (kDebugMode) {
      print(text1);
      print(text2);
      print(text3);
    }

    ExecutePrint().printTextCashRegister(text1, text2, text3, Get.context!);
  }

  Future<void> supplyCash() async {
    String text1 = _customHaderPrint.getHeader();
    String text2 = spaceEquals;
    text2 += 'COMPROVANTE - SUPRIMENTO\n';
    text2 += 'Data: $data - Hora: $hora\n';
    text2 += spaceEquals;

    text2 += 'PDV........: ${_configController.dataPos.id}\n';
    text2 += 'CX.........: ${_configController.dataPos.caixaId}\n';
    text2 += 'Operador...: ${_loginController.usuarioController.text}\n';
    text2 += 'Valor......: R\$ ${_managementController.valorController.text}\n';

    text2 += spaceMinus;
    text2 += 'Historico: \n';
    text2 += '${_managementController.historicoController.text}\n\n\n';

    String text3 = '--------------------------\n';
    text3 += 'ASSINATURA RESPONSAVEL\n\n\n\n\n\n\n\n\n\n';

    if (kDebugMode) {
      print(text1);
      print(text2);
      print(text3);
    }

    _executePrint.printTextCashRegister(text1, text2, text3, Get.context!);
  }

  Future<void> withdrawalPrint(String type) async {
    //SANGRIA, DESPESA, VALE
    String text1 = spaceEquals;
    text1 += 'COMPROVANTE - $type\n';
    text1 += 'Data: $data - Hora: $hora\n';
    text1 += spaceEquals;
    String text2 = _customHaderPrint.getHeader();
    text2 += spaceEquals;

    text2 += 'PDV........: ${_configController.dataPos.id}\n';
    text2 += 'CX.........: ${_configController.dataPos.caixaId}\n';
    text2 += 'Operador...: ${_loginController.usuarioController.text}\n';
    text2 += 'Docto......: ${_managementController.docto.value.descricao}\n';
    text2 += 'Valor......: R\$ ${_managementController.valorController.text}\n';

    text2 += spaceEquals;
    text2 += 'Historico: \n';
    text2 += '${_managementController.historicoController.text}\n\n\n';

    String text3 = '--------------------------\n';
    text3 += 'ASSINATURA RESPONSAVEL\n\n\n\n\n\n\n\n\n\n';

    if (kDebugMode) {
      print(text1);
      print(text2);
      print(text3);
    }

    _executePrint.printTextCashRegister(text1, text2, text3, Get.context!);
  }

  Future<void> relatorio() async {
    String text1 = _customHaderPrint.getHeader();
    String text2 = spaceEquals;
    text2 += 'RESUMO DOCUMENTOS\n';
    text2 += 'Data: $data - Hora: $hora\n';
    text2 += spaceMinus;

    text2 += 'PDV........: ${_configController.dataPos.id}\n';
    text2 += 'CX.........: ${_configController.dataPos.caixaId}\n';
    text2 += 'Operador...: ${_loginController.usuarioController.text}\n';
    text2 += spaceEquals;

    text2 += '\nRECEBIMENTOS: \n';
    text2 += spaceEquals;

    String text3 = '';
    for (var item in _managementController.listResumoFinanceiro) {
      int sizeName = 16 - item.nome!.length;
      int sizeValue =
          12 - FormatNumbers.formatNumbertoString(item.valor ?? 0.0).length;

      text3 +=
          '${item.nome ?? ''}${''.padRight(sizeName)} ${''.padLeft(sizeValue)}${'R\$${FormatNumbers.formatNumbertoString(item.valor)}'}\n';
    }

    text3 += spaceEquals;
    text3 +=
        'Total: R\$ ${FormatNumbers.formatNumbertoString(ManagementGet.instance.getTotalValue())}\n';
    text3 += spaceEquals;
    text3 += '\n\n\n\n\n\n\n\n\n\n';
    if (kDebugMode) {
      print(text1);
      print(text2);
      print(text3);
    }

    _executePrint.printTextCashRegister(text1, text2, text3, Get.context!);
  }

  Future<void> reprintCupom() async {
    await SearchReimpressao.instance.search();
    Uint8List? imagemNfce = await UtilPDF.converterPDFparaBMP(
        _managementController.itemReimpressao.cupom!);

    _executePrint.printNfceImage(imagemNfce, 130);

    if (_isRubricaNull()) {
      Get.back();
      return;
    }

    Uint8List? imagemRubrica =
        base64Decode(_managementController.itemReimpressao.rubrica!);

    _executePrint
        .printNfceImage(imagemRubrica, 130)
        .then((element) => Get.back());
  }

  bool _isRubricaNull() {
    return _managementController.itemReimpressao.rubrica == null ||
        _managementController.itemReimpressao.rubrica == '';
  }
}
