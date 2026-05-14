import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_uuids.dart';

class BleService {
  BluetoothDevice? device;

  // Escanea y se conecta automáticamente al dispositivo del proyecto
  Future<void> escanearYConectar({
    required Function(BluetoothDevice) onConectado,
  }) async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        final nombre = r.device.platformName;
        if (nombre == 'Atom-BLE') {
          FlutterBluePlus.stopScan();
          await r.device.connect(autoConnect: false);
          device = r.device;
          onConectado(r.device);
          break;
        }
      }
    });
  }

  // FUNCIÓN CLAVE PARA LA INTEGRACIÓN: Envía el número validado
  Future<void> enviarDato(String valor) async {
    if (device == null) return;
    List<BluetoothService> services = await device!.discoverServices();
    for (BluetoothService s in services) {
      if (s.uuid == Guid(serviceUUID)) {
        for (BluetoothCharacteristic c in s.characteristics) {
          if (c.uuid == Guid(writeUUID)) {
            // Convierte el texto en bytes para el envío
            await c.write(valor.codeUnits);
            return;
          }
        }
      }
    }
  }

  // Recibe datos del sensor en tiempo real
  Future<void> suscribirSensor({
    required Function(String dato) onDato,
  }) async {
    if (device == null) return;
    List<BluetoothService> services = await device!.discoverServices();
    for (BluetoothService s in services) {
      if (s.uuid == Guid(serviceUUID)) {
        for (BluetoothCharacteristic c in s.characteristics) {
          if (c.uuid == Guid(notifyUUID)) {
            await c.setNotifyValue(true);
            c.lastValueStream.listen((bytes) {
              final dato = String.fromCharCodes(bytes);
              onDato(dato);
            });
            return;
          }
        }
      }
    }
  }

  Future<void> desconectar() async {
    await device?.disconnect();
    device = null;
  }
}