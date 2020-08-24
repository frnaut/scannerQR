import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:scaner_qr/blocs/scans_bloc.dart';
import 'package:scaner_qr/models/scanner_model.dart';

import 'package:scaner_qr/pages/direcciones_page.dart';
import 'package:scaner_qr/pages/mapas_page.dart';
import 'package:scaner_qr/utils/launcher_utils.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  ScanBloc scanBloc = new ScanBloc();
  Launcher launcher = new Launcher();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              bool result;

              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Eliminar registros"),
                      content: Text(
                          "¿Esta seguro que desea eliminar los registros?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            result = false;
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Aceptar"),
                          onPressed: () {
                            result = true;
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });

              if (result == true) {
                if (currentIndex == 0) {
                  scanBloc.deleteByType("geo");
                }

                if (currentIndex == 1) {
                  scanBloc.deleteByType("http");
                }
              }

              return;
            },
          )
        ],
      ),
      body: Center(
        child: _callPage(currentIndex),
      ),
      bottomNavigationBar: _customNavbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
      ),
    );
  }

  Widget _customNavbar() {
    return CurvedNavigationBar(
      color: Colors.green,
      backgroundColor: Colors.white,
      items: <Widget>[
        Icon(Icons.map, size: 30, color: Colors.white),
        Container(),
        Icon(Icons.open_in_browser, size: 30, color: Colors.white)
      ],
      onTap: (index) {
        if (index == 1) {
          index = 0;
        }
        print(index);
      },
    );
  }

  _scanQR(BuildContext context) async {
    // geo:40.689879098597345,-73.8397730871094
    // http://en.m.wikipedia.org
    ScanResult result;

    try {
      result = await BarcodeScanner.scan();
      ScannerModel newScan = new ScannerModel(value: result.rawContent);
      scanBloc.createScan(newScan);
      if (newScan.type == "http") {
        launcher.launchURL(newScan.value);
      }
      if (newScan.type == "geo") {
        launcher.launchMap(context, newScan);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Widget _callPage(int page) {
    if (page == 1) {
      page = 0;
    }

    switch (page) {
      case 0:
        return MapaPage();
        break;
      case 1:
        return DireccionesPage();
        break;
      case 2:
        return DireccionesPage();
      default:
        return MapaPage();
    }
  }

  Widget _createBottonNavBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        _createBottonBar(icon: Icon(Icons.map), title: Text("Mapas")),
        _createBottonBar(
            icon: Icon(Icons.directions), title: Text("Direcciones"))
      ],
    );
  }

  BottomNavigationBarItem _createBottonBar({icon: Icon, title: Text}) {
    return BottomNavigationBarItem(icon: icon, title: title);
  }
}
