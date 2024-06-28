// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReimpressaoCupom {
  String? cupom;
  String? rubrica;
  
  ReimpressaoCupom({
    this.cupom,
    this.rubrica,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cupom': cupom,
      'rubrica': rubrica,
    };
  }

  factory ReimpressaoCupom.fromMap(Map<String, dynamic> map) {
    return ReimpressaoCupom(
      cupom: map['cupom'] != null ? map['cupom'] as String : null,
      rubrica: map['rubrica'] != null ? map['rubrica'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReimpressaoCupom.fromJson(String source) => ReimpressaoCupom.fromMap(json.decode(source) as Map<String, dynamic>);
}
