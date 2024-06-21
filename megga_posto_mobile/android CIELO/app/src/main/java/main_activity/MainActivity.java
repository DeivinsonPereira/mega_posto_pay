package com.example.megga_posto_mobile;

import android.content.Context;
import io.flutter.plugin.common.BinaryMessenger;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;
import android.widget.Toast;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import cielo.orders.domain.CheckoutRequest;
import cielo.orders.domain.CheckoutRequest.*;
import cielo.orders.domain.Credentials;
import cielo.orders.domain.Order;

import cielo.sdk.order.OrderManager;
import cielo.orders.domain.CancellationRequest;
import cielo.sdk.order.cancellation.CancellationListener;
import cielo.sdk.order.PrinterListener;
import cielo.sdk.order.ServiceBindListener;
import cielo.sdk.order.payment.PaymentCode;
import cielo.sdk.order.payment.Payment;
import cielo.sdk.order.payment.PaymentError;
import cielo.sdk.order.payment.PaymentListener;
import cielo.sdk.printer.PrinterManager;
import cielo.orders.domain.PrinterAttributes;

import java.util.UUID;
import java.util.List;
import java.util.HashMap;

import android.graphics.Color;
import android.graphics.Paint;

import com.github.danielfelgar.drawreceiptlib.ReceiptBuilder;
import com.google.gson.Gson ;
import com.google.gson.reflect.TypeToken;

