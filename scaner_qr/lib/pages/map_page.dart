import 'package:flutter/material.dart';
import 'package:scaner_qr/models/scanner_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatelessWidget {
  final double zoom = 8.0;
  @override
  Widget build(BuildContext context) {
    final ScannerModel model = ModalRoute.of(context).settings.arguments;
    model.getLtdLng();
    return Scaffold(
        appBar: AppBar(
          title: Text("Mapa"),
          actions: <Widget>[
            ButtonBar(
              children: <Widget>[Icon(Icons.my_location)],
            )
          ],
        ),
        body: _createMap(model));
  }

  Widget _createMap(ScannerModel model) {
    return FlutterMap(
      options: MapOptions(center: model.getLtdLng(), zoom: zoom),
      layers: <LayerOptions>[
        TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
            additionalOptions: {
              "accessToken":
                  "pk.eyJ1IjoiZnJuYXV0IiwiYSI6ImNrYmg4aHhvajAydWgycm56bjdvbWZqYnQifQ.ps2Uo1mvzCL7JvLXX4Q9gA",
              "id": "streets-v11"
            }),
        MarkerLayerOptions(markers: [
          Marker(
              width: 120,
              height: 120,
              point: model.getLtdLng(),
              builder: (context) {
                return Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 50.0,
                  ),
                );
              })
        ])
      ],
    );
  }
}

// https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/1/1/0?access_token=pk.eyJ1IjoiZnJuYXV0IiwiYSI6ImNrYmg4YTBpajAwcTYyc2swMGh4cGhoNHgifQ.Ue7piJKJN1tMbrLGrHFZdw
// "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}"
