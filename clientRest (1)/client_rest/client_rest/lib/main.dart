import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Punto di ingresso principale dell'applicazione Flutter.
void main() {
  runApp(MyApp());
}

// Widget principale che configura l'app Flutter.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dipendente App',
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Imposta i toni di giallo come colore primario.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.yellowAccent[700], // Colore di sfondo principale giallo intenso.
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainPage(),
      },
    );
  }
}

// Widget per lo SplashScreen che viene visualizzato all'avvio dell'app.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800], // Sfondo giallo scuro per lo SplashScreen.
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow, // Bottone giallo.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
          child: Text(
            'Entra',
            style: TextStyle(
              color: Colors.white, // Testo bianco per contrasto.
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget per la pagina principale dell'app.
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  Future<void> _fetchData(String code) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('http://10.0.2.2:8080/index.php?codice=$code'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        if (jsonData['stato'] == 'OK-1') {
          _response = "Stato: ${jsonData['stato']}\n"
                      "Messaggio: ${jsonData['messaggio']}\n"
                      "Codice: ${jsonData['codice']}\n"
                      "Nome: ${jsonData['nome']}\n"
                      "Cognome: ${jsonData['cognome']}\n"
                      "Reparto: ${jsonData['reparto']}";
        } else if (jsonData['stato'] == 'OK-2') {
          _response = "Stato: ${jsonData['stato']}\n"
                      "Messaggio: ${jsonData['messaggio']}";
        } else {
          _response = "Errore: stato sconosciuto";
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _response = 'Errore durante la richiesta';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[850], // AppBar giallo scuro.
        title: Text(
          'Dati Dipendente',
          style: TextStyle(color: Colors.white), // Testo bianco per leggibilità.
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.black), // Testo nero per leggibilità su sfondo chiaro.
              decoration: InputDecoration(
                labelText: 'Codice Dipendente',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Bordi gialli.
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Bordi bianchi per il focus.
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.person, color: Colors.black), // Icona persona in nero.
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                      _fetchData(_controller.text);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Bottone giallo.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Spinner bianco.
                    )
                  : Text(
                      'Invia Richiesta',
                      style: TextStyle(fontSize: 18.0, color: Colors.black), // Testo nero.
                    ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _response,
                    style: TextStyle(fontSize: 16, color: Colors.black), // Testo nero.
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
