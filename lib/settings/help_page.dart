import 'package:call/settings/theme_notifier.dart' show ThemeNotifier;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeNotifier>(context).isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعدة'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'مرحبًا بك في صفحة المساعدة. إذا كنت بحاجة إلى أي مساعدة، يرجى التواصل مع فريق الدعم.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
