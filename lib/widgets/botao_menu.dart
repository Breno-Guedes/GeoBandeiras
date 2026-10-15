import 'package:flutter/material.dart';

/// Botão grande usado no menu principal e na escolha de continente.
class BotaoMenu extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String? descricao;
  final Color cor;
  final VoidCallback aoTocar;

  const BotaoMenu({
    super.key,
    required this.icone,
    required this.titulo,
    required this.cor,
    required this.aoTocar,
    this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icone, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      if (descricao != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            descricao!,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
