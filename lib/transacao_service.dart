import 'dart:convert';
import 'package:http/http.dart' as http;
import 'transacao_model.dart';

abstract class TransacaoService {
  Future<List<Transacao>> getTransacoes();
  Future<Transacao> createTransacao(Transacao transacao);
  Future<Transacao> updateTransacao(Transacao transacao);
  Future<void> deleteTransacao(String id);
}

class TransacaoServiceImpl implements TransacaoService {
  final String baseUrl =
      'http://localhost:3000/transacoes'; // Altere se necessário

  @override
  Future<List<Transacao>> getTransacoes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Transacao.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar transações');
    }
  }

  @override
  Future<Transacao> createTransacao(Transacao transacao) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transacao.toJson()),
    );
    if (response.statusCode == 201) {
      return Transacao.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar transação');
    }
  }

  @override
  Future<Transacao> updateTransacao(Transacao transacao) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${transacao.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transacao.toJson()),
    );
    if (response.statusCode == 200) {
      return Transacao.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar transação');
    }
  }

  @override
  Future<void> deleteTransacao(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir transação');
    }
  }
}
