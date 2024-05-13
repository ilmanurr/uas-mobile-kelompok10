import 'package:apk_keuangan/pages/login_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Image(image: AssetImage('images/icon-apk.png')), // Menampilkan gambar logo aplikasi
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  backgroundColor: Colors.green[900],
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2
                  ),
                ),
              ),
              SizedBox(height: 50,),
              // Informasi credite pembuat aplikasi
              Text(
                'Created by Kelompok 10 MI2022B',
                style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 11
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
