import 'package:flutter/material.dart';
import 'package:CRUDProdutoDeLimpeza/produtoDeLimpeza.dart';
import 'package:CRUDProdutoDeLimpeza/database_helper.dart';
import 'package:CRUDProdutoDeLimpeza/produtoDeLimpeza_screen.dart';

class ListViewProdutoDeLimpeza extends StatefulWidget {
  @override
  _ListViewProdutoDeLimpezaState createState() => new _ListViewProdutoDeLimpezaState();
}

class _ListViewProdutoDeLimpezaState extends State<ListViewProdutoDeLimpeza> {
  List<ProdutoDeLimpeza> items = new List();
  //conexão com banco de dados
  DatabaseHelper db = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    db.getProdutos().then((produtoDeLimpeza) {
      setState(() {
        produtoDeLimpeza.forEach((produtoDeLimpeza) {
          items.add(ProdutoDeLimpeza.fromMap(produtoDeLimpeza));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo de Cadastro',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Produtos de Limpeza'),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].nome}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Row(children: [
                        Text('${items[position].marca}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        Padding(padding: new EdgeInsets.all(5.0)),
                        Text('${items[position].categoria}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        Padding(padding: new EdgeInsets.all(5.0)),
                        Text('${items[position].preco}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        Padding(padding: new EdgeInsets.all(5.0)),
                        IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _deleteProdutoDeLimpeza(
                                context, items[position], position)),
                      ]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.cyan,
                        radius: 15.0,
                        child: Text(
                          '${items[position].id}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () =>
                          _navigateToProdutoDeLimpeza(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewProdutoDeLimpeza(context),
          backgroundColor: Colors.cyan,
        ),
      ),
    );
  }

  void _deleteProdutoDeLimpeza(BuildContext context, ProdutoDeLimpeza produtoDeLimpeza, int position) async {
    db.deleteProdutoDeLimpeza(produtoDeLimpeza.id).then((produtos) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToProdutoDeLimpeza(BuildContext context, ProdutoDeLimpeza produtoDeLimpeza) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdutoDeLimpezaScreen(produtoDeLimpeza)),
    );
    if (result == 'update') {
      db.getProdutos().then((produtos) {
        setState(() {
          items.clear();
          produtos.forEach((produtoDeLimpeza) {
            items.add(ProdutoDeLimpeza.fromMap(produtoDeLimpeza));
          });
        });
      });
    }
  }

  void _createNewProdutoDeLimpeza(BuildContext context) async {
    //aguarda o retorno da página de cadastro
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdutoDeLimpezaScreen(ProdutoDeLimpeza('', '', '', 0.00))),
    );
    //se o retorno for salvar, recarrega a lista
    if (result == 'save') {
      db.getProdutos().then((produtos) {
        setState(() {
          items.clear();
          produtos.forEach((produtoDeLimpeza) {
            items.add(ProdutoDeLimpeza.fromMap(produtoDeLimpeza));
          });
        });
      });
    }
  }
}
