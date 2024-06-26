import 'package:megga_posto_mobile/model/payment_form_selected.dart';

import '../../../model/sell_item_model.dart';
import '../../../model/sell_model.dart';

abstract class IExecuteSell {
  Future<void> executeSell();
  Future<Sell> getSell();
  List<SellItem> getSupplyItem();
  List<SellItem> getProductItem();
  List<PaymentFormSelected> getPaymentFormSelected();
}
