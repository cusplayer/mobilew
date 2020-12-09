import 'package:flutter/material.dart';

class FinalScreen extends StatelessWidget {
  static const routeName = '/final';
  String winner;
  FinalScreen(this.winner);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text((() {
              if (winner == 'comp') {
                return 'Компьютер победил';
              } else if (winner == 'player') {
                return 'Вы победили';
              } else {
                return 'Ничья';
              }
            })())
          ],
        ),
      ),
    );
  }
}
