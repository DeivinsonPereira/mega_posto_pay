import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';

import '../../../utils/dependencies.dart';

class LogicButtonsManagement {
  final _managementController = Dependencies.managementController();

  LogicButtonsManagement._privateConstructor();

  static final LogicButtonsManagement instance =
      LogicButtonsManagement._privateConstructor();

  Future<void> printAndSendWithdrawal(Function() function) async {
    if (_managementController.valorController.text == '0,00' ||
        _managementController.valorController.text == '') {
      const CustomCherryError(message: 'Insira um valor maior que 0.')
          .show(Get.context!);
      return;
    }

    function();
  }
}
