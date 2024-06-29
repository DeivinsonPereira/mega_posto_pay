import 'package:get/get.dart';
import 'package:megga_posto_mobile/page/loading/loading_page.dart';
import 'package:megga_posto_mobile/utils/dependencies.dart';
import 'package:megga_posto_mobile/utils/methods/supply/supply_features.dart';

class UpdateSupplyPump {
  final _supplyFeatures = SupplyFeatures();
  final _billController = Dependencies.billController();

  UpdateSupplyPump._privateConstructor();

  static final UpdateSupplyPump _instance =
      UpdateSupplyPump._privateConstructor();

  factory UpdateSupplyPump() {
    return _instance;
  }

  Future<void> updateSupplyPump() async {
    Get.dialog(const LoadingPage());

    await _supplyFeatures.setSupplyPump(
        Get.context!, _billController.supplySelected.bicoId);
    Get.back();
  }
}
