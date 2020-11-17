import 'package:flutter/material.dart';
import 'package:CRUDProdutoDeLimpeza/produtoDeLimpeza.dart';
import 'package:CRUDProdutoDeLimpeza/database_helper.dart';

class ProdutoDeLimpezaScreen extends StatefulWidget {
  final ProdutoDeLimpeza produtoLimpeza;
  ProdutoDeLimpezaScreen(this.produtoLimpeza);
  @override
  State<StatefulWidget> createState() => new _ProdutoDeLimpezaScreenState();
}
class _ProdutoDeLimpezaScreenState extends State<ProdutoDeLimpezaScreen> {
  DatabaseHelper db = new DatabaseHelper();
  TextEditingController _nomeController;
  TextEditingController _marcaController;
  TextEditingController _categoriaController;
  TextEditingController _precoController;
  @override
  void initState() {
    super.initState();
    _nomeController = new TextEditingController(text: widget.produtoLimpeza.nome);
    _marcaController = new TextEditingController(text: widget.produtoLimpeza.marca);
    _categoriaController = new TextEditingController(text: widget.produtoLimpeza.categoria);
    _precoController = new TextEditingController(text: widget.produtoLimpeza.preco.toString());
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Produto de Limpeza'),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
        children:[
          Image.network(
            'https://higtop.com.br/wp-content/uploads/2018/06/produtos-corretos.jpg',
            width: 400,
          ),
          Padding(padding: new EdgeInsets.all(5.0)),

          TextField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          Padding(padding: new EdgeInsets.all(5.0)),

          TextField(
            controller: _marcaController,
            decoration: InputDecoration(labelText: 'Marca'),
          ),
          Padding(padding: new EdgeInsets.all(5.0)),

          TextField(
            controller: _categoriaController,
            decoration: InputDecoration(labelText: 'Categoria'),
          ),
          Padding(padding: new EdgeInsets.all(5.0)),

          TextField(
            keyboardType: TextInputType.number,
            controller: _precoController,
            decoration: InputDecoration(labelText: 'Preço'),
          ),
          Padding(padding: new EdgeInsets.all(5.0)),

          RaisedButton(
            child: (widget.produtoLimpeza.id != null) ? Text('Alterar') : Text('Inserir'),
            onPressed: () {
              if (widget.produtoLimpeza.id != null) {
                db.updateProdutoDeLimpeza(ProdutoDeLimpeza.fromMap({
                  'id': widget.produtoLimpeza.id,
                  'nome': _nomeController.text,
                  'marca': _marcaController.text,
                  'categoria': _categoriaController.text,
                  'preco': double.parse(_precoController.text),
                })).then((_) {
                  Navigator.pop(context, 'update');
                });
              } else {
                db.inserirProdutoDeLimpeza(ProdutoDeLimpeza(_nomeController.text, _marcaController.text, _categoriaController.text, double.parse(_precoController.text)))
                    .then((_) {
                  Navigator.pop(context, 'save');
                });
              }
            },
          ),
          ],
        ),
      ),
    );
  }
}
