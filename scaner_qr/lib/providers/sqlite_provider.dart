import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scaner_qr/models/scanner_model.dart';
export 'package:scaner_qr/models/scanner_model.dart';

class DBProvider {
  static Database _dataBase;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_dataBase != null) return _dataBase;

    _dataBase = await initDB();
    return _dataBase;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')');
    });
  }

  Future<ScannerModel> getScan(int id) async {
    final db = await database;
    final resp = await db.query("Scans", where: "id = ?", whereArgs: [id]);

    if (resp.isNotEmpty) {
      return ScannerModel.fromJson(resp.first);
    }

    return null;
  }

  Future<List<ScannerModel>> getAll() async {
    List<ScannerModel> scanList = [];
    final db = await database;
    final resp = await db.query("Scans");

    if (resp.isNotEmpty) {
      resp.forEach((scan) {
        scanList.add(ScannerModel.fromJson(scan));
      });

      return scanList;
    }

    return scanList;
  }

  Future<List<ScannerModel>> getByType(String type) async {
    List<ScannerModel> scanList = [];
    final db = await database;
    final resp = await db.query("Scans", where: "type = ?", whereArgs: [type]);

    if (resp.isNotEmpty) {
      resp.forEach((scan) {
        scanList.add(ScannerModel.fromJson(scan));
      });
      return scanList;
    }

    return scanList;
  }

  Future<int> createScan(ScannerModel model) async {
    final db = await database;
    final resp = await db.insert("Scans", model.toJson());

    return resp;
  }

  Future<int> updateScan(ScannerModel model) async {
    final db = await database;
    final resp = await db.update("Scans", model.toJson(),
        where: "id = ?", whereArgs: [model.id]);

    return resp;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final resp = await db.delete("Scans", where: "id = ?", whereArgs: [id]);
    return resp;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final resp = await db.delete("Scans");
    return resp;
  }

  Future<int> deleteByType(String type) async {
    final db = await database;
    final resp = await db.delete("Scans", where: "type = ?", whereArgs: [type]);
    return resp;
  }
}
