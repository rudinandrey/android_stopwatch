import 'package:flutter/material.dart';
import 'package:stopwatch/stopwatch.dart';

import 'login_screen.dart';

void main() => runApp(StopWatchApp());

class StopWatchApp extends StatelessWidget {
  const StopWatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StopWatch(),
    );
  }
}
