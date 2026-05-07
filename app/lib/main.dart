import 'package:flutter/material.dart';

void main() {
  runApp(const FallDetectionApp());
}

class FallDetectionApp extends StatelessWidget {
  const FallDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // LOGO
              Image.asset(
                'assets/logo.png',
                height: 250,
              ),

              const SizedBox(height: 10),

              // TITLE
              const Text(
                'Seguridad en cada paso',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFff6200),
                ),
              ),

              const SizedBox(height: 50),

              // INPUT
              TextField(
                controller: nameController,

                style: const TextStyle(
                  color:  Color(0xFFff6200),
                  fontSize: 18,
                ),

                decoration: InputDecoration(
                  hintText: 'Enter your name',

                  hintStyle: const TextStyle(
                    color: Color(0xFFff6200),
                  ),

                  prefixIcon: const Icon(
                    Icons.person,
                    color: Color(0xFFff6200),
                  ),

                  filled: true,
                  fillColor: Colors.transparent,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),

                    borderSide: const BorderSide(
                      color: Color(0xFFff6200),
                      width: 2,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),

                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 65,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFff6200),
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}