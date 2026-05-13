import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  static const String _emergencyNumberKey = 'emergency_number';
  static const String _userNameKey = 'user_name';

  // Guardar número de emergencia
  Future<void> saveEmergencyNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emergencyNumberKey, number);
  }

  // Leer número de emergencia
  Future<String?> getEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emergencyNumberKey);
  }

  // Editar número de emergencia (mismo que guardar, sobreescribe)
  Future<void> updateEmergencyNumber(String newNumber) async {
    await saveEmergencyNumber(newNumber);
  }

  // Guardar nombre del usuario actual
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }
}