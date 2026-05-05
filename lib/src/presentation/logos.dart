import 'package:asc/src/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LogosPage extends StatefulWidget {
  const LogosPage({super.key});

  @override
  State<LogosPage> createState() => _LogosPageState();
}

class _LogosPageState extends State<LogosPage> {
  String content = '';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await supabase
          .from('settings')
          .select('logos_page')
          .limit(1)
          .single();
      content = res['logos_page'];
      isLoading = false;
    } catch (e) {
      isLoading = false;
      error = e.toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text(
        'Affiliati',
      ),
      centerTitle: true,
    );
    if (isLoading) {
      return Scaffold(
        appBar: appBar,
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: appBar,
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            error!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Theme(
              data: ThemeData.dark(),
              child: Builder(builder: (context) {
                return Html(
                  data: content,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
