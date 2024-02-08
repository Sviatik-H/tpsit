import 'package:flutter/material.dart';
import 'app_database.dart'; // Assicurati che questo import punti al file corretto dove hai definito AppDatabase
import 'post.dart'; // Importa la classe dell'entità Post
import 'comment.dart'; // Importa la classe dell'entità Comment

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assicura l'inizializzazione dei widget di Flutter
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build(); // Inizializza il database
  runApp(MyApp(database: database)); // Avvia l'app passando il database come parametro
}

class MyApp extends StatelessWidget {
  final AppDatabase database; // Variabile per memorizzare il riferimento al database

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(database: database), // Passa il database alla HomePage
    );
  }
}

class HomePage extends StatefulWidget {
  final AppDatabase database; // Variabile per memorizzare il riferimento al database

  const HomePage({Key? key, required this.database}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Esempio di utilizzo del database
            final post = Post(name: 'Nome del post', title: 'Titolo del post');
            final postId = await widget.database.postDao.insertPost(post); // Inserisce un post nel database e ottiene l'ID
            final comment = Comment(postId: postId, message: 'Messaggio del commento'); // Crea un commento con l'ID del post
            await widget.database.commentDao.insertComment(comment); // Inserisce il commento nel database

            // Mostra i dati
            final posts = await widget.database.postDao.getAllPosts();
            final comments = await widget.database.commentDao.getAllComments();

            // Puoi usare print per vedere i dati nel log
            // In una app reale, mostreresti i dati in un widget
            print('Posts: $posts');
            print('Comments: $comments');
          },
          child: Text('Esegui operazioni sul database'),
        ),
      ),
    );
  }
}
