import 'dart:convert';

class Transacao {
  final String? id; // ID opcional para edição
  final String descricao;
  final double valor;

  Transacao({this.id, required this.descricao, required this.valor});

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id'] as String?, // ID deve ser um String
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(), // Converte para double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'valor': valor,
    };
  }
}
