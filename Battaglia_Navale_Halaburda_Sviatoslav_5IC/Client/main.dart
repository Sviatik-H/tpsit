import 'dart:io';

import 'battleship.dart';

List<Ship> ships = [];
Future<void> main() async {
  Battleship battleship = Battleship(10);
  //Dimensions: carrier-5   submarine-4   cruiser-3   destroyer-2
  Map<String, int> shipsToPlace = {
    'Carrier': 1,
    'Submarine': 2,
    'Cruiser': 3,
    'Destroyer': 4
  };
  placePreviousShips(ships, battleship, shipsToPlace);
  while (await preMatch(battleship, shipsToPlace));
  print('Connected!!');
  String coords = "";
  int enemyShips = 10;
  ships = battleship.ships;

  battleship.communication().listen((command) {
    switch (command) {
      case 'YOU':
        printSectors(battleship);
        print("It's your turn!!\tEnemy's ships: $enemyShips");

        bool pass = false;
        do {
          try {
            int column, row;
            print("Insert where to shoot:");
            coords = stdin.readLineSync()!.toUpperCase().trim();
            column = translateColumn(coords[0]);
            coords.length == 2
                ? row = int.parse(coords[1]) - 1
                : row = int.parse(coords[1] + coords[2]) - 1;
            if (column != -1 && row >= 0 && row < battleship.side) {
              battleship.opponent[column][row] != -1
                  ? print("You already shot here...")
                  : pass = true;
            } else
              print("Error in writing the coordinates");
          } catch (e) {
            print("Invalid input");
          }
        } while (!pass);
        battleship.send(coords);
        break;
      case 'OPP':
        printSectors(battleship);
        print("It's your opponent's turn!\tEnemy's ships: $enemyShips");
        break;
      case 'HIT':
        print("You have hit an enemy's ship!");
        int column, row;
        column = translateColumn(coords[0]);
        coords.length == 2
            ? row = int.parse(coords[1]) - 1
            : row = int.parse(coords[1] + coords[2]) - 1;
        battleship.revealCell(column, row, hit: true);
        break;
      case 'SUNK':
        print("You have hit and sunk an enemy's ship!!");
        --enemyShips;
        int column, row;
        column = translateColumn(coords[0]);
        coords.length == 2
            ? row = int.parse(coords[1]) - 1
            : row = int.parse(coords[1] + coords[2]) - 1;
        battleship.revealCell(column, row, hit: true);
        if (enemyShips == 0) {
          battleship.send('WON');
          print("You sunk all of your enemy's fleet, you won!!");
          endGame(battleship);
        }
        break;
      case 'MISS':
        print("You have missed...");
        int column, row;
        column = translateColumn(coords[0]);
        coords.length == 2
            ? row = int.parse(coords[1]) - 1
            : row = int.parse(coords[1] + coords[2]) - 1;
        battleship.revealCell(column, row);
        break;
      case 'WAIT':
        print('Waiting for an opponent...');
        break;
      case 'READY':
        print('Match found!!');
        break;
      case 'LOST':
        print('All of your fleet was sunk, you lost...');
        endGame(battleship);
        break;
      case 'DISCONNECTED':
        print('You won since your opponent disconnected.');
        endGame(battleship);
        break;
      default:
        int column, row;
        column = translateColumn(command[0]);
        command.length == 2
            ? row = int.parse(command[1]) - 1
            : row = int.parse(command[1] + command[2]) - 1;
        battleship.send(battleship.check(column, row));
        break;
    }
  });
}

Future<bool> preMatch(Battleship b, Map<String, int> stp) async {
  print('1.\tPlace a ship\n2.\tRemove ship\n3.\tShow sector\n4.\tStart game');
  try {
    var choice = int.parse(stdin.readLineSync()!);
    switch (choice) {
      case 1:
        createShip(b, stp);
        return true;
      case 2:
        removeShip(b, stp);
        return true;
      case 3:
        printSectors(b);
        return true;
      case 4:
        int sum = 0;
        stp.forEach((key, value) {
          sum = value + sum;
        });
        if (sum != 0) {
          print("You must first place all of your ships!");
          return true;
        }
        print("Insert the IP of the server to connect to:");
        String ip = stdin.readLineSync()!.trim();
        print("Trying to connect to ${ip} ...");
        bool result = await b.startGame(ip);
        if (!result) print("Connection failed, try with a different IP");
        return !result;
      default:
        print("Invalid input");
        return true;
    }
  } catch (e) {
    print("Invalid input");
    return true;
  }
}

