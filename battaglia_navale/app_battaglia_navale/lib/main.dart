import 'dart:async';

import 'package:app_battaglia_navale/battleship.dart';
import 'package:flutter/material.dart';

Battleship b = Battleship(10);

Map<String, int> shipsToPlace = {
  'Carrier': 1,
  'Submarine': 2,
  'Cruiser': 3,
  'Destroyer': 4
};

List<Ship> ships = [];

void main() {
  runApp(const BattleShipApp());
}

class BattleShipApp extends StatelessWidget {
  const BattleShipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.blue[300],
          primaryColorLight: Colors.blue[200],
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue[300],
              foregroundColor: Colors.indigo),
          canvasColor: const Color.fromARGB(255, 66, 66, 66),
          toggleButtonsTheme: ToggleButtonsThemeData(
            selectedBorderColor: Colors.blue,
            selectedColor: Colors.indigo,
            fillColor: Colors.blue[200],
            borderColor: Colors.blue[300],
            color: Colors.white,
            borderWidth: 5,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.blue[200],
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool adding = false;
  bool removing = false;
  var text = 'Place your ships';
  var _context;
  String placing = '';
  int placingDimension = 0;
  int placingDirection = 1;
  List<Widget> _directions = <Widget>[
    //Text('North'),
    const Icon(Icons.arrow_upward_rounded),
    //Text('East'),
    const Icon(Icons.arrow_forward_rounded),
    //Text('South'),
    const Icon(Icons.arrow_downward_rounded),
    //Text('West'),
    const Icon(Icons.arrow_back_rounded),
  ];
  var _selectedDiretions = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: b.side + 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              children: createCells(b.sector),
            ),
          ),
          ToggleButtons(
            direction: Axis.horizontal,
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedDiretions.length; i++) {
                  _selectedDiretions[i] = i == index;
                }
                placingDirection = index + 1;
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: _selectedDiretions,
            children: _directions,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startGame(),
        child: const Icon(Icons.start),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 75,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () => addShip(),
                icon: Icon(
                  Icons.add,
                  color: adding ? Colors.indigo : Colors.white,
                  size: 35,
                )),
            IconButton(
                onPressed: () => removeShip(),
                icon: Icon(
                  Icons.remove,
                  color: removing ? Colors.indigo : Colors.white,
                  size: 35,
                )),
          ],
        ),
      ),
    );
  }

  startGame() {
    var text;
    int sum = 0;
    shipsToPlace.forEach((key, value) {
      sum = value + sum;
    });
    sum != 0
        ? text = Text(
            "You must first place all of your ships!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: List.filled(
                    10, const Shadow(color: Colors.black, blurRadius: 5))),
          )
        : text = Text('Insert the IP of the server to connect to:',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: List.filled(
                    10, const Shadow(color: Colors.black, blurRadius: 5))));
    bool readyToConnect = false;

    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).primaryColorLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: text,
              content: sum == 0
                  ? readyToConnect
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(child: CircularProgressIndicator()))
                      : TextField(
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: List.filled(
                                  10,
                                  const Shadow(
                                      color: Colors.black, blurRadius: 5))),
                          onSubmitted: (value) async {
                            setState(
                              () {
                                readyToConnect = true;
                                text = Text("Trying to connect to ${value} ...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: List.filled(
                                            10,
                                            const Shadow(
                                                color: Colors.black,
                                                blurRadius: 5))));
                              },
                            );
                            bool result = await b.startGame(value);
                            setState(
                              () {
                                text = Text(
                                    'Insert the IP of the server to connect to:',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: List.filled(
                                            10,
                                            const Shadow(
                                                color: Colors.black,
                                                blurRadius: 5))));
                              },
                            );
                            readyToConnect = false;
                            if (result) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      title: Text('Waiting for an opponent...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: List.filled(
                                                  10,
                                                  const Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 5)))),
                                      content: const SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    );
                                  });
                              late StreamSubscription c;
                              c = b.communication().listen((command) {
                                if (command == 'YOU' || command == 'OPP') {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GamePage(
                                              command == 'YOU'
                                                  ? true
                                                  : false)));
                                  c.cancel();
                                }
                              });
                              ships = b.ships;
                            } else {
                              showDialog(
                                  context: _context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      content: Text(
                                          'Connection failed, try with a different IP',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: List.filled(
                                                  10,
                                                  const Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 5)))),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    );
                                  });
                            }
                          },
                        )
                  : null,
              actions: [
                Visibility(
                    visible: !readyToConnect,
                    child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CLOSE')))
              ],
            );
          });
        });
  }

  addShip() {
    if (removing) removing = false;
    List<Widget> actions = [];
    var text;
    int sum = 0;
    shipsToPlace.forEach((key, value) {
      sum = value + sum;
    });
    sum == 0
        ? text = Center(
            child: Text(
                "All ships are in position, start the game or remove a ship",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: List.filled(
                        10, const Shadow(color: Colors.black, blurRadius: 5)))))
        : text = Center(
            child: Text('Select ships to place:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: List.filled(10,
                        const Shadow(color: Colors.black, blurRadius: 5)))));

    for (String s in shipsToPlace.keys) {
      if (shipsToPlace[s] == 0) continue;
      actions.add(TextButton(
          onPressed: () {
            adding = true;
            placing = s;
            setState(() {});
            switch (s) {
              case "Carrier":
                placingDimension = 5;
                break;
              case "Submarine":
                placingDimension = 4;
                break;
              case "Cruiser":
                placingDimension = 3;
                break;
              case "Destroyer":
                placingDimension = 2;
                break;
            }
            Navigator.pop(_context);
          },
          child: Text(
            '$s (x${shipsToPlace[s]})',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          )));
    }
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColorLight,
            title: text,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            actions: actions,
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsOverflowAlignment: OverflowBarAlignment.center,
          );
        });
  }

  removeShip() {
    if (adding) adding = false;
    var text;
    int sum = 0;
    shipsToPlace.forEach((key, value) {
      sum = value + sum;
    });
    if (sum == 10) {
      text = Center(
          child: Text("There are no ship to remove, try placing some",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: List.filled(
                      10, const Shadow(color: Colors.black, blurRadius: 5)))));
      removing = false;
    } else {
      text = Center(
          child: Text('Click on a ship to remove',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: List.filled(
                      10, const Shadow(color: Colors.black, blurRadius: 5)))));
      removing = true;
    }
    setState(() {});
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColorLight,
            title: text,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          );
        });
  }

  createCells(sector) {
    List<Widget> cells = [];

    var child;
    bool even = true;
    var color = Colors.blue[200];
    var l = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    cells.add(Container(
      child: const Center(
        child: Text(''),
      ),
    ));
    for (int i = 0; i < sector.length; ++i) {
      cells.add(Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(l[i].toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: List.filled(
                      10, const Shadow(color: Colors.black, blurRadius: 5)))),
        ),
      ));
    }
    for (int y = 0; y < sector.length; ++y) {
      cells.add(Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text((y + 1).toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: List.filled(
                      10, const Shadow(color: Colors.black, blurRadius: 5)))),
        ),
      ));
      for (int x = 0; x < sector.length; x++) {
        var content = sector[x][y];
        even ? color = Colors.blue[200] : color = Colors.blue[300];
        even = !even;
        //cell child and color
        switch (content) {
          case -1:
            child = const Text('');
            break;
          default:
            color = setColor(content);
            break;
        }
        cells.add(GestureDetector(
            onTap: () {
              if (adding) {
                if (b.addShip(placingDirection, placingDimension, y, x)) {
                  shipsToPlace[placing] = shipsToPlace[placing]! - 1;
                  if (shipsToPlace[placing] == 0) {
                    placing = '';
                    adding = false;
                  }
                  setState(() {});
                }
              }
              if (removing) {
                int d = -1;
                for (int i = 0; i < b.ships.length; ++i) {
                  if (b.ships[i].id == content) {
                    d = b.ships[i].dimension;
                    break;
                  }
                }
                if (b.cancelShip(content)) {
                  switch (d) {
                    case 5:
                      shipsToPlace['Carrier'] = shipsToPlace['Carrier']! + 1;
                      break;
                    case 4:
                      shipsToPlace['Submarine'] =
                          shipsToPlace['Submarine']! + 1;
                      break;
                    case 3:
                      shipsToPlace['Cruiser'] = shipsToPlace['Cruiser']! + 1;
                      break;
                    case 2:
                      shipsToPlace['Destroyer'] =
                          shipsToPlace['Destroyer']! + 1;
                      break;
                  }
                  setState(() {
                    int sum = 0;
                    shipsToPlace.forEach((key, value) {
                      sum = value + sum;
                    });
                    if (sum == 10) removing = false;
                  });
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: child,
              ),
            )));
      }
      even = !even;
    }
    return cells;
  }
}

