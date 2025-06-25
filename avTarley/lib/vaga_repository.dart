import 'package:shared_preferences/shared_preferences.dart';

class Vaga {
  final double latitude;
  final double longitude;
  final DateTime dataHora;

  Vaga(
      {required this.latitude,
      required this.longitude,
      required this.dataHora});

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'dataHora': dataHora.toIso8601String(),
      };

  static Vaga? fromJson(Map<String, dynamic> json) {
    try {
      return Vaga(
        latitude: json['latitude'],
        longitude: json['longitude'],
        dataHora: DateTime.parse(json['dataHora']),
      );
    } catch (_) {
      return null;
    }
  }
}

class VagaRepository {
  static const _key = 'vaga_salva';

  static Future<void> salvarVaga(Vaga vaga) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key,
        '${vaga.latitude};${vaga.longitude};${vaga.dataHora.toIso8601String()}');
  }

  static Future<Vaga?> getVaga() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return null;
    final parts = str.split(';');
    if (parts.length != 3) return null;
    try {
      return Vaga(
        latitude: double.parse(parts[0]),
        longitude: double.parse(parts[1]),
        dataHora: DateTime.parse(parts[2]),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> limparVaga() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
