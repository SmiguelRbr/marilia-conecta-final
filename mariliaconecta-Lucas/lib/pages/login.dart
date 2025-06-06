import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mariliaconectafinal/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String cpf = '';
  String senha = '';

  Future<void> loginUsuario(String cpf, String senha) async {
    final url = Uri.parse(
      'https://fc93-200-205-2-218.ngrok-free.app/api/auth/login',
    );

    print('Enviando');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cpf': cpf, 'password': senha}),
    );

    print('Body: ${response.body}');
    print('Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        print('Token salvo: $token');
      } else {
        print('Token não encontrado na resposta!');
      }
    } else {
      print('Erro ao fazer login: ${response.statusCode}');
      throw Exception('Falha no login');
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('cpf: $cpf, senha: $senha');
      try {
        await loginUsuario(cpf, senha);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, '/Home');
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao fazer login')));
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/image/Logo.png', height: 200),
                  const SizedBox(height: 60),
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('CPF'),
                    validator:
                        (value) => value!.isEmpty ? 'Informe o CPF' : null,
                    onSaved: (value) => cpf = value!,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: _inputDecoration('Senha'),
                    validator:
                        (value) => value!.isEmpty ? 'Informe a Senha' : null,
                    onSaved: (value) => senha = value!,
                    obscureText: true,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(AppColors.azulprincipal),
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                    ),
                    onPressed: _login,
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Cadastro');
                    },
                    child: const Text(
                      'Não tem uma conta? Cadastre-se',
                      style: TextStyle(color: Colors.blue),
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

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Color(AppColors.azulprincipal), width: 3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Color(AppColors.azulprincipal), width: 3),
    ),
  );
}
