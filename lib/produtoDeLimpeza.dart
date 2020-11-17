class ProdutoDeLimpeza {
  int _id;
  String _nome;
  String _marca;
  String _categoria;
  double _preco;
  
  //construtor da preco
  ProdutoDeLimpeza(this._nome, this._marca, this._categoria, this._preco);

  //converte dados de vetor para objeto
  ProdutoDeLimpeza.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._marca = obj['marca'];
    this._categoria = obj['categoria'];
    this._preco = obj['preco'];
  }

  // encapsulamento
  int get id => _id;
  String get nome => _nome;
  String get marca => _marca;
  String get categoria => _categoria;
  double get preco => _preco;

//converte o objeto em um map
 Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
       map['id'] = _id;
    }
    map['nome'] = _nome;
    map['marca'] = _marca;
    map['categoria'] = _categoria;
    map['preco'] = _preco;
    return map;
  }

  //converte map em um objeto
  ProdutoDeLimpeza.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._marca = map['marca'];
    this._categoria = map['categoria'];
    this._preco = map['preco'];
  }
}
