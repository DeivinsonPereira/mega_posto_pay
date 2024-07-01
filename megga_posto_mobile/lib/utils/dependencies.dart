import 'package:get/get.dart';
import 'package:megga_posto_mobile/controller/bill_controller.dart';
import 'package:megga_posto_mobile/controller/camera_controller.dart';
import 'package:megga_posto_mobile/controller/config_controller.dart';
import 'package:megga_posto_mobile/controller/management_controller.dart';
import 'package:megga_posto_mobile/controller/payment_controller.dart';
import 'package:megga_posto_mobile/controller/supply_controller.dart';
import 'package:megga_posto_mobile/controller/text_field_controller.dart';
import 'package:megga_posto_mobile/integracao/cielo/cielopay_controller.dart';
import 'package:megga_posto_mobile/integracao/padrao/paypadrao_controller.dart';
import 'package:megga_posto_mobile/print/generic/smartgeneric_print_controller.dart';
import 'package:megga_posto_mobile/print/print_controller.dart';

import '../controller/login_controller.dart';
import '../controller/splash_controller.dart';

abstract class Dependencies {
  static SplashController splashController() {
    if (Get.isRegistered<SplashController>()) {
      return Get.find<SplashController>();
    } else {
      return Get.put(SplashController());
    }
  }

  static LoginController loginController() {
    if (Get.isRegistered<LoginController>()) {
      return Get.find<LoginController>();
    } else {
      return Get.put(LoginController());
    }
  }

  static TextFieldController textFieldController() {
    if (Get.isRegistered<TextFieldController>()) {
      return Get.find<TextFieldController>();
    } else {
      return Get.put(TextFieldController());
    }
  }

  static ConfigController configController() {
    if (Get.isRegistered<ConfigController>()) {
      return Get.find<ConfigController>();
    } else {
      return Get.put(ConfigController(), permanent: true);
    }
  }

  static SmartGenericPrint smartGenericController() {
    if (Get.isRegistered<SmartGenericPrint>()) {
      return Get.find<SmartGenericPrint>();
    } else {
      return Get.put(SmartGenericPrint(), permanent: true);
    }
  }

  static SupplyController supplyController() {
    if (Get.isRegistered<SupplyController>()) {
      return Get.find<SupplyController>();
    } else {
      return Get.put(SupplyController(), permanent: true);
    }
  }

  static BillController billController() {
    if (Get.isRegistered<BillController>()) {
      return Get.find<BillController>();
    } else {
      return Get.put(BillController(), permanent: true);
    }
  }

  static PaymentController paymentController() {
    if (Get.isRegistered<PaymentController>()) {
      return Get.find<PaymentController>();
    } else {
      return Get.put(PaymentController(), permanent: true);
    }
  }

  static PrintController printController() {
    if (Get.isRegistered<PrintController>()) {
      return Get.find<PrintController>();
    } else {
      return Get.put(PrintController(), permanent: true);
    }
  }

  static CieloPayController cieloPayController() {
    if (Get.isRegistered<CieloPayController>()) {
      return Get.find<CieloPayController>();
    } else {
      return Get.put(CieloPayController(), permanent: true);
    }
  }

  static PayPadraoController payPadraoController() {
    cieloPayController();

    if (Get.isRegistered<PayPadraoController>()) {
      return Get.find<PayPadraoController>();
    } else {
      return Get.put(PayPadraoController(), permanent: true);
    }
  }

  static ManagementController managementController() {
    if (Get.isRegistered<ManagementController>()) {
      return Get.find<ManagementController>();
    } else {
      return Get.put(ManagementController(), permanent: true);
    }
  }

  static CameraPhotoController cameraPhotoController() {
    if (Get.isRegistered<CameraPhotoController>()) {
      return Get.find<CameraPhotoController>();
    } else {
      return Get.put(CameraPhotoController(), permanent: true);
    }
  }
}
