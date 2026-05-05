import 'package:asc/src/presentation/camera/camera.dart';
import 'package:asc/src/theming/app_bar.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PDFConnector extends StatefulWidget {
  const PDFConnector({
    super.key,
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  @override
  State<PDFConnector> createState() => _PDFConnectorState();
}

class _PDFConnectorState extends State<PDFConnector> {
  late PDFDocument doc;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final temp = await PDFDocument.fromURL(widget.url);
    setState(() {
      doc = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: widget.name),
      body: Center(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : PDFViewer(document: doc)),
    );
  }
}
