# am023_todo_list_floor

**[231218]** APp ricreata da zero! `floor`, [qui](https://pub.dev/packages/floor) per la pagina del pacchetto che usa, `sqflite`, [qui](https://pub.dev/packages/sqflite) la sua pagina, dal nome ricorda `room` su Android, è un ORM. Questo esempio integra **am032_todo_list**. Oltre al pacchetto in `pubspec.yaml` aggiungiamo
```
dev_dependencies:
...
  floor_generator: ^1.3.0
  build_runner: ^2.1.2
```
`build_rinner` ci permette di leggere la "ricetta" definita in `floor_generator` per creare il file `.g`.

## model

Qui di seguito il *model* con le interessanti *annotation*
```dart
@entity
class Todo {
  Todo({required this.id, required this.name, this.checked = false});

  @primaryKey
  final int? id;

  final String name;
  bool checked;

  ...
}
```
Può sorprendere il tipo della chiave primaria, ma, quando creiamo un oggetto, prima di inserirlo nel DB, non la conosciamo!

## il DAO

Il *Data Access Object* - altrove si parla di *repository*, definisce l'interfaccia dei metodi. Invitiamo allo studio delle possibili *annotation*. Attenzione a scrivere
```dart
@Query('SELECT * FROM Todo WHERE id = :id')
  Future<Todo?> findTodoById(int id);
```
per non creare problemi a `build_runner` per ovvi motivi.

## il database

Resta da definire la configuraziine per il DB, ed è qui che agisce `build_runner`completando il lavoro per noi.
Ora il file `database.g.dart`, se tutto è scritto bene, viene dando a terminale
```
flutter packages pub run build_runner build
```
Se qualcosa cambia dare `flutter packages pub run build_runner watch`. Solo ora
```
part 'database.g.dart';
```
non darà più errore.

## main

Abbiamo dichiarato una variabile globale intesta
```dart
late final TodoDao _dao;
```
solo al momento dell'inizializzazione dello stato verrà assegnata, e se tutto va liscio ciò dovrebbe accadere.
```dart
@override
initState() {
  super.initState();
  _getDao();
}
```
Nel nostro esempio il DAO lo inizializziamo solo dopo aver instaurato la connessione `database` (che poi non toccheremo più).
```dart
AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
_dao = database.todoDao;
```
In assenza del DB esso viene creato `build()`. Aperta l'applicazione si ricrea la lista recuperando i dati dal DB.
```dart
_updateTodos() {
  _dao.getTodos().then((todos) {
    setState(() {
      _todos.clear();
      _todos.addAll(todos);
    });
  });
}
```
ALL fine di ogni metodo del CRUS il DAO procede con l'aggiornamento del DB in modo che la lista sia sincronizzata col DB. In questa versione i `Todo` spuntati vengono messi in coda alla lista e se non spuntati vengono rimessi in testa.