import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CredentialPix {
  int? id;
  int? ambiente;
  int? psp;
  String? chavePix;
  String? clientId;
  String? clientSecret;
  String? apiKey;
  int? tipoChave;
  String? pathArquivoCertificado;
  String? senhaCertificado;
  String? pathArquivoChavePrivada;
  String? urlBaseHomologacao;
  String? urlBaseProducao;
  String? token;
  
  CredentialPix({
    this.id,
    this.ambiente,
    this.psp,
    this.chavePix,
    this.clientId,
    this.clientSecret,
    this.apiKey,
    this.tipoChave,
    this.pathArquivoCertificado,
    this.senhaCertificado,
    this.pathArquivoChavePrivada,
    this.urlBaseHomologacao,
    this.urlBaseProducao,
    this.token,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ambiente': ambiente,
      'psp': psp,
      'chavePix': chavePix,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'apiKey': apiKey,
      'tipoChave': tipoChave,
      'pathArquivoCertificado': pathArquivoCertificado,
      'senhaCertificado': senhaCertificado,
      'pathArquivoChavePrivada': pathArquivoChavePrivada,
      'urlBaseHomologacao': urlBaseHomologacao,
      'urlBaseProducao': urlBaseProducao,
      'token': token,
    };
  }

  factory CredentialPix.fromMap(Map<String, dynamic> map) {
    return CredentialPix(
      id: map['ID'] != null ? map['ID'] as int : null,
      ambiente: map['AMBIENTE'] != null ? map['AMBIENTE'] as int : null,
      psp: map['PSP'] != null ? map['PSP'] as int : null,
      chavePix: map['CHAVE_PIX'] != null ? map['CHAVE_PIX'] as String : null,
      clientId: map['CLIENT_ID'] != null ? map['CLIENT_ID'] as String : null,
      clientSecret: map['CLIENT_SECRET'] != null ? map['CLIENT_SECRET'] as String : null,
      apiKey: map['API_KEY'] != null ? map['API_KEY'] as String : null,
      tipoChave: map['TIPO_CHAVE'] != null ? map['TIPO_CHAVE'] as int : null,
      pathArquivoCertificado: map['PATH_ARQUIVO_CERTIFICADO'] != null ? map['PATH_ARQUIVO_CERTIFICADO'] as String : null,
      senhaCertificado: map['SENHA_CERTIFICADO'] != null ? map['SENHA_CERTIFICADO'] as String : null,
      pathArquivoChavePrivada: map['PATH_ARQUIVO_CHAVE_PRIVADA'] != null ? map['PATH_ARQUIVO_CHAVE_PRIVADA'] as String : null,
      urlBaseHomologacao: map['URLBASE_HOMOLOGACAO'] != null ? map['URLBASE_HOMOLOGACAO'] as String : null,
      urlBaseProducao: map['URLBASE_PRODUCAO'] != null ? map['URLBASE_PRODUCAO'] as String : null,
      token: map['TOKEN_PIX'] != null ? map['TOKEN_PIX'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CredentialPix.fromJson(String source) => CredentialPix.fromMap(json.decode(source) as Map<String, dynamic>);
}
