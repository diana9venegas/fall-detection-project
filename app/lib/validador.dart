class Validador {
  static String? validarNumero(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'El número es obligatorio';
    }
    // Verifica que sean exactamente 10 dígitos
    if (valor.length != 10) {
      return 'El número debe tener 10 dígitos';
    }
    // Verifica que solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(valor)) {
      return 'Ingresa solo números';
    }
    return null; // El número es válido
  }
}