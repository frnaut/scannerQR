import 'dart:async';

import 'package:scaner_qr/models/scanner_model.dart';
import 'package:scaner_qr/providers/sqlite_provider.dart';

class ScanBloc {
  static final ScanBloc _singleBloc = new ScanBloc._();

  factory ScanBloc() {
    return _singleBloc;
  }

  ScanBloc._() {
    getAllScan();
  }

  final _scanController = StreamController<List<ScannerModel>>.broadcast();

  Stream<List<ScannerModel>> get scanStream => _scanController.stream;

  despose() {
    _scanController?.close();
  }

  getAllScan() async {
    List<ScannerModel> scans = await DBProvider.db.getAll();
    _scanController.sink.add(scans);
  }

  getById(int id) async {
    await DBProvider.db.getScan(id);
  }

  getByType(String type) async {
    await DBProvider.db.getByType(type);
  }

  createScan(ScannerModel model) async {
    await DBProvider.db.createScan(model);
    getAllScan();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getAllScan();
  }

  deleteAll() async {
    await DBProvider.db.deleteAll();
    getAllScan();
  }

  deleteByType(String type) async {
    await DBProvider.db.deleteByType(type);
    getAllScan();
  }
}
