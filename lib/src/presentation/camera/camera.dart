import 'package:asc/src/core/constants.dart';
import 'package:asc/src/presentation/page_entity/views/entity.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraConnector extends StatefulWidget {
  const CameraConnector({super.key});

  @override
  State<CameraConnector> createState() => _CameraConnectorState();
}

class _CameraConnectorState extends State<CameraConnector> {
  late MobileScannerController controller;
  bool scanned = false;
  bool cameraLoading = true;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(autoStart: false);
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      controller.stop();
      controller.start();
    });
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      setState(() {
        cameraLoading = false;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TBody('Scan'),
      ),
      body: cameraLoading
          ? const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ColoredBox(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ColoredBox(
                    color: Colors.black,
                  ),
                ),
                MobileScanner(
                  controller: controller,
                  // fit: BoxFit.contain,
                  onDetect: (capture) async {
                    if (scanned) return;
                    final List<Barcode> barcodes = capture.barcodes;
                    String? value;
                    for (final barcode in barcodes) {
                      value = barcode.rawValue;
                      break;
                    }
                    if (value == null) return;
                    final uri = Uri.tryParse(value);
                    final url = (await supabase
                        .from('settings')
                        .select('url')
                        .limit(1)
                        .single())['url'];

                    final id =
                        uri.toString().replaceAll(url, '').split('/').first;
                    if (id.isEmpty) return;
                    setState(() {
                      scanned = true;
                    });
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntityConnector(
                          id: id,
                        ),
                      ),
                    );
                    await controller.stop();
                    controller.start();
                    setState(() {
                      scanned = false;
                    });
                  },
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
