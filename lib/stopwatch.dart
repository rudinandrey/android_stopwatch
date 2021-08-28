import 'dart:async';

import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  late int milliseconds = 0;
  late Timer timer;
  bool isTicking = false;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();

  void _onTick(Timer time) {
    setState(() {
      milliseconds += 100;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100), _onTick);
    setState(() {
      milliseconds = 0;
      isTicking = true;
      laps.clear();
    });
  }

  void _stopTimer() {
    setState(() {
      laps.add(milliseconds);
      timer.cancel();
      isTicking = false;
    });
  }

  String _secondsText(milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  void _lap() {
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });
    scrollController.animateTo(
      itemHeight * laps.length,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  Widget _buildCounter() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lap ${laps.length + 1}',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '${_secondsText(milliseconds)}',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 20,
          ),
          _buildControls()
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: isTicking ? null : _startTimer,
          child: Text("Start"),
        ),
        SizedBox(
          width: 20,
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          onPressed: isTicking ? _lap : null,
          child: Text("Lap"),
        ),
        SizedBox(
          width: 20,
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: isTicking ? _stopTimer : null,
          child: Text("Stop"),
        )
      ],
    );
  }

  Widget _buildListTile(index) {
    final milliseconds = laps[index];
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 50),
      title: Text('Lap ${index + 1}'),
      trailing: Text(_secondsText(milliseconds)),
    );
  }

  Widget _buildLapDisplay() {
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          return _buildListTile(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stop watch"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCounter(),
          ),
          Expanded(child: _buildLapDisplay())
        ],
      ),
    );
  }
}
