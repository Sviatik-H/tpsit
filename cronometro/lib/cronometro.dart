import 'package:flutter/material.dart';
import 'dart:async';

class Cronometro extends StatefulWidget {
  @override
  _CronometroState createState() => _CronometroState();
}

class _CronometroState extends State<Cronometro> {
  late Stream<int> timerStream;
  late StreamSubscription<int> timerSubscription;
  int secondsElapsed = 0;
  int secondsDuringPause = 0;
  bool isPaused = true;
  bool isRunning = false;
  bool timerStarted = false;

  @override
  void initState() {
    super.initState();
    timerStream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (x) => x,
    );
    if (timerStarted) {
      startTimer();
    }
  }

  @override
  void dispose() {
    timerSubscription?.cancel();
    super.dispose();
  }

  void resetCronometro() {
    timerSubscription?.cancel();
    setState(() {
      secondsElapsed = 0;
      secondsDuringPause = 0;
      isRunning = false;
      isPaused = true;
      timerStarted = false;
    });
    timerStream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (x) => x,
    );
  }

  void togglePause() {
    if (isRunning) {
      if (!isPaused) {
        secondsDuringPause = 0;
      }
      setState(() {
        isPaused = !isPaused;
      });
    }
  }

  void startTimer() {
    if (!timerStarted) {
      timerSubscription = timerStream.listen((int tick) {
        if (isRunning) {
          if (!isPaused) {
            setState(() {
              secondsElapsed = tick - secondsDuringPause;
            });
          } else {
            secondsDuringPause++;
          }
        }
      });
      timerStarted = true;
    }
    setState(() {
      isRunning = true;
      isPaused = false;
    });
  }

  void pauseTimer() {
    setState(() {
      isPaused = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int hours = secondsElapsed ~/ 3600;
    int minutes = (secondsElapsed ~/ 60) % 60;
    int seconds = secondsElapsed % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cronometro Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startTimer,
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: pauseTimer,
              child: Text('Pausa'),
            ),
            ElevatedButton(
              onPressed: resetCronometro,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}