import 'dart:convert';

class RetornoFechamentoModel {
  bool success = false;
  String data = '';
  String message = '';

  RetornoFechamentoModel({
    this.success = false,
    this.data = '',
    this.message = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'data': data,
      'message': message,
    };
  }

  factory RetornoFechamentoModel.fromMap(Map<String, dynamic> map) {
    return RetornoFechamentoModel(
      success: map['success'] ?? false,
      data: map['data'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoFechamentoModel.fromJson(String source) =>
      RetornoFechamentoModel.fromMap(json.decode(source));
}
