import 'dart:io';


/*

a.
  YOU   Your turn
  OPP   Opponent's turn

b.
  default (coordinates)
c.
  HIT
  MISS
  SUNK
d.
  WON
  LOST

x.
  ERROR
  DISCONNECTION
*/

late ServerSocket server;
List<List<Player>> games = [];
String uTurn = 'YOU';
String oTurn = 'OPP';

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000).then((ServerSocket socket) {
    server = socket;
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void insertPlayer(Player client) async{
  for (int i = 0; i < games.length; ++i) {
    if (games[i].length < 2) {
      games[i].add(client);
      client.gameIndex = i;
      client.playerIndex = 1;
      await Future.delayed(Duration(seconds: 1));
      sendMessage(client, 'READY');
      sendToPlayer(client, 'READY');
      sendMessage(client, oTurn);
      sendToPlayer(client, uTurn);
      return;
    }
  }
  games.add([client]);
  client.gameIndex = games.length - 1;
  client.playerIndex = 0;
  sendMessage(client, 'WAIT');
}

void handleConnection(Socket client) {
  print('Connection from '
      '${client.remoteAddress.address}:${client.remotePort}');

  insertPlayer(Player(client));
}

void removePlayer(Player client) {
  for (Player p in games[client.gameIndex]) {
    if (p != client) {
      p.close();
    }
  }
  games.removeAt(client.gameIndex);
  for(int i = 0; i < games.length; ++i){
    for(Player p in games[i]){
      p.gameIndex = i;
    }
  }
}

void sendMessage(Player client, String message) {
  for (Player p in games[client.gameIndex]) {
    if (p == client) {
      p.write(message + "\n");
    }
  }
}

void sendToPlayer(Player client, String message) {
  for (Player p in games[client.gameIndex]) {
    if (p != client) {
      p.write(message + "\n");
    }
  }
}

class Player {
  late Socket _socket;
  String get _address => _socket.remoteAddress.address;
  int get _port => _socket.remotePort;
  late int gameIndex, playerIndex;

  Player(Socket s) {
    _socket = s;
    _socket.listen(messageHandler, onError: errorHandler, onDone: disconnected);
  }

  void messageHandler(data) {
    String message = new String.fromCharCodes(data);

    switch(message){
      case 'HIT':
        sendToPlayer(this, message);
        sendMessage(this, oTurn);
        sendToPlayer(this, uTurn);
        break;
      case 'SUNK':
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

  void errorHandler(error) {
    if(gameIndex == -1)return;
    sendToPlayer(this, 'DISCONNECTED');
    removePlayer(this);
    close();
  }

  void disconnected() {
    if(gameIndex == -1)return;
    sendToPlayer(this, 'DISCONNECTED');
    print("done");
    removePlayer(this);
    close();
  }

  void write(String message) {
    _socket.write(message);
  }

  void close() {
    gameIndex = -1;
    _socket.close();
  }
}
