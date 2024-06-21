enum CieloPagtoType {
  debito('DEBITO_AVISTA'),
  credito('CREDITO_AVISTA'),
  creditoParcelado('CREDITO_PARCELADO_ADM'),
  pix('PIX'),
  voucher('VOUCHER_ALIMENTACAO');

  final String value;

  const CieloPagtoType(this.value);
}
