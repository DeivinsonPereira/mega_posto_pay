// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:megga_posto_mobile/model/credential_tef_model.dart';

import 'credential_pix_model.dart';

class DataPos {
  int? id;
  int? pdvPrincipalId;
  int? setorId;
  String? serial;
  String? nomeDispositivo;
  int? clientePadraoId;
  int? atendentePadraoId;
  int? idContaCaixa;
  int? idContaPista;
  int? idContaSangria;
  int? idContaSuprimento;
  int? idContaSalario;
  int? caixaId;
  String? repicateCaixaId;
  String? razaoSocial;
  String? nomeFantasia;
  String? cnpj;
  String? iscricaoEstadual;
  String? tipoLogradouro;
  String? logradouro;
  String? numero;
  String? bairro;
  String? cep;
  String? fil_ddd;
  String? telefone;
  String? nomeDoMunicipio;
  String? fed_uf;

  List<CredentialPix>? credenciaisPix;
  List<CredentialTef>? credenciaisTef;

  DataPos({
    this.id,
    this.pdvPrincipalId,
    this.setorId,
    this.serial,
    this.nomeDispositivo,
    this.clientePadraoId,
    this.atendentePadraoId,
    this.idContaCaixa,
    this.idContaPista,
    this.idContaSangria,
    this.idContaSuprimento,
    this.idContaSalario,
    this.caixaId,
    this.repicateCaixaId,
    this.razaoSocial,
    this.nomeFantasia,
    this.cnpj,
    this.iscricaoEstadual,
    this.tipoLogradouro,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cep,
    this.fil_ddd,
    this.telefone,
    this.nomeDoMunicipio,
    this.fed_uf,
    this.credenciaisPix,
    this.credenciaisTef,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pdvPrincipalId': pdvPrincipalId,
      'setorId': setorId,
      'serial': serial,
      'nomeDispositivo': nomeDispositivo,
      'clientePadraoId': clientePadraoId,
      'atendentePadraoId': atendentePadraoId,
      'idContaCaixa': idContaCaixa,
      'idContaPista': idContaPista,
      'idContaSangria': idContaSangria,
      'idContaSuprimento': idContaSuprimento,
      'idContaSalario': idContaSalario,
      'caixaId': caixaId,
      'replicateCaixaId': repicateCaixaId,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'cnpj': cnpj,
      'iscricaoEstadual': iscricaoEstadual,
      'tipoLogradouro': tipoLogradouro,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cep': cep,
      'fil_ddd': fil_ddd,
      'telefone': telefone,
      'nomeDoMunicipio': nomeDoMunicipio,
      'fed_uf': fed_uf,
      'credenciaisPix': credenciaisPix?.map((x) => x.toMap()).toList(),
      'credenciaisTef': credenciaisTef?.map((x) => x.toMap()).toList(),
    };
  }

  factory DataPos.fromMap(Map<String, dynamic> map) {
    return DataPos(
      id: map['ID'] != null ? map['ID'] as int : null,
      pdvPrincipalId: map['PDV_PRINCIPAL_ID'] != null
          ? map['PDV_PRINCIPAL_ID'] as int
          : null,
      setorId: map['SETOR_ID'] != null ? map['SETOR_ID'] as int : null,
      serial: map['SERIAL'] != null ? map['SERIAL'] as String : null,
      nomeDispositivo: map['NOME_DISPOSITIVO'] != null
          ? map['NOME_DISPOSITIVO'] as String
          : null,
      clientePadraoId: map['CLIENTE_PADRAO_ID'] != null
          ? map['CLIENTE_PADRAO_ID'] as int
          : null,
      atendentePadraoId: map['ATENDENTE_PADRAO_ID'] != null
          ? map['ATENDENTE_PADRAO_ID'] as int
          : null,
      idContaCaixa:
          map['IDCONTA_CAIXA'] != null ? map['IDCONTA_CAIXA'] as int : null,
      idContaPista:
          map['IDCONTA_PISTA'] != null ? map['IDCONTA_PISTA'] as int : null,
      idContaSangria:
          map['IDCONTA_SANGRIA'] != null ? map['IDCONTA_SANGRIA'] as int : null,
      idContaSuprimento: map['IDCONTA_SUPRIMENTO'] != null
          ? map['IDCONTA_SUPRIMENTO'] as int
          : null,
      idContaSalario:
          map['IDCONTA_SALARIO'] != null ? map['IDCONTA_SALARIO'] as int : null,
      caixaId: map['CAIXA_ID'] != null ? map['CAIXA_ID'] as int : null,
      repicateCaixaId: map['REPLICATE_CAIXA_ID'] != null
          ? map['REPLICATE_CAIXA_ID'] as String
          : null,
      razaoSocial:
          map['RAZAO_SOCIAL'] != null ? map['RAZAO_SOCIAL'] as String : null,
      nomeFantasia:
          map['NOME_FANTASIA'] != null ? map['NOME_FANTASIA'] as String : null,
      cnpj: map['CNPJ'] != null ? map['CNPJ'] as String : null,
      iscricaoEstadual: map['IE'] != null ? map['IE'] as String : null,
      tipoLogradouro: map['TIPO_LOGRADOURO'] != null
          ? map['TIPO_LOGRADOURO'] as String
          : null,
      logradouro:
          map['LOGRADOURO'] != null ? map['LOGRADOURO'] as String : null,
      numero: map['NUMERO'] != null ? map['NUMERO'] as String : null,
      bairro: map['BAIRRO'] != null ? map['BAIRRO'] as String : null,
      cep: map['CEP'] != null ? map['CEP'] as String : null,
      fil_ddd: map['FIL_DDD'] != null ? map['FIL_DDD'] as String : null,
      telefone: map['TELEFONE'] != null ? map['TELEFONE'] as String : null,
      nomeDoMunicipio: map['NOMEDOMUNICIPIO'] != null
          ? map['NOMEDOMUNICIPIO'] as String
          : null,
      fed_uf: map['FED_UF'] != null ? map['FED_UF'] as String : null,
      credenciaisPix: map['credenciais_pix'] != null
          ? List<CredentialPix>.from(
              (map['credenciais_pix'] as List<dynamic>).map<CredentialPix?>(
                (x) => CredentialPix.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      credenciaisTef: map['credenciais_tef'] != null
          ? List<CredentialTef>.from(
              (map['credenciais_tef'] as List<dynamic>).map<CredentialTef?>(
                (x) => CredentialTef.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataPos.fromJson(String source) =>
      DataPos.fromMap(json.decode(source) as Map<String, dynamic>);
}
