import 'package:flutter/material.dart';

import '../estado/estado_app.dart';

class SobreMim extends StatelessWidget {
  const SobreMim({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = EscopoEstado.de(context).textos;
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      appBar: AppBar(
        title: Text(textos.t('sobremim_titulo')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 72,
                      backgroundColor: const Color(0xFF1565C0),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/eu.png',
                          width: 136,
                          height: 136,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      textos.t('sobremim_desc'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
