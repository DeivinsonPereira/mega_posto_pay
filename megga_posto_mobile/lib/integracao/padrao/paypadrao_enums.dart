enum PayPadraoPagtoType {
  cartao('CARTAO'),
  debito('DEBIT'),
  credito('CREDIT'),
  creditoParcelado('CREDIT_PARC'),
  pix('PIX'),
  voucher('VOUCHER'),
  cartDigital('CART.DIGITAL');

  final String value;

  const PayPadraoPagtoType(this.value);
}
