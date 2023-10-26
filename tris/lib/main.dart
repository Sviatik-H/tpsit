import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tris Game',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 27, 117, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tris Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> board = List.generate(3, (i) => List.filled(3, ''));
  bool playerX = true; // true per il giocatore X, false per il giocatore O;
  bool gameOver = false;

  bool checkWin(int row, int col) {
    String player = playerX ? 'X' : 'O';

    // Controllo le righe
    if (board[row][0] == player &&
        board[row][1] == player &&
        board[row][2] == player) {
      return true;
    }

    // Controllo le colonne
    if (board[0][col] == player &&
        board[1][col] == player &&
        board[2][col] == player) {
      return true;
    }

    // Controllo le diagonali
    if ((row == col || row + col == 2) &&
        ((board[0][0] == player &&
                board[1][1] == player &&
                board[2][2] == player) ||
            (board[0][2] == player &&
                board[1][1] == player &&
                board[2][0] == player))) {
      return true;
    }

    return false;
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (i) => List.filled(3, ''));
      playerX = true;
      gameOver = false;
    });
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(result),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _handleTap(int row, int col) {
    if (gameOver || board[row][col] != '') {
      return; // Ignora i tap se il gioco è finito o la cella è già occupata
    }

    setState(() {
      board[row][col] = playerX ? 'X' : 'O';

      if (checkWin(row, col)) {
        String result = '${playerX ? 'Player X' : 'Player O'} vince!';
        showResultDialog(context, result);
        gameOver = true;
      } else if (!board.any((row) => row.contains(''))) {
        String result = 'Pareggio!';
        showResultDialog(context, result);
        gameOver = true;
      } else {
        playerX = !playerX;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              gameOver
                  ? 'Game Over'
                  : (playerX ? 'Player X' : 'Player O') + "'s Turn",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(3, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (col) {
                    return InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text(
                            board[row][col],
                            style: TextStyle(fontSize: 48.0),
                          ),
                        ),
                      ),
                      onTap: () => _handleTap(row, col),
                    );
                  }),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
