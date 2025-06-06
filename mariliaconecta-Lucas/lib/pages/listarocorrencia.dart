import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mariliaconectafinal/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Listarocorrencia extends StatelessWidget {
  const Listarocorrencia({super.key});

  Future<List<Map<String, dynamic>>> buscarOcorrencias() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final url = Uri.parse(
      'https://fc93-200-205-2-218.ngrok-free.app/api/ocorrencias',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('Body: ${response.body}');
    print('Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['ocorrencias'];

      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Resposta inesperada: $data');
        throw Exception('Resposta inesperada: não é uma lista de ocorrências');
      }
    } else {
      throw Exception('Erro ao carregar: ${response.statusCode}');
    }
  }

  Color corStatus(String status) {
    switch (status.toLowerCase()) {
      case 'aberto':
        return Colors.blue;
      case 'analisando':
        return Colors.orange;
      case 'pendente':
        return Colors.red;
      case 'recusado':
        return Colors.redAccent;
      case 'resolvido':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void abrirModalOcorrencia(
    BuildContext context,
    Map<String, dynamic> ocorrencias,
  ) {
    final status = ocorrencias['status'] ?? 'Desconhecido';
    final descricao = ocorrencias['descricao'] ?? 'Sem descrição';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          descricao,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status: ${status.toLowerCase() == 'resolvido' ? 'Concluído' : status}',
                style: TextStyle(
                  color: corStatus(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Descrição:'),
              Text(descricao),
              if (status.toLowerCase() == 'resolvido') ...[
                const SizedBox(height: 10),
                const Text('Avalie esta ocorrência:'),
                const AvaliacaoWidget(),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Fechar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardOcorrencia(
      BuildContext context, Map<String, dynamic> ocorrencias) {
    final descricao = ocorrencias['descricao'] ?? 'Sem descrição';
    final status = ocorrencias['status'] ?? 'Desconhecido';

    return GestureDetector(
      onTap: () => abrirModalOcorrencia(context, ocorrencias),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(AppColors.azulprincipal), width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descricao,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Text('Status:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      status.toLowerCase() == 'resolvido'
                          ? 'Concluído'
                          : status,
                      style: TextStyle(
                        color: corStatus(status),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ],
                )
              ],
            )),
            const Icon(
              Icons.chevron_right,
              size: 28,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Text(
              'Minhas Ocorrências',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: buscarOcorrencias(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Erro buscar ocorrência: ${snapshot.error}');
                    return Center(
                      child: Text('Erro: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhuma ocorrência encontrada'));
                  }
                  final ocorrencias = snapshot.data!;
                  return ListView.builder(
                    itemCount: ocorrencias.length,
                    itemBuilder: (context, i) =>
                        cardOcorrencia(context, ocorrencias[i]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AvaliacaoWidget extends StatefulWidget {
  const AvaliacaoWidget({super.key});

  @override
  State<AvaliacaoWidget> createState() => _AvaliacaoWidgetState();
}

class _AvaliacaoWidgetState extends State<AvaliacaoWidget> {
  int nota = 0;
  final comentariocontroller = TextEditingController();

  @override
  void dispose() {
    comentariocontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: comentariocontroller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Deixe um comentário',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(AppColors.azulprincipal),
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(AppColors.azulprincipal),
          ),
          onPressed: () {
            print('Nota: $nota');
            print('Comentário: ${comentariocontroller.text}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Avaliação enviada!')),
            );
          },
          child: const Text(
            'Enviar',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
