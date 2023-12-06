import 'dart:async';
import 'dart:io';

class Client {
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

  void sendMessage(String message) {
    _socket.write(message);
  }

  void dataHandler(data) {
    //print(String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    _socket.destroy();
  }
}
