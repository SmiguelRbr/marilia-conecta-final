import 'package:flutter/material.dart';
import 'package:mariliaconectafinal/pages/listarocorrencia.dart';
import 'package:mariliaconectafinal/pages/login.dart';
import 'package:mariliaconectafinal/pages/cadastro.dart';
import 'package:mariliaconectafinal/pages/home.dart';
import 'package:mariliaconectafinal/pages/ocorrencia.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marilia Conecta',
      initialRoute: '/',
      routes: {
         '/': (context) => const Login(),
         '/Cadastro': (context) => const Cadastro(),
         '/Home': (context) => const Home(),
         '/Ocorrencia': (context) => const Ocorrencia(),
         '/ListarOcorrencia': (context) => const Listarocorrencia(),
      },
      debugShowCheckedModeBanner: false,
      
    );
  }
}
