import '../../../controller/payment_controller.dart';
import '../../dependencies.dart';
import '../bill/bill_get.dart';

class PaymentGet {
  late final PaymentController _paymentController;
  final _billGet = BillGet();

  PaymentGet._privateConstructor() {
    _paymentController = Dependencies.paymentController();
  }

  static final PaymentGet _instance = PaymentGet._privateConstructor();

  factory PaymentGet() => _instance;

  double getTotalPaid() {
    return _paymentController.listPaymentsSelected
        .fold(0.0, (first, second) => first + second.valorIntegral!);
  }

  double getChange() {
    double totalValueCartShopping = _billGet.getTotalValueFromCart();
    double totalPaid = getTotalPaid();

    double change = totalPaid - totalValueCartShopping;

    return change > 0 ? change : 0.0;
  }

  double getDiscountValue() {
    // TODO: implement getDiscountValue
    throw UnimplementedError();
  }

  double getRemainingValue() {
    double totalValue = _billGet.getTotalValueFromCart();

    return totalValue - _paymentController.valuePayment.value;
  }

  double getEnteredValue() {
    return _paymentController.enteredValue.value;
  }

  bool isPaymentNotaExists(String paymentType) {
    return _paymentController.listPaymentsSelected
            .where((element) => element.tipoDocto == 'NT')
            .isNotEmpty &&
        paymentType == 'NT';
  }
}