void createShip(Battleship b, Map stp) {
  try {
    int sum = 0;
    stp.forEach((key, value) {
      sum = value + sum;
    });
    if (sum == 0) {
      print("All ships are in position, start the game or remove a ship");
      return;
    }
    int direction, dimension, row, column;
    bool pass = false;
    String type;
    do {
      print(
          "Select the ship to place:\n1.\tCarrier (x${stp["Carrier"]})\n2.\tSubmarine (x${stp["Submarine"]})\n3.\tCruiser (x${stp["Cruiser"]})\n4.\tDestroyer (x${stp["Destroyer"]})\n");
      int choice = int.parse(stdin.readLineSync()!.trim());

      switch (choice) {
        case 1:
          type = "Carrier";
          dimension = 5;
          break;
        case 2:
          type = "Submarine";
          dimension = 4;
          break;
        case 3:
          type = "Cruiser";
          dimension = 3;
          break;
        case 4:
          type = "Destroyer";
          dimension = 2;
          break;
        default:
          print("Invalid input");
          return;
      }
      if (stp[type] > 0) {
        pass = true;
      } else {
        print("You already placed all this kind of ships, select another");
      }
    } while (!pass);
    printSectors(b);
    pass = false;
    do {
      print("Insert the facing direction (N/E/S/W) of your ship:");
      direction =
          translateDirection(stdin.readLineSync()!.toUpperCase().trim());
      print("Insert the coordinate from where it starts:");
      var coords = stdin.readLineSync()!.toUpperCase().trim();
      column = translateColumn(coords[0]);
      coords.length == 2
          ? row = int.parse(coords[1]) - 1
          : row = int.parse(coords[1] + coords[2]) - 1;
      if (direction != -1 && column != -1 && row >= 0 && row < b.side)
        pass = true;
      else
        print("Error in writing the data");
    } while (!pass);
    if (b.addShip(direction, dimension, row, column)) {
      print("Ship added to your sector");
      --stp[type];
    } else
      print("Failed adding ship, try with different data");
  } catch (e) {
    print("Invalid input");
  }
}

void removeShip(Battleship b, stp) {
  printSectors(b);
  print("Select the ship to remove:");
  stdout.write("(");
  for (int i = 0; i < b.ships.length; ++i) {
    i == b.ships.length - 1
        ? stdout.write(b.ships[i].id.toString())
        : stdout.write(b.ships[i].id.toString() + ", ");
  }
  print(')');
  try {
    int choice = int.parse(stdin.readLineSync()!.trim());
    int d = -1;
    for (int i = 0; i < b.ships.length; ++i) {
      if (b.ships[i].id == choice) {
        d = b.ships[i].dimension;
        break;
      }
    }
    if (b.cancelShip(choice)) {
      switch (d) {
        case 5:
          ++stp['Carrier'];
          break;
        case 4:
          ++stp['Submarine'];
          break;
        case 3:
          ++stp['Cruiser'];
          break;
        case 2:
          ++stp['Destroyer'];
          break;
      }
      print('Ship removed');
    } else {
      print('Failed to remove ship');
    }
    ;
  } catch (e) {
    print("Invalid input");
  }
}

void printSectors(Battleship b) {
  print("\tA B C D E F G H I J\t\tA B C D E F G H I J");
  for (int i = 0; i < b.side; ++i) {
    stdout.write((i + 1).toString() + "\t");
    for (int j = 0; j < b.side; ++j) {
      switch (b.sector[j][i]) {
        case -1:
          stdout.write('~ ');
          break;
        case -2:
          stdout.write('O ');
          break;
        case -3:
          stdout.write('x ');
          break;
        case -4:
          stdout.write('X ');
          break;
        default:
          stdout.write(b.sector[j][i].toString() + ' ');
          break;
      }
    }
    stdout.write("\t" + (i + 1).toString() + "\t");
    for (int j = 0; j < b.side; ++j) {
      switch (b.opponent[j][i]) {
        case -1:
          stdout.write('~ ');
          break;
        case -2:
          stdout.write('O ');
          break;
        case -3:
          stdout.write('x ');
          break;
        case -4:
          stdout.write('X ');
          break;
        default:
          stdout.write(b.opponent[j][i].toString() + ' ');
          break;
      }
    }
    print('');
  }
  print("___________________________________________________________");
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

int translateDirection(String c) {
  switch (c) {
    case 'N':
      return 1;
    case 'E':
      return 2;
    case 'S':
      return 3;
    case 'W':
      return 4;
    default:
      return -1;
  }
}

endGame(Battleship b) {
  b.end();
  main();
}

placePreviousShips(List<Ship> ships, Battleship b, Map stp) {
  for (Ship s in ships) {
    b.addShip(s.facing, s.dimension, s.coordinates[0][1], s.coordinates[0][0]);
    switch (s.dimension) {
      case 5:
        --stp['Carrier'];
        break;
      case 4:
        --stp['Submarine'];
        break;
      case 3:
        --stp['Cruiser'];
        break;
      case 2:
        --stp['Destroyer'];
        break;
    }
  }
}
