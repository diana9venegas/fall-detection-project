import 'validador.dart'; // Tu trabajo
import 'services/user_data_service.dart'; // Trabajo de Diana
import 'services/ble_service.dart'; // Trabajo de Nahomi

class LogicaPrincipal {
  final UserDataService _storage = UserDataService();
  final BleService _ble = BleService();

  // ESTA ES LA UNIÓN DE TODO EL EQUIPO
  Future<String?> procesarNuevoContacto(String numero) async {
    // 1. Validar (Tu parte)
    String? error = Validador.validarNumero(numero);
    
    if (error != null) {
      return error; // Si hay error, detenemos todo y avisamos
    }

    // 2. Guardar (Parte de Diana)
    await _storage.saveEmergencyNumber(numero);
    print("Guardado en memoria: $numero");

    // 3. Enviar por Bluetooth (Parte de Nahomi)
    try {
      await _ble.enviarDato(numero);
      print("Enviado al dispositivo: $numero");
      return null; // Todo salió bien
    } catch (e) {
      return "Error al enviar por Bluetooth: $e";
    }
  }
}