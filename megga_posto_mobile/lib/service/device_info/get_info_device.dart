import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:megga_posto_mobile/common/custom_cherry.dart';
import 'package:megga_posto_mobile/utils/methods/config/config_features.dart';
import 'package:megga_posto_mobile/utils/native_channel.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';

class GetInfoDevice {
  final _configFeatures = ConfigFeatures.instance;
  final _logger = SingletonsInstances().logger;

  GetInfoDevice._privateConstructor();

  static final GetInfoDevice instance = GetInfoDevice._privateConstructor();

  Future<void> getSerialNumber() async {
    try {
      var result = await NativeChannel.platform.invokeMethod('getSerialNumber');

      if (result != null) {
        _configFeatures.setSerialDevice(result);

        _logger.d(
            "Método getSerialNumber chamado com sucesso, resultado: $result");
        return;
      }

      const CustomCherryError(
              message: 'Erro ao buscar o serial do dispositivo.')
          .show(Get.context!);
    } on PlatformException catch (e) {
      _logger.e("Erro ao buscar o serial do dispositivo: $e");
    } catch (e) {
      _logger.e("Erro ao buscar o serial do dispositivo: $e");
    }
  }
}
