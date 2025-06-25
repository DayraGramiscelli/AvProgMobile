# Guardião de Vagas

Um aplicativo Flutter para salvar e encontrar a vaga do seu carro em estacionamentos.

## Funcionalidades

- 📍 Salvar a localização atual da vaga do carro
- 🗺️ Visualizar a vaga salva no mapa
- 🗑️ Limpar vaga salva
- 📱 Interface simples e intuitiva

## Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento
- **Dart** - Linguagem de programação
- **geolocator** - Plugin para localização
- **google_maps_flutter** - Plugin para mapas do Google
- **shared_preferences** - Armazenamento local

## Requisitos

- Flutter SDK 3.0.0 ou superior
- Android SDK 21 ou superior
- Java 17 (para compilação Android)

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/guardiao-de-vagas.git
cd guardiao-de-vagas
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a chave da API do Google Maps:
   - Edite o arquivo `android/app/src/main/AndroidManifest.xml`
   - Substitua `SUA_CHAVE_AQUI` pela sua chave da API do Google Maps

4. Execute o aplicativo:
```bash
flutter run
```

## Estrutura do Projeto

```
lib/
├── main.dart              # Arquivo principal
├── map_screen.dart        # Tela do mapa
└── vaga_repository.dart   # Repositório de dados
```

## Como Usar

1. Abra o aplicativo
2. Toque em "Salvar Vaga Atual" para salvar sua localização
3. Use "Ver no Mapa" para visualizar a vaga salva
4. Use "Limpar Vaga" para remover a vaga salva

## Licença

Este projeto está sob a licença MIT.
