import 'package:get/get.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';

class LogicBackButtom {
  var billController = Dependencies.billController();

  void backButtom() {
    Get.back();
  }
}
