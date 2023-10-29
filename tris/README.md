# Gioco Tris in Flutter
Questo codice rappresenta un'applicazione di gioco Tris (o Tic-Tac-Toe) scritta in Flutter. 
L'app offre un'interfaccia utente per due giocatori che si alternano a effettuare mosse su una griglia 3x3, 
cercando di ottenere una fila, una colonna o una diagonale completa del proprio simbolo (X o O) per vincere la partita.

# Struttura dell'Applicazione
L'applicazione è suddivisa in tre classi principali:

# MyApp
La classe MyApp rappresenta la configurazione iniziale dell'applicazione. 
Questa classe imposta il titolo e il tema dell'applicazione e inizia il gioco chiamando la schermata principale, MyHomePage.

# MyHomePage
La classe MyHomePage è la schermata principale del gioco. 
Accetta un titolo come parametro e crea un'istanza della classe _MyHomePageState quando necessario.

# _MyHomePageState
La classe _MyHomePageState gestisce lo stato interno del gioco. 
Alcune delle funzionalità principali di questa classe includono:

L'inizializzazione del campo di gioco con una griglia 3x3.
La gestione del turno dei giocatori, con il giocatore X che inizia.
La verifica delle condizioni di vittoria o pareggio.
La gestione della fine del gioco con un messaggio "Game Over" o "Pareggio".
La possibilità di ripristinare il gioco e iniziare una nuova partita.
L'interfaccia utente è composta da una griglia di caselle 3x3, ciascuna gestita con un GestureDetector. 
Il colore e il contenuto delle caselle variano in base allo stato della rivelazione e alla presenza di simboli X o O.

I giocatori si alternano a effettuare mosse toccando le caselle vuote. 
Il gioco termina quando un giocatore vince o quando tutte le caselle sono occupate (pareggio). 
In caso di fine del gioco, viene visualizzata una finestra di dialogo con il risultato e la possibilità di iniziare una nuova partita.
