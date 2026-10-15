import 'package:flutter/material.dart';

enum SituacaoResposta { normal, correta, errada, desativada }

/// Botão de uma das 4 opções de resposta. Muda de cor ao revelar o resultado.
class BotaoResposta extends StatelessWidget {
  final String texto;
  final SituacaoResposta situacao;
  final VoidCallback? aoTocar;

  const BotaoResposta({
    super.key,
    required this.texto,
    required this.situacao,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    Color fundo = Colors.white;
    Color borda = const Color(0xFFB0BEC5);
    Color corTexto = Colors.black87;
    IconData? icone;

    switch (situacao) {
      case SituacaoResposta.correta:
        fundo = const Color(0xFF2E7D32);
        borda = const Color(0xFF1B5E20);
        corTexto = Colors.white;
        icone = Icons.check_circle;
        break;
      case SituacaoResposta.errada:
        fundo = const Color(0xFFC62828);
        borda = const Color(0xFF8E0000);
        corTexto = Colors.white;
        icone = Icons.cancel;
        break;
      case SituacaoResposta.desativada:
        fundo = const Color(0xFFECEFF1);
        borda = const Color(0xFFCFD8DC);
        corTexto = Colors.black38;
        break;
      case SituacaoResposta.normal:
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borda, width: 1.5),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    texto,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: corTexto,
                    ),
                  ),
                ),
                if (icone != null) Icon(icone, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
