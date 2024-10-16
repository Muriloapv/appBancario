import 'package:flutter/material.dart';
import 'transacao_model.dart';
import 'transacao_service.dart'; // Certifique-se de que este import está presente

class FormScreen extends StatefulWidget {
  final Transacao? transacao;

  FormScreen({this.transacao});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _descricao;
  double? _valor;

  @override
  void initState() {
    super.initState();
    if (widget.transacao != null) {
      _descricao = widget.transacao!.descricao;
      _valor = widget.transacao!.valor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transacao == null
            ? 'Adicionar Transação'
            : 'Editar Transação'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                initialValue: _descricao,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descricao = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Valor'),
                initialValue: _valor
                    ?.toString(), // Certifique-se de que o valor é uma string
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor';
                  }
                  return null;
                },
                onSaved: (value) {
                  _valor = double.tryParse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final transacao = Transacao(
                      id: widget
                          .transacao?.id, // Manter o ID se estiver editando
                      descricao: _descricao!,
                      valor: _valor!,
                    );

                    if (widget.transacao == null) {
                      TransacaoServiceImpl()
                          .createTransacao(transacao)
                          .then((_) {
                        Navigator.pop(context, transacao);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Erro ao criar transação: $error')),
                        );
                      });
                    } else {
                      TransacaoServiceImpl()
                          .updateTransacao(transacao)
                          .then((_) {
                        Navigator.pop(context, transacao);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Erro ao atualizar transação: $error')),
                        );
                      });
                    }
                  }
                },
                child:
                    Text(widget.transacao == null ? 'Adicionar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
