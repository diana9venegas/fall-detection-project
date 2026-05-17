import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'services/user_data_service.dart';
import 'logica_principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  final TextEditingController emailController = TextEditingController();
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
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: orangeColor),
                ),
                const SizedBox(height: 35),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: orangeColor, fontSize: 18),
                  decoration: _inputDecoration(hintText: 'Correo', icon: Icons.email),
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
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null && !user.emailVerified) {
                          await FirebaseAuth.instance.signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Verifica tu correo antes de entrar. Revisa tu bandeja de entrada.')),
                          );
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correo o contraseña incorrectos')));
                      }
                    },
                    child: const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: const Text('Registrarse', style: TextStyle(color: orangeColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () {
                    final resetEmailCtrl = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Recuperar contraseña'),
                        content: TextField(
                          controller: resetEmailCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: orangeColor, foregroundColor: Colors.white),
                            onPressed: () async {
                              if (resetEmailCtrl.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa tu correo')));
                                return;
                              }
                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmailCtrl.text.trim());
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correo de recuperación enviado')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correo no encontrado')));
                              }
                            },
                            child: const Text('Enviar'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.black54, fontSize: 16)),
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
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: orangeColor, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: orangeColor, width: 2)),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color orangeColor = Color(0xFFFF6200);
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      setState(() {
        _userName = doc.data()?['nombre'] ?? '';
      });
    }
  }

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
            Text(
              _userName.isNotEmpty ? 'Bienvenido, $_userName' : 'Bienvenido',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: orangeColor),
            ),
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
                label: const Text('Contactos de emergencia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
                controller: nameController,
                decoration: _inputDecoration(hintText: 'Nombre completo', icon: Icons.person),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: _inputDecoration(hintText: 'Correo', icon: Icons.email),
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
                  onPressed: () async {
                    if (nameController.text.isEmpty || emailController.text.isEmpty ||
                        passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Llena todos los campos')));
                      return;
                    }
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
                      return;
                    }
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      await credential.user!.sendEmailVerification();
                      await FirebaseFirestore.instance.collection('usuarios').doc(credential.user!.uid).set({
                        'nombre': nameController.text.trim(),
                        'correo': emailController.text.trim(),
                        'contactos_emergencia': [],
                        'fecha_registro': FieldValue.serverTimestamp(),
                      });
                      await FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta creada. Revisa tu correo para verificarla antes de entrar.')));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
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
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: orangeColor, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: orangeColor, width: 2)),
    );
  }
}

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  static const Color orangeColor = Color(0xFFFF6200);
  List<Map<String, String>> _contactos = [];

  @override
  void initState() {
    super.initState();
    _loadContactos();
  }

  Future<void> _loadContactos() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      final data = doc.data();
      if (data != null && data['contactos_emergencia'] != null) {
        final lista = List<Map<String, dynamic>>.from(data['contactos_emergencia']);
        setState(() {
          _contactos = lista.map((c) => {
            'nombre': c['nombre'].toString(),
            'numero': c['numero'].toString(),
          }).toList();
        });
      }
    }
  }

  Future<void> _guardarContactos() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
        'contactos_emergencia': _contactos,
      });
    }
  }

  void _agregarContacto() {
    if (_contactos.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Máximo 3 contactos de emergencia')));
      return;
    }
    final nombreCtrl = TextEditingController();
    final numeroCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar contacto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numeroCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Número', prefixIcon: Icon(Icons.phone)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: orangeColor, foregroundColor: Colors.white),
            onPressed: () async {
              if (nombreCtrl.text.isEmpty || numeroCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Llena todos los campos')));
                return;
              }
              setState(() {
                _contactos.add({'nombre': nombreCtrl.text.trim(), 'numero': numeroCtrl.text.trim()});
              });
              await _guardarContactos();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contacto agregado')));
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarContacto(int index) async {
    setState(() => _contactos.removeAt(index));
    await _guardarContactos();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contacto eliminado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: orangeColor,
        title: const Text('Contactos de emergencia', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('Tus contactos de emergencia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('${_contactos.length}/3 contactos', style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 20),
            Expanded(
              child: _contactos.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_disabled, size: 80, color: Colors.black26),
                          SizedBox(height: 10),
                          Text('No tienes contactos de emergencia', style: TextStyle(color: Colors.black45, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _contactos.length,
                      itemBuilder: (context, index) {
                        final contacto = _contactos[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: orangeColor,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(contacto['nombre']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(contacto['numero']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarContacto(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_contactos.length < 3)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: _agregarContacto,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar contacto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}