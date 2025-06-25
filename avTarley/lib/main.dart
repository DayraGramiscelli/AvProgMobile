import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'map_screen.dart';
import 'vaga_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  runApp(const GuardiaoDeVagasApp());
}

class GuardiaoDeVagasApp extends StatelessWidget {
  const GuardiaoDeVagasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardião de Vagas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Vaga? vaga;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadVaga();
  }

  Future<void> _loadVaga() async {
    vaga = await VagaRepository.getVaga();
    setState(() {
      loading = false;
    });
  }

  Future<void> _salvarVaga() async {
    setState(() => loading = true);
    try {
      Position pos = await Geolocator.getCurrentPosition();
      Vaga novaVaga = Vaga(
        latitude: pos.latitude,
        longitude: pos.longitude,
        dataHora: DateTime.now(),
      );
      await VagaRepository.salvarVaga(novaVaga);
      vaga = novaVaga;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização: $e')),
      );
    }
    setState(() => loading = false);
  }

  Future<void> _limparVaga() async {
    await VagaRepository.limparVaga();
    setState(() {
      vaga = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Guardião de Vagas')),
      body: Center(
        child: vaga == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nenhuma vaga salva',
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _salvarVaga,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Salvar Vaga Atual'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vaga salva em:\n${vaga!.dataHora.toString()}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreen(vaga: vaga!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Ver no Mapa'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _limparVaga,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Limpar Vaga'),
                  ),
                ],
              ),
      ),
    );
  }
}
