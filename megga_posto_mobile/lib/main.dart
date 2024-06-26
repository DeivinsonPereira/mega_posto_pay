// ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:megga_posto_mobile/model/collections/dado_empresa.dart';
import 'package:megga_posto_mobile/model/collections/data_pix.dart';
import 'package:megga_posto_mobile/service/device_info/get_info_device.dart';
import 'package:path_provider/path_provider.dart';

import 'model/collections/payment_form.dart';
import 'model/collections/product.dart';
import 'core/app_widget.dart';
import 'utils/methods/config/config_features.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // só deixa inicializar o run depois dos comandos async abaixo estiverem rodando.
  final dir = await getApplicationSupportDirectory();
  //abre o banco de dados e as tabelas
  await Isar.open(
    [
      DadoEmpresaSchema,
      ProductSchema,
      PaymentFormSchema,
      DataPixSchema,
    ],
    directory: dir.path,
    inspector: true,
  );

  final _configFeatures = ConfigFeatures.instance;
  _configFeatures.updateIpServidor();

  // TODO já está funcionando, só descomentar quando estiver cadastrado na api
  // await GetInfoDevice.instance.getSerialNumber();

  // apagar quando for para produção
  _configFeatures
      .setSerialDevice('sdsdsdsdscr34343'); //androidInfo.serialNumber

  runApp(const AppWidget());
}
