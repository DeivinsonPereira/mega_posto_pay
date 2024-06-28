import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/estoque_produto.dart';
import 'package:megga_posto_mobile/model/reimpressao_cupom.dart';
import 'package:megga_posto_mobile/model/resumo_financeiro.dart';

import '../model/list_reimpressao.dart';
import '../model/moviment_register_model.dart';

class ManagementController extends GetxController {
  TextEditingController historicoController = TextEditingController();
  TextEditingController valorController = TextEditingController(text: '0,00');

  RxDouble valor = 0.0.obs;
  List<EstoqueProduto> listEstoque = <EstoqueProduto>[].obs;
  List<ListReimpressao> listReimpressao = <ListReimpressao>[].obs;
  List<ResumoFinanceiro> listResumoFinanceiro = <ResumoFinanceiro>[].obs;

  ReimpressaoCupom itemReimpressao = ReimpressaoCupom();

  ListReimpressao itemReimpressaoSelected = ListReimpressao();
  RxInt idReimpressaoSelected = (-1).obs;

  RxList<Docto> listDocto = <Docto>[
    Docto(
      descricao: 'DINHEIRO',
      codigo: 4,
    ),
    Docto(
      descricao: 'CREDITO',
      codigo: 9,
    ),
    Docto(
      descricao: 'DEBITO',
      codigo: 7,
    ),
    Docto(
      descricao: 'PIX',
      codigo: 1000016,
    ),
    Docto(
      descricao: 'NOTA',
      codigo: 1,
    ),
  ].obs;

  Rx<Docto> docto = Docto(
    descricao: 'DEBITO',
    codigo: 7,
  ).obs;
}
