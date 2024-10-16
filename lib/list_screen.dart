import 'package:flutter/material.dart';
import 'form_screen.dart';
import 'transacao_service.dart';
import 'transacao_model.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Transacao>> futureTransacoes;

  @override
  void initState() {
    super.initState();
    futureTransacoes = TransacaoServiceImpl().getTransacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transações'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newTransacao = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormScreen()),
              );
              if (newTransacao != null) {
                setState(() {
                  futureTransacoes = TransacaoServiceImpl().getTransacoes();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transacao>>(
        future: futureTransacoes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final transacoes = snapshot.data!;
            return ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(transacoes[index].descricao),
                  subtitle: Text(
                      'R\$ ${transacoes[index].valor.toStringAsFixed(2)}'), // Formato monetário
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final updatedTransacao = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormScreen(
                                transacao: transacoes[index],
                              ),
                            ),
                          );
                          if (updatedTransacao != null) {
                            setState(() {
                              futureTransacoes =
                                  TransacaoServiceImpl().getTransacoes();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          TransacaoServiceImpl()
                              .deleteTransacao(transacoes[index].id!)
                              .then((_) {
                            setState(() {
                              futureTransacoes =
                                  TransacaoServiceImpl().getTransacoes();
                            });
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Erro ao excluir transação: $error')),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
