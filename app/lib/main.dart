import 'package:flutter/material.dart';
import 'services/user_data_service.dart';

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
  final TextEditingController passwordController = TextEditingController();

  static const Color orangeColor = Color(0xFFFF6200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset('assets/logo.png', height: 200),
                const SizedBox(height: 5),
                const Text(
                  'Seguridad en cada paso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                  ),
                ),
                const SizedBox(height: 35),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: orangeColor, fontSize: 18),
                  decoration: _inputDecoration(hintText: 'Usuario', icon: Icons.person),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: orangeColor, fontSize: 18),
                  decoration: _inputDecoration(hintText: 'Contraseña', icon: Icons.lock),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    },
                    child: const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: const Text('Registrarse', style: TextStyle(color: orangeColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: orangeColor),
      prefixIcon: Icon(icon, color: orangeColor),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: orangeColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: orangeColor, width: 2),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color orangeColor = Color(0xFFFF6200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: orangeColor,
        centerTitle: true,
        title: const Text('Pentagon', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Bienvenido', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: orangeColor)),
            const SizedBox(height: 10),
            const Text('Sistema de detección de caídas', style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: const Column(
                children: [
                  Icon(Icons.bluetooth_disabled, size: 60, color: orangeColor),
                  SizedBox(height: 15),
                  Text('Estado del dispositivo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Desconectado', style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.bluetooth),
                label: const Text('Conectar Bluetooth', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: orangeColor,
                  side: const BorderSide(color: orangeColor, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
                },
                icon: const Icon(Icons.phone),
                label: const Text('Número de emergencia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar sesión', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  static const Color orangeColor = Color(0xFFFF6200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: orangeColor,
        title: const Text('Registro', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.person_add, size: 90, color: orangeColor),
              const SizedBox(height: 20),
              const Text('Crear cuenta', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: orangeColor)),
              const SizedBox(height: 40),
              TextField(
                controller: userController,
                decoration: _inputDecoration(hintText: 'Usuario', icon: Icons.person),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration(hintText: 'Contraseña', icon: Icons.lock),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration(hintText: 'Confirmar contraseña', icon: Icons.lock_outline),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () {
                    if (userController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Llena todos los campos')));
                      return;
                    }
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta registrada correctamente')));
                    Navigator.pop(context);
                  },
                  child: const Text('Registrarse', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText, required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: orangeColor),
      prefixIcon: Icon(icon, color: orangeColor),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: orangeColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: orangeColor, width: 2),
      ),
    );
  }
}

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController _numberController = TextEditingController();
  final UserDataService _service = UserDataService();
  String? _savedNumber;

  static const Color orangeColor = Color(0xFFFF6200);

  @override
  void initState() {
    super.initState();
    _loadNumber();
  }

  Future<void> _loadNumber() async {
    final number = await _service.getEmergencyNumber();
    setState(() => _savedNumber = number);
  }

  Future<void> _saveNumber() async {
    await _service.saveEmergencyNumber(_numberController.text);
    await _loadNumber();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número guardado correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: orangeColor,
        title: const Text('Número de emergencia', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.phone, size: 80, color: orangeColor),
            const SizedBox(height: 20),
            if (_savedNumber != null)
              Text('Número actual: $_savedNumber', style: const TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 30),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Ingresa el número',
                prefixIcon: const Icon(Icons.phone, color: orangeColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: orangeColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: orangeColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: _saveNumber,
                child: const Text('Guardar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}