import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mariliaconectafinal/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Ocorrencia extends StatefulWidget {
  const Ocorrencia({super.key});

  @override
  State<Ocorrencia> createState() => _OcorrenciaState();
}

class _OcorrenciaState extends State<Ocorrencia> {
  File? _image;
  String descricao = '';
  String endereco = '';

  final picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _enviarOcorrencia() async {
    final url = Uri.parse(
      'https://fc93-200-205-2-218.ngrok-free.app/api/store',
    );

    final request = http.MultipartRequest('POST', url);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    print('Token recuperado: $token');

    request.fields['title'] = 'Ocorrencia';
    request.fields['descricao'] = descricao;
    request.fields['endereco'] = endereco;

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );
    }

    final response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
  print('Body: $value');
});

    if (response.statusCode == 200) {
      print('Ocorência realizada com sucesso!');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ocorrência resgistrada!')));
      Navigator.pop(context);
    } else {
      print('Erro: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar ocorrência')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Registrar Ocorrência',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(AppColors.azulprincipal),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child:
                        _image == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt, size: 40),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed:
                                      () => _getImage(ImageSource.camera),
                                  child: const Text(
                                    'Abrir Camêra',
                                    style: TextStyle(
                                      color: Color(AppColors.azulprincipal),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Image.file(_image!),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Descreva o problema com detalhes',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(AppColors.azulprincipal),
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(AppColors.azulprincipal),
                        width: 3,
                      ),
                    ),
                  ),
                  onChanged: (value) => descricao = value,
                ),

                const SizedBox(height: 24),

                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Informe o endereço',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(AppColors.azulprincipal),
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(AppColors.azulprincipal),
                        width: 3,
                      ),
                    ),
                  ),
                  onChanged: (value) => endereco = value,
                ),
                const SizedBox(height: 60),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 15,
                    ),
                    backgroundColor: Color(AppColors.azulprincipal),
                  ),
                  onPressed: _enviarOcorrencia,
                  child: const Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
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
