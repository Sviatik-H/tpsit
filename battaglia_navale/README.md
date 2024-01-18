# Battaglia Navale

Gioco **Battaglia navale** (*battleship*) in **Flutter**
[Terza consegna flutter](https://gitlab.com/zclassroom/consegne/-/blob/main/2324/flutter_03_battaglia_navale.md?ref_type=heads)

## Server

Il *server* è gestito tramite un `ServerSocket` in **dart**, quindi connessione **TCP**, sulla porta 3000.
Il *server* fa da tramite dei messaggi tra i due giocatori e gestisce più partite alla volta.

```dart
String uTurn = 'YOU';
String oTurn = 'OPP';

void messageHandler(data) {
    String message = new String.fromCharCodes(data);

    switch(message){
      case 'HIT' || 'SUNK':
        sendToPlayer(this, message);
        sendMessage(this, oTurn);
        sendToPlayer(this, uTurn);
        break;
      case 'MISS':
        sendToPlayer(this, message);
        sendMessage(this, uTurn);
        sendToPlayer(this, oTurn);
        break;
      case 'WON':
        sendToPlayer(this, 'LOST');
        break;
      default:
        sendToPlayer(this, message);
        break;
    }
  }
```
>Questo è il metodo chiamato quando il *server* riceve un messaggio dal *client*

Essendo che il *server* può possibilmente contenere un numero elevato di giocatori, ho deciso che non contenga dentro di sé per nulla la logica del gioco, che verrà invece gestita dai *client*.

La struttura dati che contiene tutte le partite e i giocatori è `List<List<Player>> games`, dove ad ogni elemento che mi rappresenta una partita ho una `List<Player>` contenenti le due connessioni ai *client*.

## Client

I *client* sia testuali che grafici condividono le due stesse librerie `client.dart` e `battleship.dart`. La prima gestisce la connessione al server mentre l'altra si occupa della gestione del gioco. Poi a seconda che il client sia testuale o app flutter hanno una libreria `main.dart` che contiene l'interfacciamento con l'utente.

```dart
  late Socket _socket;
  bool connected = false;
  var commands;

  Client._connect(Socket s) {
    this._socket = s;
    connected = true;
    this.commands = _socket.asBroadcastStream();
    commands.listen(dataHandler,
        onError: errorHandler, onDone: doneHandler, cancelOnError: false);
  }

  Client._failedConnection() {
    connected = false;
  }

  static Future<Client> connect(String ip) async {
    return await Socket.connect(ip, 3000).then((Socket sock) {
      return Client._connect(sock);
    }, onError: (e) {
      return Client._failedConnection();
    });
  }
```
>Per far si che un giocatore si connetta, per creare il `Client`, viene chiamato il metodo `connect(String ip)` che restituisce un oggetto `Client` a seconda dell'esito della connessione.

Essendo quindi che sia il **client mobile** che quello **testuale** usano lo stesso tipo di connessione e comunicazione con il *server*, sono compatibili fra loro.
