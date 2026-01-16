import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themeprovider.dart';

class Modechange extends StatelessWidget {
  const Modechange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: Consumer<ThemeProvider>(
        builder: (context, model, child) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color:
                    model.isDark ? Colors.grey.shade800 : Colors.pink.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      model.toggleTheme();
                    },
                    icon: Icon(
                      model.isDark ? Icons.toggle_on : Icons.toggle_off,
                      size: 40,
                      color: model.isDark ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
