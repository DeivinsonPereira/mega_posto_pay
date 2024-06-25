import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:megga_posto_mobile/model/payment_cartao_model.dart';
import 'package:megga_posto_mobile/model/payment_pix_model.dart';
import 'package:megga_posto_mobile/model/product_and_quantity_model.dart';
import 'package:megga_posto_mobile/model/retorno_fechamento_model.dart';
import 'package:megga_posto_mobile/model/sell_item_model.dart';
import 'package:megga_posto_mobile/service/execute_sell/interface/i_execute_sell.dart';
import 'package:megga_posto_mobile/utils/auth.dart';
import 'package:megga_posto_mobile/utils/endpoints.dart';
import 'package:megga_posto_mobile/utils/singletons_instances.dart';
import '../../model/payment_form_selected.dart';
import '../../model/sell_model.dart';
import '../../model/supply_pump_model.dart';
import '../../utils/dependencies.dart';
import 'package:http/http.dart' as http;

class ExecuteSell implements IExecuteSell {
  final Logger _logger = Logger();
  final _billController = Dependencies.billController();
  final _paymentController = Dependencies.paymentController();
  final _configController = Dependencies.configController();

  final _ioClient = SingletonsInstances().ioClient;
  final _booleanMethods = SingletonsInstances().booleanMethods;
  double totalNota = 0.0;
  double totalProduct = 0.0;
  int count = 1;
  List<SellItem> items = [];
  List<PaymentFormSelected> listPaymentsSelected = [];

  @override
  Future<String> executeSell() async {
    try {
      _addTotalNota();
      _addTotalProduct();

      if (!_booleanMethods.isSupplyPumpEmpty()) {
        items.addAll(getSupplyItem());
      }
      if (!_booleanMethods.isProductEmpty()) {
        items.addAll(getProductItem());
      }

      listPaymentsSelected = getPaymentFormSelected();

      Sell sell = await getSell();

      var request = http.MultipartRequest('POST', Uri.parse(Endpoints.venda()));
      request.headers['Authorization'] = Auth.basicAuth;

      request.fields['x-venda'] = sell.toJson();

      if (_paymentController.assignaturePng.isNotEmpty ||
          _paymentController.assignaturePng != Uint8List(0)) {
        request.files.add(http.MultipartFile.fromBytes(
          'x-assinatura',
          _paymentController.assignaturePng,
          filename: 'assignature.png',
          contentType: http.MultipartFile.fromBytes(
                  'assignature.png', _paymentController.assignaturePng,
                  filename: 'assignature.png')
              .contentType,
        ));
      }

      var streamedResponse = await _ioClient.send(request);
      if (kDebugMode) print(sell.toJson());
      if (kDebugMode) print(streamedResponse.stream);

      if (streamedResponse.statusCode == 200) {
        var responseBytes = await streamedResponse.stream.toBytes();
        var responseBody = utf8.decode(responseBytes);
        RetornoFechamentoModel retorno =
            RetornoFechamentoModel.fromJson(responseBody);

        if (retorno.success) {
          count = 1;
          return retorno.data;
        } else {
          _logger.e('Erro ao executar a venda. ${retorno.message}');
          count = 1;
          return '';
        }
      } else {
        _logger.e(
            'Erro ao executar a venda dados. Status code: ${streamedResponse.statusCode}');
        count = 1;
        return '';
      }
    } catch (e) {
      _logger.e('Erro ao executar a venda. $e');
      count = 1;
      return '';
    }
  }

  // Monta o objeto Sell
  @override
  Future<Sell> getSell() async {
    Sell sell;
    sell = Sell(
      serial: _configController.serialDevice,
      valor_desconto: 0,
      cliente_id: 1,
      data_venda: DateTime.now().toIso8601String(),
      total_nota: totalNota,
      total_produtos: totalProduct,
      data_hora_venda: DateTime.now().toIso8601String(),
      caixa_id: _configController.dataPos.caixaId ?? 0,
      atendente_id: _configController.idUsuario.value,
      replicate_caixa_id:
          _configController.dataPos.dadosCaixa?[0].replicateCaixaId ?? '0',
      itens: items,
      parcelas: listPaymentsSelected,
    );
    return sell;
  }

