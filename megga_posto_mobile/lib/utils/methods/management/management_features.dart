import 'package:get/get.dart';
import 'package:megga_posto_mobile/model/estoque_produto.dart';
import 'package:megga_posto_mobile/model/list_reimpressao.dart';
import 'package:megga_posto_mobile/model/moviment_register_model.dart';
import 'package:megga_posto_mobile/model/reimpressao_cupom.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

import '../../../service/register_moviment/return_document_sold.dart';

class ManagementFeatures {
  final _managementController = Dependencies.managementController();
  ManagementFeatures._privateConstructor();

  static final ManagementFeatures instance =
      ManagementFeatures._privateConstructor();

  void setListEstoque(List<EstoqueProduto> list) {
    _managementController.listEstoque.assignAll(list);
  }

  void setListReimpressao(List<ListReimpressao> list) {
    _managementController.listReimpressao.assignAll(list);
  }

  void setItemReimpressao(ReimpressaoCupom item) {
    _managementController.itemReimpressao = item;
  }

  void updateDocto(Docto value) {
    Docto? docto = _managementController.listDocto
        .where((element) => element.descricao == value.descricao)
        .firstOrNull;

    if (docto == null) return;

    _managementController.docto.value = docto;
    _managementController.update();
  }

  Future<void> updateValue() async {
    _managementController.valor.value =
        await ReturnDocumentSold.instance.getTotal();
  }

  void updateidReimpressaoSelected(int index) {
    if (_managementController.idReimpressaoSelected.value == index) {
      _managementController.idReimpressaoSelected.value = -1;

      _managementController.itemReimpressaoSelected =
          _managementController.listReimpressao[index];
      _managementController.update();
      return;
    }
    _managementController.itemReimpressaoSelected =
        _managementController.listReimpressao[index];
    _managementController.idReimpressaoSelected.value = index;
    _managementController.update();
  }

  void resetValues() {
    _managementController.historicoController.text = '';
    _managementController.valorController.text = '';
    _managementController.docto.value = Docto(
      descricao: 'DEBITO',
      codigo: 7,
    );
  }
}
