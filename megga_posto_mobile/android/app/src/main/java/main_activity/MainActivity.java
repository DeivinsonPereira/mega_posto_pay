package com.example.megga_posto_mobile;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;

import java.io.IOException;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.gson.Gson;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

import android.Manifest;

import android.util.Log;

import br.com.gertec.gedi.exceptions.GediException;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.hardware.Camera.Parameters.FLASH_MODE_ON;

public class MainActivity extends FlutterActivity {
    private com.example.megga_posto_mobile.GertecPrinter gertecPrinter;
    public static final String G700 = "GPOS700";
    private MethodChannel.Result _result; // Instanciando uma variavel do tipo Result, para enviar o resultado para o
    // flutter
    public static String Model = Build.MODEL;
    private String resultado_Leitor; // Instanciando uma variavel que vai armazenar o resultado ao ler o codigo de
    // Barras no V1
    private IntentIntegrator qrScan;
    private String tipo; // Armazerna o tipo de codigo de barra que ser lido
    private ArrayList<String> arrayListTipo;
    private static final String CHANNEL = "samples.flutter.dev/gedi"; // Canal de comunicação do flutter com o Java
    private com.example.megga_posto_mobile.ConfigPrint configPrint = new com.example.megga_posto_mobile.ConfigPrint();
    private com.example.megga_posto_mobile.SatLib satLib;
    private static final int REQUEST_CAMERA_PERMISSION = 200;
    Intent intentGer7 = new Intent(Intent.ACTION_VIEW, Uri.parse("pos7api://pos7")); // Instanciando o Intent da Ger7 --
    // É importante que o apk da Ger7
    // esteje instalado na POS
    Intent intentSitef = new Intent("br.com.softwareexpress.sitef.msitef.ACTIVITY_CLISITEF"); // Instanciando o Intent
    // do M-Sitef -- É
    // importante que o
    // programa "Sitef Demo"
    // esteja em execução.
    Gson gson = new Gson();

    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        gertecPrinter.setConfigImpressao(configPrint);

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, REQUEST_CAMERA_PERMISSION);
        }
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CAMERA_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permissão concedida, você pode prosseguir com outras tarefas
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        satLib = new com.example.megga_posto_mobile.SatLib(this); // Instancia uma variavel da classe SatLib, que possui todas as funções para
        // envio de ações para o Sat.
        gertecPrinter = new com.example.megga_posto_mobile.GertecPrinter(this);
    }

    public MainActivity() {
        super();
        this.arrayListTipo = new ArrayList<String>();
    }

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    _result = result;
                    Map<String, String> map;
                    Bundle bundle = new Bundle();
                    Intent intent = null;
                    switch (call.method) {
                        // Inicia o intent que vai fazer a leitura do Nfc pelo metodo Nativo
                        case "lernfcid":
                            try {
                                intent = new Intent(this, com.example.megga_posto_mobile.LeitorNFC.class);
                                intent.putExtra("tipoleitura", "NFC ID");
                                startActivityForResult(intent, 109);
                            } catch (Exception e) {
                                e.printStackTrace();
                                result.notImplemented();
                            }
                            break;
                        // Inicia o intent que vai fazer a leitura do Nfc pelo metodo Gedi
                        case "lernfcgedi":
                            try {
                                intent = new Intent(this, com.example.megga_posto_mobile.NfcGedi.class);
                                intent.putExtra("tipoleitura", "NFC GEDI");
                                startActivityForResult(intent, 108);
                            } catch (Exception e) {
                                result.notImplemented();
                            }
                            break;
                        // Verifica o status da impressora
                        case "checarImpressora":
                            try {
                                gertecPrinter.getStatusImpressora();
                                result.success(gertecPrinter.isImpressoraOK());
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            break;
                        // Inicia a função que vai abrir o leitor de codigo de barra
                        // Do flutter ele vai pegar o "tipo" de codigo que deseja ser lido
                        case "leitorCodigov1":
                            try {
                                tipo = call.argument("tipoLeitura");
                                startCamera();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            break;
                        // Verifica qual ação do Sat foi solicitada e retorna o codigo de resposta da
                        // Sefaz
                        // "satLib" possui todas funções do Sat
                        case "AtivarSAT":
                            _result.success(satLib.ativarSat(call.argument("codigoAtivar"),
                                    call.argument("cnpj"), call.argument("random")));
                            break;
                        case "AssociarSAT":
                            _result.success(satLib.associarSat(call.argument("cnpj"), call.argument("cnpjSoft"),
                                    call.argument("codigoAtivar"), call.argument("assinatura"),
                                    call.argument("random")));
                            break;
                        case "ConsultarSat":
                            _result.success(satLib.consultarSat(call.argument("random")));
                            break;
                        case "ConsultarStatusOperacional":
                            String a = call.argument("codigoAtivar");
                            int b = call.argument("random");
                            _result.success(satLib.consultarStatusOperacional(call.argument("random"),
                                    call.argument("codigoAtivar")));
                            break;
                        case "EnviarTesteFim":
                            _result.success(satLib.enviarTesteFim(call.argument("codigoAtivar"),
                                    call.argument("xmlVenda"), call.argument("random")));
                            break;
                        case "EnviarTesteVendas":
                            _result.success(satLib.enviarTesteVendas(call.argument("codigoAtivar"),
                                    call.argument("xmlVenda"), call.argument("random")));
                            break;
                        case "CancelarUltimaVenda":
                            _result.success(satLib.cancelarUltimaVenda(call.argument("codigoAtivar"),
                                    call.argument("xmlCancelamento"), call.argument("chaveCancelamento"),
                                    call.argument("random")));
                            break;
                        case "ConsultarNumeroSessao":
                            _result.success(satLib.consultarNumeroSessao(call.argument("codigoAtivar"),
                                    call.argument("chaveSessao"), call.argument("random")));
                            break;
                        case "EnviarConfRede":
                            try {
                                _result.success(satLib.enviarConfRede(call.argument("random"),
                                        call.argument("dadosXml"), call.argument("codigoAtivar")));
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            break;
                        case "TrocarCodAtivacao":
                            _result.success(
                                    satLib.trocarCodAtivacao(call.argument("codigoAtivar"), call.argument("op"),
                                            call.argument("codigoAtivacaoNovo"), call.argument("random")));
                            break;
                        case "BloquearSat":
                            _result.success(
                                    satLib.bloquearSat(call.argument("codigoAtivar"), call.argument("random")));
                            break;
                        case "DesbloquearSat":
                            _result.success(satLib.desbloquearSat(call.argument("codigoAtivar"),
                                    call.argument("random")));
                            break;
                        case "ExtrairLog":
                            _result.success(
                                    satLib.extrairLog(call.argument("codigoAtivar"), call.argument("random")));
                            break;
                        case "AtualizarSoftware":
                            _result.success(satLib.atualizarSoftware(call.argument("codigoAtivar"),
                                    call.argument("random")));
                            break;
                        case "Versao":
                            _result.success(satLib.versao());
                            break;
                        // Inicia o intent que vai fazer a leitura do codigo de barras v2
                        // Ler qualquer tipo de codigo de barra
                        case "leitorCodigoV2":
                            intent = new Intent(this, com.example.megga_posto_mobile.CodigoBarrasV2.class);
                            startActivity(intent);
                            break;
                        // Inicia o intent que vai enviar o Json recebido do flutter para o Ger7 e após
                        // isto pegar seu retorno (Json)
                        case "realizarAcaoGer7":
                            String json = call.argument("json");
                            intentGer7.putExtra("jsonReq", json);
                            startActivityForResult(intentGer7, 4713);
                            break;
                        // Inicia o intent que vai enviar o Map recebido do flutter para o M-Sitef e
                        // após isto pegar seu retorno
                        case "realizarAcaoMsitef":
                            map = call.argument("mapMsiTef");
                            for (String key : map.keySet()) {
                                bundle.putString(key, map.get(key));
                            }
                            intentSitef.putExtras(bundle);
                            startActivityForResult(intentSitef, 4321);
                            break;
                        // Esta função vai chamar as classes para realizar as impressões de acordo com
                        // as configurações recebidas do flutter
                        case "fimimpressao":
                            try {
                                gertecPrinter.ImpressoraOutput();
                                result.success("Finalizou impressao");
                            } catch (GediException e) {
                                e.printStackTrace();
                            }
                            break;
                        case "avancaLinha":
                            try {
                                gertecPrinter.avancaLinha( (int) call.argument("quantLinhas"));
                            } catch (GediException e) {
                                e.printStackTrace();
                            }
                            break;
                        case "imprimir":
                            try {
                                String status = gertecPrinter.getStatusImpressora();
                                Log.d("imprimir", status.toString());
                                if(!gertecPrinter.isImpressoraOK()) {
                                    result.error("IMPRESSORA_NAO_OK", "Status da impressora: " + status, null);
                                    break;
                                }else {
                                    String tipoImpressao = call.argument("tipoImpressao");
                                    String mensagem = call.argument("mensagem");
                                    switch (tipoImpressao) {
                                        case "Texto":
                                           List<Boolean> options = call.argument("options");
                                            configPrint.setItalico(options.get(1));
                                            configPrint.setSublinhado(options.get(2));
                                            System.out.println(call.argument("size").toString());
                                            configPrint.setNegrito(options.get(0));
                                            System.out.println(call.argument("font").toString());
                                            configPrint.setTamanho(call.argument("size"));
                                            configPrint.setFonte(call.argument("font"));
                                            configPrint.setAlinhamento(call.argument("alinhar"));
                                            gertecPrinter.setConfigImpressao(configPrint);
                                            gertecPrinter.imprimeTexto(mensagem);
                                            //gertecPrinter.avancaLinha(50);
                                            break;
                                        case "Imagem":
                                            configPrint.setiWidth(400);
                                            configPrint.setiHeight(400);
                                            gertecPrinter.setConfigImpressao(configPrint);
                                            String imagemBMP = call.argument("imagemBMP");
                                            if (imagemBMP != null && !imagemBMP.isEmpty()) {
                                                try {
                                                    gertecPrinter.imprimeImagem(imagemBMP);
                                                } catch (Exception e) {
                                                    System.err.println("Erro ao imprimir a imagem: " + e.getMessage());
                                                }
                                            } else {
                                                System.err.println("Erro: Imagem Base64 inválida ou vazia.");
                                            }
                                            break;
                                        case "imprimeImageByPDF":
                                            configPrint.setItalico(false);
                                            configPrint.setNegrito(true);
                                            configPrint.setTamanho(20);
                                            configPrint.setFonte("MONOSPACE");
                                            gertecPrinter.setConfigImpressao(configPrint);
                                            int sizeHeight = call.argument("sizeHeight");
                                            configPrint.setiWidth(300);
                                            configPrint.setiHeight(sizeHeight);
                                            configPrint.setAlinhamento("CENTER");
                                            gertecPrinter.setConfigImpressao(configPrint);
                                            byte[] imagem = call.argument("imagemBMP");
                                            if (imagem != null && imagem.length > 0) {
                                                gertecPrinter.imprimeImagemByPDF(imagem);
                                            } else {
                                                System.err.println("Erro: Imagem BMP inválida ou vazia.");
                                            }
                                            break;
                                        case "TodasFuncoes":
                                            ImprimeTodasAsFucoes();
                                            break;
                                        case "printPixQrCode":
                                            printPixQrCode(call.argument("pix"), call.argument("initDate"), call.argument("dueDate"), call.argument("value"));
                                            break;
                                        case "printNfce":
                                            printNfce(call.argument("text1"), call.argument("text2"), call.argument("text3"), call.argument("qrCode"), call.argument("text4"));
                                            break;
                                        case "printCashRegister":
                                            printCashRegister(call.argument("text1"), call.argument("text2"), call.argument("text3")); 
                                            break;    
                                    }
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            break;
                        case "getSerialNumber":
                            String serialNumber = android.os.Build.SERIAL;
                            if (serialNumber != null) {
                                result.success(serialNumber);
                            } else {
                                result.error("UNAVAILABLE", "Serial number not available.", null);
                            }
                        break;

                    }
                });
    }

    private void printCashRegister(String text1, String text2, String text3){
        try{
            String statusImpressora = gertecPrinter.getStatusImpressora();
            if (!gertecPrinter.isImpressoraOK()) {
                Log.e("printPixQrCode", "Status da impressora não é OK: " + statusImpressora);
                _result.error("IMPRESSORA_NAO_OK", "Status da impressora: " + statusImpressora, null);
                return;
            }
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto(text1);
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeTexto(text2);
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeTexto(text3);
            gertecPrinter.avancaLinha(10);
            gertecPrinter.avancaLinha(40);

            _result.success("Impressão realizada com sucesso");

        } catch (Exception e) {
            Log.e("printPixQrCode", "Erro de impressão: " + e.getMessage());
            _result.error("ERRO_IMPRESSAO", "Erro ao imprimir: " + e.getMessage(), null);
        }
    }

    private void printNfce(String text1, String text2, String text3, String qrCode, String text4){
        try {
            String statusImpressora = gertecPrinter.getStatusImpressora();
            if (!gertecPrinter.isImpressoraOK()) {
                Log.e("printPixQrCode", "Status da impressora não é OK: " + statusImpressora);
                _result.error("IMPRESSORA_NAO_OK", "Status da impressora: " + statusImpressora, null);
                return;
            }
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(24);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto(text1);
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeTexto(text2);
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeTexto(text3);
            gertecPrinter.avancaLinha(10);

            gertecPrinter.imprimeBarCode(qrCode, 350, 350, "QR_CODE");
            gertecPrinter.avancaLinha(10);

            gertecPrinter.imprimeTexto(text4);
            gertecPrinter.avancaLinha(10);


            gertecPrinter.imprimeTexto("\n\n\n\n\n");

            gertecPrinter.avancaLinha(40);

            _result.success("Impressão realizada com sucesso");
        } catch (GediException e) {
            Log.e("printPixQrCode", "Erro de impressão: " + e.getMessage());
            _result.error("ERRO_IMPRESSAO", "Erro ao imprimir: " + e.getMessage(), null);
        } catch (Exception e) {
            Log.e("printPixQrCode", "Erro desconhecido: " + e.getMessage());
            _result.error("ERRO_DESCONHECIDO", "Erro desconhecido: " + e.getMessage(), null);
        } 

    }

    // imprime o QrCode do pix
    private void printPixQrCode(String pix, String initDate, String dueDate, String value) {
        try{
            
            String statusImpressora = gertecPrinter.getStatusImpressora();
            if (!gertecPrinter.isImpressoraOK()) {
                Log.e("printPixQrCode", "Status da impressora não é OK: " + statusImpressora);
                _result.error("IMPRESSORA_NAO_OK", "Status da impressora: " + statusImpressora, null);
                return;
            }
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(30);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("ESCANEIE O CÓDIGO QRCODE PARA EFETUAR O PAGAMENTO:");
            gertecPrinter.avancaLinha(10);
            
            configPrint.setAlinhamento("CENTER");
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeBarCode(pix, 350, 350, "QR_CODE");
            gertecPrinter.avancaLinha(10);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(30);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("INICIO: \n" + initDate);
            gertecPrinter.avancaLinha(1);
            gertecPrinter.imprimeTexto("VENCIMENTO: \n" + dueDate);
            gertecPrinter.avancaLinha(1);
            gertecPrinter.imprimeTexto("VALOR: " + value);
            gertecPrinter.avancaLinha(1);

            gertecPrinter.imprimeTexto("\n\n\n\n\n\n");
            gertecPrinter.avancaLinha(40);

            _result.success("Impressão realizada com sucesso");
        } catch (GediException e) {
            Log.e("printPixQrCode", "Erro de impressão: " + e.getMessage());
            _result.error("ERRO_IMPRESSAO", "Erro ao imprimir: " + e.getMessage(), null);
        } catch (Exception e) {
            Log.e("printPixQrCode", "Erro desconhecido: " + e.getMessage());
            _result.error("ERRO_DESCONHECIDO", "Erro desconhecido: " + e.getMessage(), null);
        } 
    }


    private void startCamera() {
        this.arrayListTipo.add(tipo);
        qrScan = new IntentIntegrator(this);
        qrScan.setPrompt("Digitalizar o código " + tipo);
        qrScan.setBeepEnabled(true);
        qrScan.setBarcodeImageEnabled(true);
        qrScan.setTimeout(30000); // 30 * 1000 => 3 minuto
        qrScan.addExtra("FLASH_MODE_ON", FLASH_MODE_ON);
        qrScan.setDesiredBarcodeFormats(this.arrayListTipo);
        qrScan.initiateScan();
    }

    private void ImprimeTodasAsFucoes() {

        configPrint.setItalico(false);
        configPrint.setNegrito(true);
        configPrint.setTamanho(20);
        configPrint.setFonte("MONOSPACE");
        gertecPrinter.setConfigImpressao(configPrint);

        try {
            gertecPrinter.getStatusImpressora();
            // Imprimindo Imagem
            configPrint.setiWidth(300);
            configPrint.setiHeight(130);
            configPrint.setAlinhamento("CENTER");
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("==[Iniciando Impressao Imagem]==");
            //gertecPrinter.imprimeImagem("logogertec");
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeTexto("====[Fim Impressão Imagem]====");
            gertecPrinter.avancaLinha(10);
            // Fim Imagem

            // Impressão Centralizada
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(30);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("CENTRALIZADO");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Centralizada

            // Impressão Esquerda
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(40);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("ESQUERDA");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Esquerda

            // Impressão Direita
            configPrint.setAlinhamento("RIGHT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("DIREITA");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Direita

            // Impressão Negrito
            configPrint.setNegrito(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=======[Escrita Netrigo]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Negrito

            // Impressão Italico
            configPrint.setNegrito(false);
            configPrint.setItalico(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=======[Escrita Italico]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Italico

            // Impressão Italico
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("======[Escrita Sublinhado]=====");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Italico

            // Impressão BarCode 128
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(false);
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("====[Codigo Barras CODE 128]====");
            gertecPrinter.imprimeBarCode("12345678901234567890", 120, 120, "CODE_128");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão BarCode 128

            // Impressão Normal
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=======[Escrita Normal]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Normal

            // Impressão Normal
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(true);
            configPrint.setAlinhamento("LEFT");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=========[BlankLine 50]=========");
            gertecPrinter.avancaLinha(50);
            gertecPrinter.imprimeTexto("=======[Fim BlankLine 50]=======");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão Normal

            // Impressão BarCode 13
            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(false);
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("=====[Codigo Barras EAN13]=====");
            gertecPrinter.imprimeBarCode("7891234567895", 120, 120, "EAN_13");
            gertecPrinter.avancaLinha(10);
            // Fim Impressão BarCode 128

            // Impressão BarCode 13
            gertecPrinter.setConfigImpressao(configPrint);
            gertecPrinter.imprimeTexto("===[Codigo QrCode Gertec LIB]==");
            gertecPrinter.avancaLinha(10);
            gertecPrinter.imprimeBarCode("Gertec Developer Partner LIB", 240, 240, "QR_CODE");

            configPrint.setNegrito(false);
            configPrint.setItalico(false);
            configPrint.setSublinhado(false);
            configPrint.setAlinhamento("CENTER");
            configPrint.setTamanho(20);
            gertecPrinter.imprimeTexto("===[Codigo QrCode Gertec IMG]==");
            gertecPrinter.imprimeBarCodeIMG("Gertec Developer Partner IMG", 240, 240, "QR_CODE");

            gertecPrinter.avancaLinha(40);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // O M-Sitef não retorna um json como resposta, logo é criado um json com a
    // reposta do Sitef.
    public String respSitefToJson(Intent data) throws JSONException {
        JSONObject json = new JSONObject();
        json.put("CODRESP", data.getStringExtra("CODRESP"));
        json.put("COMP_DADOS_CONF", data.getStringExtra("COMP_DADOS_CONF"));
        json.put("CODTRANS", data.getStringExtra("CODTRANS"));
        json.put("VLTROCO", data.getStringExtra("VLTROCO"));
        json.put("REDE_AUT", data.getStringExtra("REDE_AUT"));
        json.put("BANDEIRA", data.getStringExtra("BANDEIRA"));
        json.put("NSU_SITEF", data.getStringExtra("NSU_SITEF"));
        json.put("NSU_HOST", data.getStringExtra("NSU_HOST"));
        json.put("COD_AUTORIZACAO", data.getStringExtra("COD_AUTORIZACAO"));
        json.put("NUM_PARC", data.getStringExtra("NUM_PARC"));
        json.put("TIPO_PARC", data.getStringExtra("TIPO_PARC"));
        // Quando passa esta informação para o flutter os break lines são perdidos logo
        // é necessario para outro dado para representar no caso %%
        json.put("VIA_ESTABELECIMENTO", data.getStringExtra("VIA_ESTABELECIMENTO"));
        json.put("VIA_CLIENTE", data.getStringExtra("VIA_CLIENTE"));
        return json.toString();
    }

    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        // Pega os resultados obtidos dos intent e envia para o flutter
        // ("_result.success")

        if (requestCode == 109) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("codigoNFCID"));
            } else {
                _result.notImplemented();
            }
        } else if (requestCode == 108) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("codigoNFCGEDI"));
            } else {
                _result.notImplemented();
            }
        } else if (requestCode == 4713) {
            if (resultCode == RESULT_OK && data != null) {
                _result.success(data.getStringExtra("jsonResp"));
            } else {
                _result.notImplemented();
            }
        } else if (requestCode == 4321) {
            if (resultCode == RESULT_OK || resultCode == RESULT_CANCELED && data != null) {
                try {
                    _result.success(respSitefToJson(data));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            } else {
                _result.notImplemented();
            }
        } else {
            IntentResult intentResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
            if (intentResult != null) {
                if (intentResult.getContents() == null) {
                    resultado_Leitor = (this.tipo + ": Não foi possível ler o código.\n");
                } else {
                    try {
                        resultado_Leitor = this.tipo + ": " + intentResult.getContents() + "\n";
                    } catch (Exception e) {
                        e.printStackTrace();
                        resultado_Leitor = this.tipo + ": Erro " + e.getMessage() + "\n";
                    }
                }
            } else {
                super.onActivityResult(requestCode, resultCode, data);
                resultado_Leitor = this.tipo + ": Não foi possível fazer a leitura.\n";
            }
            _result.success(resultado_Leitor);
            this.arrayListTipo.clear();
        }
    }
}