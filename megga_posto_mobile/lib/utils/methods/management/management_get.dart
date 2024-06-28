import 'package:megga_posto_mobile/utils/dependencies.dart';

class ManagementGet {
  final _managementController = Dependencies.managementController();

  ManagementGet._privateConstructor();
  static final ManagementGet instance = ManagementGet._privateConstructor();

  double getTotalValue() {
    double totalValue = 0.0;

    if (_managementController.listResumoFinanceiro.isEmpty) return totalValue;

    for (var item in _managementController.listResumoFinanceiro) {
      totalValue += item.valor!;
    }

    return totalValue;
  }
}
