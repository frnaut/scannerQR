import 'package:scaner_qr/models/scanner_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Launcher {
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir la url: $url';
    }
  }

  void launchMap(BuildContext context, ScannerModel model) {
    Navigator.pushNamed(context, "map", arguments: model);
  }
}