class GamePage extends StatefulWidget {
  final bool starting;
  const GamePage(this.starting);
  @override
  State<GamePage> createState() => GamePageState(starting);
}

class GamePageState extends State<GamePage> {
  GamePageState(bool starting) {
    myTurn = starting;
    startGame();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(140, 50, 140, 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(77),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.directions_boat_filled_rounded,
                    color: Colors.indigo, size: 35),
                Text(
                  enemyShips.toString(),
                  style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                )
              ],
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: myTurn ? 1 : 0.5,
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: b.side + 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                children: createCells(b.opponent, clickable: true),
              ),
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: myTurn ? 0.5 : 1,
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: b.side + 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: createCells(b.sector),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int enemyShips = 10;
  String coords = "";
  bool myTurn = false;

  startGame() {
    late StreamSubscription c;
    c = b.communication().listen((command) {
      switch (command) {
        case 'YOU':
          setState(() {
            myTurn = true;
          });
          break;
        case 'OPP':
          setState(() {
            myTurn = false;
          });
          break;
        case 'HIT':
          setState(() {
            int column, row;
            column = translateColumn(coords[0]);
            coords.length == 2
                ? row = int.parse(coords[1]) - 1
                : row = int.parse(coords[1] + coords[2]) - 1;
            b.revealCell(column, row, hit: true);
          });
          break;
        case 'SUNK':
          --enemyShips;
          int column, row;
          column = translateColumn(coords[0]);
          coords.length == 2
              ? row = int.parse(coords[1]) - 1
              : row = int.parse(coords[1] + coords[2]) - 1;
          b.revealCell(column, row, hit: true);
          if (enemyShips == 0) {
            b.send('WON');
            endGameDialog("You sunk all of your enemy's fleet, you won!!");
          }
          break;
        case 'MISS':
          int column, row;
          column = translateColumn(coords[0]);
          coords.length == 2
              ? row = int.parse(coords[1]) - 1
              : row = int.parse(coords[1] + coords[2]) - 1;
          b.revealCell(column, row);
          break;

        case 'LOST':
          endGameDialog('All of your fleet was sunk, you lost...');
          c.cancel();
          break;
        case 'DISCONNECTED':
          endGameDialog('You won since your opponent disconnected.');
          break;
        case 'WAIT':
          break;
        case 'READY':
          break;
        default:
          int column, row;
          column = translateColumn(command[0]);
          command.length == 2
              ? row = int.parse(command[1]) - 1
              : row = int.parse(command[1] + command[2]) - 1;
          b.send(b.check(column, row));
          break;
      }
    });
  }

  endGameDialog(String text) {
    b.end();

    showDialog(
      context: context,
      builder: (_context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: List.filled(
                      10, const Shadow(color: Colors.black, blurRadius: 5)))),
          actions: [
            TextButton(
                onPressed: () {
                  b = Battleship(10);
                  placePreviousShips();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  createCells(sector, {bool clickable = false}) {
    List<Widget> cells = [];

    var child;
    bool even = true;
    var color = Colors.blue[200];
    var l = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    cells.add(Container(
      child: const Center(
        child: Text(''),
      ),
    ));
    for (int i = 0; i < sector.length; ++i) {
      cells.add(Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            l[i].toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: List.filled(
                  10, const Shadow(color: Colors.black, blurRadius: 5)),
            ),
          ),
        ),
      ));
    }
    for (int y = 0; y < sector.length; ++y) {
      cells.add(Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            (y + 1).toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: List.filled(
                  10, const Shadow(color: Colors.black, blurRadius: 5)),
            ),
          ),
        ),
      ));
      for (int x = 0; x < sector.length; x++) {
        var content = sector[x][y];
        even ? color = Colors.blue[200] : color = Colors.blue[300];
        even = !even;
        child = const Text('');
        //cell child and color
        switch (content) {
          case -1:
            child = const Text('');
            break;
          case -2:
            child = const Icon(
              Icons.circle,
              color: Colors.white,
            );
            break;
          case -3:
            child = const Icon(
              Icons.circle,
              color: Colors.red,
            );
            if (!clickable) {
              for (Ship s in ships) {
                for (List coordinates in s.coordinates) {
                  if (coordinates[0] == x && coordinates[1] == y) {
                    color = setColor(s.id);
                    break;
                  }
                }
              }
            }
            break;
          case -4:
            child = const Icon(
              Icons.circle,
              color: Colors.red,
            );
            color = Colors.blueGrey[300];
            break;
          default:
            color = setColor(content);
            break;
        }

        var cell = Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: child,
          ),
        );
        cells.add(clickable
            ? GestureDetector(
                onTap: () {
                  if (myTurn) {
                    if (b.opponent[x][y] == -1) {
                      coords = encodeColumn(x) + (y + 1).toString();
                      b.send(coords);
                    }
                  }
                },
                child: cell)
            : cell);
      }
      even = !even;
    }
    return cells;
  }
}

