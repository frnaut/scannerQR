import 'package:flutter/material.dart';
import 'package:scaner_qr/blocs/scans_bloc.dart';
import 'package:scaner_qr/models/scanner_model.dart';
import 'package:scaner_qr/utils/launcher_utils.dart';

class MapaPage extends StatelessWidget {
  final scanBloc = new ScanBloc();
  final launcher = new Launcher();
  @override
  Widget build(BuildContext context) {
    scanBloc.getAllScan();
    return StreamBuilder<List<ScannerModel>>(
      stream: scanBloc.scanStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ScannerModel>> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<ScannerModel> scans = [];
        snapshot.data.forEach((scan) {
          if (scan.type == "geo") {
            scans.add(scan);
          }
        });

        if (scans.length == 0) {
          return Center(
            child: Text("No se encontro registros"),
          );
        }

        return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
                  direction: DismissDirection.startToEnd,
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direccion) => scanBloc.deleteScan(scans[i].id),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(scans[i].value),
                    subtitle: Text('ID: ${scans[i].id}'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => launcher.launchMap(context, scans[i]),
                  ),
                ));
      },
    );
  }
}