  // adiciona os itens com base nos supply que estão no carrinho
  @override
  List<SellItem> getSupplyItem() {
    List<SellItem> itens = [];

    for (var item in _billController.cartShopping) {
      if (item.supplyPump == null) continue;
      SupplyPump supplyPump = item.supplyPump!;

      itens.add(
        SellItem(
          produto_id: item.supplyPump!.produto_id,
          sequencia: count,
          quantidade: supplyPump.quantidade,
          total_liquido: supplyPump.total,
          tanque_id: supplyPump.tanque_id,
          bico_id: supplyPump.bicoId,
          abastecimento_id: supplyPump.id,
          encerrante_final: supplyPump.encerrante_final,
          preco_liquido: supplyPump.total,
          valor_desconto: 0,
          valor_acrescimo: 0,
          encerrante_inicial: supplyPump.encerrante_inicial,
          preco_bruto: supplyPump.unitario,
          total_bruto: supplyPump.total,
        ),
      );
    }

    count++;
    return itens;
  }

  // adiciona os itens com base nos produtos que estão no carrinho
  @override
  List<SellItem> getProductItem() {
    List<SellItem> items = [];

    for (var item in _billController.cartShopping) {
      if (item.productAndQuantity == null) continue;

      ProductAndQuantityModel productAndQuantity = item.productAndQuantity!;

      double totBruto =
          productAndQuantity.product!.valor! * productAndQuantity.quantity!;

      items.add(
        SellItem(
          produto_id: productAndQuantity.product!.codigo,
          sequencia: count,
          quantidade: productAndQuantity.quantity!.toDouble(),
          total_liquido: totBruto,
          tanque_id: 0,
          bico_id: 0,
          abastecimento_id: 0,
          encerrante_final: 0,
          preco_liquido: productAndQuantity.product!.valor,
          valor_desconto: 0,
          valor_acrescimo: 0,
          encerrante_inicial: 0,
          preco_bruto: productAndQuantity.product!.valor,
          total_bruto: totBruto,
        ),
      );

      count++;
    }

    return items;
  }

  @override
  List<PaymentFormSelected> getPaymentFormSelected() {
    List<PaymentFormSelected> list = [];

    for (var item in _paymentController.listPaymentsSelected) {
      list.add(PaymentFormSelected(
          tipoDocto: item.tipoDocto ?? '',
          num_parcela: item.numParcela!,
          data_vencimento: _convertToIso8601(item.dataVencimento!),
          valor_parcela: item.valorParcela!,
          dadosCartao: item.dadosCartao ?? PaymentCartaoModel(),
          dadosPix: item.dadosPix ?? PaymentPixModel()));
    }
    return list;
  }

  // Total nota = total produtos e abastecimentos + acrescimos - desconto
  void _addTotalNota() {
    for (var item in _billController.cartShopping) {
      if (item.supplyPump == null) continue;

      totalNota += item.supplyPump!.total!; // colocar descontos e acrescimos
    }

    if (_booleanMethods.isProductEmpty()) return;

    for (var item in _billController.cartShopping) {
      if (item.productAndQuantity == null) continue;

      totalNota += item.productAndQuantity!.product!.valor! *
          item.productAndQuantity!.quantity!; // colocar descontos e acrescimos
    }
  }

  // Total dos produtos sem desconto e acrescimos
  void _addTotalProduct() {
    for (var item in _billController.cartShopping) {
      if (item.supplyPump == null) continue;

      totalProduct += item.supplyPump!.total!;
    }

    if (_booleanMethods.isProductEmpty()) return;

    for (var item in _billController.cartShopping) {
      if (item.productAndQuantity == null) continue;

      totalProduct += item.productAndQuantity!.product!.valor! *
          item.productAndQuantity!.quantity!;
    }
  }

  String _convertToIso8601(String dateStr) {
    DateFormat originalFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = originalFormat.parse(dateStr);
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateTime.toUtc());
  }
}
