import 'dart:async';
import 'package:CRUDProdutoDeLimpeza/produtoDeLimpeza.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE produto(id INTEGER PRIMARY KEY, nome TEXT, marca TEXT, categoria TEXT, preco DOUBLE)');
  }

  Future<int> inserirProdutoDeLimpeza(ProdutoDeLimpeza produtoDeLimpeza) async {
    var dbClient = await db;
    var result = await dbClient.insert("produto", produtoDeLimpeza.toMap());
    return result;
  }

  Future<List> getProdutos() async {
    var dbClient = await db;
    var result = await dbClient
        .query("produto", columns: ["id", "nome", "marca", "categoria", "preco"]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM produto'));
  }

  Future<ProdutoDeLimpeza> getProdutoDeLimpeza(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query("produto",
        columns: ["id", "nome", "marca", "categoria", "preco"],
        where: 'id = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return new ProdutoDeLimpeza.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteProdutoDeLimpeza(int id) async {
    var dbClient = await db;
    return await dbClient.delete("produto", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateProdutoDeLimpeza(ProdutoDeLimpeza produtoDeLimpeza) async {
    var dbClient = await db;
    return await dbClient.update("produto", produtoDeLimpeza.toMap(),
        where: "id = ?", whereArgs: [produtoDeLimpeza.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
