import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/moviment_register_model.dart';

class ManagementController extends GetxController {
  TextEditingController historicoController = TextEditingController();

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
