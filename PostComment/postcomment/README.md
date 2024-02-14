# Panoramica del Codice del Progetto Flutter

## Struttura del Progetto

Il progetto comprende cinque classi Dart che insieme costruiscono un'applicazione Flutter per la gestione di post e commenti con un database SQLite locale utilizzando la libreria di persistenza Floor.

### 1. PostDao (Data Access Object)

- **Scopo**: Fornisce l'interfaccia per accedere alle entità `Post` e `Comment` nel database.
- **Funzioni Principali**: Include metodi per recuperare, inserire, aggiornare e cancellare post e commenti. Supporta anche la ricerca di post e commenti specifici per ID e il recupero di commenti per un dato ID di post.

### 2. AppDatabase

- **Scopo**: Definisce il database dell'applicazione con Floor.
- **Caratteristiche**: Specifica la versione del database e le entità (`Post`, `Comment`). Fornisce l'accesso a `PostDao` per eseguire operazioni sul database.

### 3. MyApp e MyHomePage

- **Widget Principale dell'Applicazione (`MyApp`)**: Configura MaterialApp, incluso il tema e la pagina iniziale.
- **Widget della Pagina Iniziale (`MyHomePage`)**: Gestisce lo stato e l'UI per visualizzare post e commenti. Gestisce le operazioni sul database tramite `PostDao` per recuperare, aggiungere, modificare e cancellare post e commenti. Inoltre, include la gestione dei dialoghi per gli input degli utenti.

### 4. Modelli di Entità: Post e Comment

- **Post**: Rappresenta un post con un ID e del testo. È marcato come entità per il database.
- **Comment**: Rappresenta un commento con un ID, testo e una chiave esterna per un post. Dimostra una relazione uno-a-molti tra post e commenti.

### 5. Widgets: PostWidget e CommentWidget

- **PostWidget**: Visualizza un singolo post e i suoi commenti. Fornisce opzioni per aggiungere un commento, rimuovere il post e modificare il post.
- **CommentWidget**: Visualizza un singolo commento con opzioni per cancellare o modificare il commento.

## Tecnologie Chiave

- **Flutter** per UI e logica dell'app.
- **Floor** per la persistenza dei dati, un'astrazione su SQLite per gestire le operazioni sul database in modo più efficiente.
- **SQLite** come motore di database sottostante.

## Componenti UI

- Utilizza componenti di Material Design come `MaterialApp`, `Scaffold`, `AppBar`, `ListView`, `ExpansionTile`, `IconButton`, `TextButton` e dialoghi per l'interazione dell'utente.

## Interazione con il Database

- Dimostra operazioni CRUD (Create, Read, Update, Delete) per post e commenti.
- Mostra operazioni asincrone con `Future` per una UI non bloccante.