import android.graphics.Bitmap;
import java.io.ByteArrayInputStream;
import android.graphics.BitmapFactory;
import androidx.annotation.NonNull;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.pagamento";

    private MethodChannel.Result callResult;
    private OrderManager orderManager;
    private boolean orderManagerServiceBinded = false;
    private PrinterManager printerManager;
    private PrinterListener printerListener;
    private CheckoutRequest requestBuilder;

    private BinaryMessenger getFlutterView() {
        return getFlutterEngine().getDartExecutor().getBinaryMessenger();
    }

    private void configSDK(Context context) {
        MethodChannel _channel = new MethodChannel(getFlutterView(), "com.pagamento.return");
        Credentials credentials = new Credentials(
                "RQ3KRmLDUWaBSAE4bXnnFvz67hd4qVy3NkVXtmTKm7FL9tI8jx",
                "D2qbchgucsRyCBjUUeAfViKyCjKdmyko41zTFXbjCEYec7i60G"
        );
        orderManager = new OrderManager(credentials, context);
        orderManager.bind(context, new ServiceBindListener() {
            @Override
            public void onServiceBoundError(@NonNull Throwable throwable) {
                orderManagerServiceBinded = false;
                Toast.makeText(
                        context,
                        "Erro fazendo bind do serviço de ordem -> " + throwable.getMessage(),
                        Toast.LENGTH_LONG
                ).show();
            }

            @Override
            public void onServiceBound() {
                orderManagerServiceBinded = true;
                orderManager.createDraftOrder("REFERENCIA DA ORDEM");
            }

            @Override
            public void onServiceUnbound() {
                orderManagerServiceBinded = false;
            }
        });
        printerManager = new PrinterManager(context);
        printerListener = new PrinterListener() {
            @Override
            public void onWithoutPaper() {
                Log.d("PrintSampleActivity", "printer without paper");
                _channel.invokeMethod("smart_print_return", "sempapel");
            }

            @Override
            public void onError(Throwable e) {
                if (e != null) {
                    Log.d("PrintSampleActivity", "printer error -> " + e.getMessage());
                }
                _channel.invokeMethod("smart_print_return", "error");
            }

            @Override
            public void onPrintSuccess() {
                Log.d("PrintSampleActivity", "print success!");
                _channel.invokeMethod("smart_print_return", "sucess");
            }
        };
    }

    private Bitmap CriarTarja(String texto, String align, float size) {
        ReceiptBuilder receipt = new ReceiptBuilder(380);

        receipt.setMarginLeft(0);
        receipt.setMarginRight(0);
        receipt.setMarginTop(1);
        receipt.setMarginBottom(10);
        if (align.equals("C")) {
            receipt.setAlign(Paint.Align.CENTER);
        } else if (align.equals("L")) {
            receipt.setAlign(Paint.Align.LEFT);
        } else if (align.equals("R")) {
            receipt.setAlign(Paint.Align.RIGHT);
        }

        receipt.setBackgroudColor(Color.BLACK)
                .setColor(Color.WHITE)
                .setTypeface(this, "fonts/RobotoMono-Bold.ttf")
                .setTextSize(size)
                .addText(texto);
        return receipt.build();
    }

    private void onPrint(String json) {
        ReceiptBuilder receipt = new ReceiptBuilder(380);

        receipt.setMargin(25, 1)
                .setAlign(Paint.Align.CENTER)
                .setColor(Color.BLACK)
                .setTextSize(19f);

        List<Item> jsonData = new Gson().fromJson(json, new TypeToken<List<Item>>() { }.getType());
        float sizeFonteUltimo = 0f;

        for (Item item : jsonData) {
            if (!item.font.isEmpty()) {
                receipt.setTypeface(this, item.font);
            }
            if (item.fontSize > 0) {
                receipt.setTextSize(item.fontSize);
                sizeFonteUltimo = item.fontSize;
            }

            switch (item.type) {
                case "TX":
                case "QR":
                case "TJ":
                    switch (item.align) {
                        case "L":
                            receipt.setAlign(Paint.Align.LEFT);
                            break;
                        case "R":
                            receipt.setAlign(Paint.Align.RIGHT);
                            break;
                        case "C":
                            receipt.setAlign(Paint.Align.CENTER);
                            break;
                    }
                    if (item.type.equals("TX")) {
                        receipt.addText(item.texto, item.pularLinha);
                    } else if (item.type.equals("QR")) {
                        receipt.addImage(QRCodeUtil.encodeAsBitmap(item.texto, 450, 350));
                    } else if (item.type.equals("TJ")) {
                        receipt.addImage(CriarTarja(item.texto, item.align, sizeFonteUltimo));
                        receipt.addParagraph();
                    }
                    break;
                case "LI":
                    receipt.addLine();
                    break;
                case "PA":
                    receipt.addParagraph();
                    break;
                case "ES":
                    receipt.addBlankSpace(20);
                    break;
            }
        }

        onPrintBitmap(receipt.build());
    }

    private void onCancelamento(Context context, String orderid, String authCode, String cieloCode, int valor) {
        MethodChannel _channel = new MethodChannel(getFlutterView(), "DATA_RETURN");

        CancellationRequest requestBuilder = new CancellationRequest.Builder()
                .orderId(orderid)
                .authCode(authCode)
                .cieloCode(cieloCode)
                .value((long) valor)
                .build();

        orderManager.cancelOrder(requestBuilder, new CancellationListener() {
            @Override
            public void onCancel() {
                Log.d("SDKClient", "ON CANCEL");
            }

            @Override
            public void onError(@NonNull PaymentError error) {
                Log.d("SDKClient", "ON CANCEL");
            }

            @Override
            public void onSuccess(@NonNull Order cancelledOrder) {
                Log.d("SDKClient", "ON CANCEL");

                String jsonString = new Gson().toJson(cancelledOrder);
                _channel.invokeMethod("cancel_return", jsonString);
            }
        });
    }

    private void onPagamento(Context context, int valor, int parcela, int tipoTransacao) {
        MethodChannel _channel = new MethodChannel(getFlutterView(), "DATA_RETURN");

        String numeroPedido = UUID.randomUUID().toString();
        Order order = orderManager.createDraftOrder(numeroPedido);
        String sku = "1";
        String name = "CONSUMO";
        int quantity = 1;
        String unityOfMeasure = "UNIDADE";

        order.addItem(sku, name, (long) valor, quantity, unityOfMeasure);
        orderManager.placeOrder(order);

        switch (tipoTransacao) {
            case 1:
                if (parcela > 1) {
                    requestBuilder = new CheckoutRequest.Builder()
                            .orderId(order.getId())
                            .amount((long) valor)
                            .installments(parcela)
                            .paymentCode(PaymentCode.CREDITO_PARCELADO_LOJA)
                            .build();
                } else {
                    requestBuilder = new CheckoutRequest.Builder()
                            .orderId(order.getId())
                            .amount((long) valor)
                            .paymentCode(PaymentCode.CREDITO_AVISTA)
                            .build();
                }
                break;
            case 2:
                requestBuilder = new CheckoutRequest.Builder()
                        .orderId(order.getId())
                        .amount((long) valor)
                        .paymentCode(PaymentCode.DEBITO_AVISTA)
                        .build();
                break;
            case 3:
                requestBuilder = new CheckoutRequest.Builder()
                        .orderId(order.getId())
                        .amount((long) valor)
                        .paymentCode(PaymentCode.PIX)
                        .build();
                break;
            case 10:
                requestBuilder = new CheckoutRequest.Builder()
                        .orderId(order.getId())
                        .amount((long) valor)
                        .paymentCode(PaymentCode.VOUCHER_ALIMENTACAO)
                        .build();
                break;
            case 20:
                requestBuilder = new CheckoutRequest.Builder()
                        .orderId(order.getId())
                        .amount((long) valor)
                        .paymentCode(PaymentCode.VOUCHER_REFEICAO)
                        .build();
                break;
            default:
                // Lógica para outro tipo de transação
                break;
        }

        orderManager.checkoutOrder(requestBuilder, new PaymentListener() {
            @Override
            public void onStart() {
                Log.d("SDKClient", "ON START");
            }

            @Override
            public void onCancel() {
                Log.d("SDKClient", "ON START");
            }

            @Override
            public void onError(@NonNull PaymentError error) {
                Log.d("SDKClient", "ON START");
            }

            @Override
            public void onPayment(@NonNull Order order) {
                Log.d("SDKClient", "ON PAYMENT");
                Payment ultimoPagamentoEfetuado = order.getPayments().get(0);
                Log.d("SDKClient", ultimoPagamentoEfetuado.getAuthCode());

                String jsonString = new Gson().toJson(order);
                Log.d("SDKClient", jsonString);
                _channel.invokeMethod("pgto_return", jsonString);
            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        configSDK(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "pagamento":
                    onPagamento(this,
                            call.argument("amount"),
                            call.argument("parcela"),
                            call.argument("typetransacao")
                    );
                    callResult = result;
                    break;
                case "cancelamento":
                    onCancelamento(this,
                            call.argument("orderid"),
                            call.argument("autcode"),
                            call.argument("cielocode"),
                            call.argument("amount")
                    );
                    callResult = result;
                    break;
                case "print":
                    onPrint(call.argument("json"));
                    callResult = result;
                    break;
                case "print_img":
                    byte[] byteArray = call.argument("img");
                    Bitmap bitmap = toBitmap(byteArray);
                    onPrintBitmap(bitmap);
                    callResult = result;
                    break;
            }
        });
    }

    private Bitmap toBitmap(byte[] byteArray) {
        ByteArrayInputStream inputStream = new ByteArrayInputStream(byteArray);
        return BitmapFactory.decodeStream(inputStream);
    }

    private void onPrintBitmap(Bitmap bitmap) {
        HashMap<String, Integer> alignCenter = new HashMap<>();

        BitmapProcessor.processBitmapForPrint(bitmap, processedBitmap -> {
            printerManager.printImage(processedBitmap, alignCenter, printerListener);
        });
    }

    public static class Item {
        String type;
        String texto;
        float fontSize;
        String font;
        String align;
        boolean pularLinha;
        // getters and setters
    }
}
