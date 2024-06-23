import 'package:megga_posto_mobile/model/moviment_register_model.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

class ManagementFeatures {
  final _managementController = Dependencies.managementController();
  ManagementFeatures._privateConstructor();

  static final ManagementFeatures instance =
      ManagementFeatures._privateConstructor();

  void updateDocto(Docto value) {
    Docto? docto = _managementController.listDocto
        .where((element) => element.descricao == value.descricao)
        .firstOrNull;

    if (docto == null) return;

    _managementController.docto.value = docto;
    _managementController.update();
  }

  void updateCheckbox(Docto value){
    
  }
}
