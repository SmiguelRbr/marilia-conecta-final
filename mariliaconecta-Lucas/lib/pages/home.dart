import 'package:flutter/material.dart';
import 'package:mariliaconectafinal/style.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
       Center(
         child: Padding(
            padding: EdgeInsetsGeometry.all(30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/image/Logo.png', height: 200),
                  const SizedBox(height: 40),
                  const Text(
                    'Seja Bem-Vindo!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      side: BorderSide(
                        color: Color(AppColors.azulprincipal),
                        width: 3,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/Ocorrencia');
                    },
                    child: const Text(
                      'Registrar Ocorrência',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      side: BorderSide(
                        color: Color(AppColors.azulprincipal),
                        width: 3,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/ListarOcorrencia');
                    },
                    child: const Text(
                      'Minhas Ocorrências',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
