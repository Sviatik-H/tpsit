import 'client.dart';

class Battleship {
  /*
    0 -> 1  SHIP ID   0 - > 1
    -1                ~
    -2      MISS      O
    -3      HIT       x
    '4      SUNK      X

  */

  List<List<int>> sector = [];
  List<List<int>> opponent = [];
  List<Ship> ships = [];
  int side = 10;
  late Client client;

  Battleship(int side) {
    this.side = side;
    for (int i = 0; i < side; ++i) {
      sector.add([]);
      opponent.add([]);
      for (int j = 0; j < side; ++j) {
        sector[i].add(-1);
        opponent[i].add(-1);
      }
    }
    Ship.staticIds = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  }

  bool addShip(int direction, int dimension, int row, int column) {
    late Ship ship;
    switch (direction) {
      case 1:
        ship = Ship.nord(dimension, column, row, this.side);
        break;
      case 2:
        ship = Ship.east(dimension, column, row, this.side);
        break;
      case 3:
        ship = Ship.south(dimension, column, row, this.side);
        break;
      case 4:
        ship = Ship.west(dimension, column, row, this.side);
        break;
      default:
        return false;
    }
    if (ship.id == -1) return false;
    for (List coordinates in ship.coordinates) {
      if (sector[coordinates[0]][coordinates[1]] != -1) {
        Ship.staticIds.add(ship.id);
        return false;
      }
    }
    for (List coordinates in ship.coordinates) {
      sector[coordinates[0]][coordinates[1]] = ship.id;
    }
    ships.add(ship);
    return true;
  }

  bool cancelShip(int id) {
    var ship;
    for (int i = 0; i < ships.length; ++i) {
      if (ships[i].id == id) {
        ship = ships[i];
        break;
      } else {
        if (i == ships.length - 1) {
          return false;
        }
      }
    }
    for (List coordinates in ship.coordinates) {
      if (sector[coordinates[0]][coordinates[1]] == ship.id)
        sector[coordinates[0]][coordinates[1]] = -1;
    }
    Ship.staticIds.add(id);
    ships.remove(ship);
    return true;
  }

  Future<bool> startGame(String ip) async {
    client = await Client.connect(ip);
    return client.connected ? true : false;
  }

  String check(int column, int row) {
    if (sector[column][row] == -1) {
      sector[column][row] = -2;
      return 'MISS';
    }
    return _checkShip(column, row);
  }

  String _checkShip(int column, int row) {
    var ship;
    for (int i = 0; i < ships.length; ++i) {
      if (ships[i].id == sector[column][row]) {
        ship = ships[i];
        break;
      }
    }
    sector[column][row] = -3;

    for (List coordinates in ship.coordinates) {
      if (sector[coordinates[0]][coordinates[1]] != -3) {
        return 'HIT';
      }
    }
    for (List coordinates in ship.coordinates) {
      sector[coordinates[0]][coordinates[1]] = -4;
    }

    return 'SUNK';
  }

  revealCell(int column, int row, {bool hit = false}) {
    !hit ? opponent[column][row] = -2 : opponent[column][row] = -3;
  }

  Stream<String> communication() async* {
    await for (var command in client.commands) {
      for (String s in String.fromCharCodes(command).trim().split('\n'))
        yield s;
    }
  }

  send(String message) {
    client.sendMessage(message);
  }

  end(){
    client.doneHandler();
  }
}

class Ship {
  static List<int> staticIds = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  int dimension = 0;
  int facing = 0; //  1-N   2-E   3-S   4-W
  List<List<int>> coordinates = [];
  int id = 0;

  Ship.nord(int dimension, int column, int row, int sectorSide) {
    for (int i = 0; i < dimension; ++i) {
      if (row < 0 || column < 0 || row >= sectorSide || column >= sectorSide) {
        id = -1;
        return;
      }
      coordinates.add([column, row]);
      ++row;
    }
    this.dimension = dimension;
    this.facing = 1;
    id = staticIds.removeAt(staticIds.length - 1);
  }

  Ship.east(int dimension, int column, int row, int sectorSide) {
    for (int i = 0; i < dimension; ++i) {
      if (row < 0 || column < 0 || row >= sectorSide || column >= sectorSide) {
        id = -1;
        return;
      }
      coordinates.add([column, row]);
      --column;
    }
    this.dimension = dimension;
    this.facing = 2;
    id = staticIds.removeAt(staticIds.length - 1);
  }

  Ship.south(int dimension, int column, int row, int sectorSide) {
    for (int i = 0; i < dimension; ++i) {
      if (row < 0 || column < 0 || row >= sectorSide || column >= sectorSide) {
        id = -1;
        return;
      }
      coordinates.add([column, row]);
      --row;
    }
    this.dimension = dimension;
    this.facing = 3;
    id = staticIds.removeAt(staticIds.length - 1);
  }

  Ship.west(int dimension, int column, int row, int sectorSide) {
    for (int i = 0; i < dimension; ++i) {
      if (row < 0 || column < 0 || row >= sectorSide || column >= sectorSide) {
        id = -1;
        return;
      }
      coordinates.add([column, row]);
      ++column;
    }
    this.dimension = dimension;
    this.facing = 4;
    id = staticIds.removeAt(staticIds.length - 1);
  }
}
