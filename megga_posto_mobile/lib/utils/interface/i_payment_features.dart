import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';

import '../../model/collections/payment_form.dart';

abstract class IPaymentFeatures {
  void addSelectedPayment(String paymentFormDocto,{  PaymentCartaoModel? dadosCartao, PaymentPixModel? dadosPix});
  void autoFillValuePayment();
  void removeNumberFromEnteredValue();
  Future<void>setPaymentForms();
  void setPaymentFormsDocto(List<PaymentForm> paymentFormList);
  void addPaymentFormsToList(int quantity, PaymentForm paymentForms, double value);
  void addValuePayment();
  void addNumberToEnteredValue(String number, String paymentFormDocto);
  void clearEnteredValue();
  void clearAll();
}