String encodeColumn(int c) {
  switch (c) {
    case 0:
      return 'A';
    case 1:
      return 'B';
    case 2:
      return 'C';
    case 3:
      return 'D';
    case 4:
      return 'E';
    case 5:
      return 'F';
    case 6:
      return 'G';
    case 7:
      return 'H';
    case 8:
      return 'I';
    case 9:
      return 'J';
  }
  return '';
}

int translateColumn(String c) {
  switch (c) {
    case 'A':
      return 0;
    case 'B':
      return 1;
    case 'C':
      return 2;
    case 'D':
      return 3;
    case 'E':
      return 4;
    case 'F':
      return 5;
    case 'G':
      return 6;
    case 'H':
      return 7;
    case 'I':
      return 8;
    case 'J':
      return 9;
    default:
      return -1;
  }
}

placePreviousShips() {
  for (Ship s in ships) {
    b.addShip(s.facing, s.dimension, s.coordinates[0][1], s.coordinates[0][0]);
  }
}

setColor(int id) {
  var color;
  switch (id) {
    case 0:
      color = Colors.red[800];
      break;
    case 1:
      color = Colors.orange;
      break;
    case 2:
      color = Colors.yellow;
      break;
    case 3:
      color = Colors.limeAccent[700];
      break;
    case 4:
      color = Colors.green;
      break;
    case 5:
      color = Colors.teal;
      break;
    case 6:
      color = Colors.indigo;
      break;
    case 7:
      color = Colors.purple;
      break;
    case 8:
      color = Colors.deepPurpleAccent;
      break;
    case 9:
      color = Colors.pink[200];
      break;
  }
  return color;
}
