import 'package:asc/src/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({super.key});

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
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
          .select('credits_page')
          .limit(1)
          .single();
      content = res['credits_page'];
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
      backgroundColor: Colors.black,
      title: const Text(
        'Credits',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
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
