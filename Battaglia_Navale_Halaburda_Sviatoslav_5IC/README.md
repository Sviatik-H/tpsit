# Relazione 

## Classe `Battleship`

La classe `Battleship` rappresenta la logica principale del gioco della Battaglia navale. Esaminiamo la sua struttura e funzionalità:

### Proprietà:

1. `List<List<int>> sector`: Rappresenta il settore del giocatore con lo stato di ogni cella.
2. `List<List<int>> opponent`: Rappresenta il settore dell'avversario con lo stato di ogni cella.
3. `List<Ship> ships`: Conserva l'elenco delle navi posizionate nel settore.
4. `int side`: Rappresenta la lunghezza del lato del settore (predefinita è 10).
5. `Client client`: Un'istanza della classe `Client` utilizzata per la comunicazione.

### Costruttore:

- `Battleship(int side)`: Inizializza l'istanza di Battleship con una lunghezza del lato specificata. Imposta i settori e inizializza gli ID delle navi.

### Metodi:

1. `bool addShip(int direction, int dimension, int row, int column)`: Aggiunge una nave al settore in base alla direzione, dimensione, riga e colonna specificate.
2. `bool cancelShip(int id)`: Annulla una nave in base al suo ID.
3. `Future<bool> startGame(String ip)`: Avvia una partita connettendosi a un server utilizzando l'indirizzo IP fornito.
4. `String check(int column, int row)`: Verifica lo stato di una cella specifica nel settore del giocatore.
5. `revealCell(int column, int row, {bool hit = false})`: Aggiorna il settore dell'avversario in base al risultato di uno sparo.
6. `Stream<String> communication()`: Ascolta i comandi dal client attraverso uno stream.
7. `send(String message)`: Invia un messaggio al server connesso.
8. `end()`: Chiude la connessione con il server.

## Classe `Ship`

La classe `Ship` rappresenta le singole navi nel gioco. Ha le seguenti proprietà:

### Proprietà:

1. `static List<int> staticIds`: Lista statica degli ID delle navi disponibili.
2. `int dimension`: Rappresenta la dimensione della nave.
3. `int facing`: Rappresenta la direzione in cui è orientata la nave (1-N, 2-E, 3-S, 4-W).
4. `List<List<int>> coordinates`: Conserva le coordinate della nave.
5. `int id`: Rappresenta l'ID univoco della nave.

### Costruttori:

- `Ship.nord(int dimension, int column, int row, int sectorSide)`: Inizializza una nave rivolta a nord.
- `Ship.east(int dimension, int column, int row, int sectorSide)`: Inizializza una nave rivolta a est.
- `Ship.south(int dimension, int column, int row, int sectorSide)`: Inizializza una nave rivolta a sud.
- `Ship.west(int dimension, int column, int row, int sectorSide)`: Inizializza una nave rivolta a ovest.

## Classe `Client`

La classe `Client` rappresenta un client che può connettersi al server di gioco. Include metodi per la connessione, l'invio di messaggi e la gestione dei dati.

### Proprietà:

1. `Socket _socket`: La connessione socket sottostante.
2. `bool connected`: Indica se il client è connesso.
3. `var commands`: Stream broadcast per gestire i comandi in ingresso.

### Costruttori:

- `Client._connect(Socket s)`: Costruttore privato per una connessione riuscita.
- `Client._failedConnection()`: Costruttore privato per una connessione non riuscita.
- `Future<Client> connect(String ip)`: Metodo di fabbrica per creare un'istanza di client connettendosi a un server.

### Metodi:

1. `void sendMessage(String message)`: Invia un messaggio al server connesso.
2. `void dataHandler(data)`: Gestisce i dati in ingresso dal server.
3. `void errorHandler(error, StackTrace trace)`: Gestisce gli errori durante la comunicazione.
4. `void doneHandler()`: Chiude la connessione socket quando la comunicazione è terminata.

## Struttura complessiva

- La logica di gioco è incapsulata all'interno della classe `Battleship`.
- La classe `Ship` è responsabile delle proprietà e del comportamento delle singole navi.
- La classe `Client` facilita la comunicazione tra il gioco e il server.
- Il codice lato server (`main` nella sezione finale) gestisce le connessioni dei giocatori, la creazione del gioco e la comunicazione tra i giocatori.

Questa implementazione di Battleship in Dart segue un design orientato agli oggetti con una chiara separazione delle responsabilità tra le classi. La struttura del codice consente una facile estensione e modifica della logica di gioco.

