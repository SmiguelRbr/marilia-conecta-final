import 'package:flutter/material.dart';
import 'package:mariliaconectafinal/style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String cpf = '';
  String telefone = '';
  String senha = '';

  Future<void> cadastroUsuario(
    String nome,
    String cpf,
    String telefone,
    String senha,
  ) async {
    final url = Uri.parse(
      "https://fc93-200-205-2-218.ngrok-free.app/api/auth/register",
    );

    print('Enviando....');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nome,
        'cpf': cpf,
        'telefone': telefone,
        'password': senha,
      }),
    );

    if (response.statusCode == 200) {
      print('Cadastro realizado com sucesso!');
    } else {
      print('Erro no cadastro: ${response.statusCode}');
      print('Resposta: ${response.body}');
      throw Exception('Falha ao cadastrar o usuario');
    }
  }

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Nome: $nome,CPF: $cpf,Telefone: $telefone,Senha: $senha');

      try {
        await cadastroUsuario(nome, cpf, telefone, senha);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao cadastar')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image/Logo.png'),
                const SizedBox(height: 60),
                const Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: _inputDecoration('Nome completo'),
                  validator: (value) =>
                      value!.isEmpty ? 'Infome um nome' : null,
                  onSaved: (value) => nome = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: _inputDecoration('CPF'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe um CPF' : null,
                  onSaved: (value) => cpf = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: _inputDecoration('Telefone'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe um telefone' : null,
                  onSaved: (value) => telefone = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: _inputDecoration('Senha'),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe uma senha' : null,
                  onSaved: (value) => senha = value!,
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppColors.azulprincipal),
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 15,
                    ),
                  ),
                  onPressed: _cadastrar,
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Color(AppColors.azulprincipal), width: 3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Color(AppColors.azulprincipal), width: 3),
    ),
  );
}
