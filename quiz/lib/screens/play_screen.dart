import 'package:flutter/material.dart';
import 'dart:math';

import 'package:quiz/screens/final_screen.dart';

class PlayScreen extends StatefulWidget {
  static const routeName = '/play';
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  var player = 0;
  var comp = 0;
  Random random = new Random();
  var rand1;
  var rand2;
  var cub1 = 'c1.jpg';
  var cub2 = 'c1.jpg';
  int count = 0;
  String winner = '';
  void play(BuildContext ctx) {
    if (comp >= 100 || player >= 100) {
      if (comp > player) {
        winner = 'comp';
      } else if (comp == player) {
        winner = 'null';
      } else {
        winner = 'player';
      }
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (ctx) => FinalScreen(winner)));
    }
    setState(() {
      count += 1;
      rand1 = random.nextInt(6) + 1;
      rand2 = random.nextInt(6) + 1;
      switch (rand1) {
        case 1:
          cub1 = 'c1.jpg';
          break;
        case 2:
          cub1 = 'c2.jpg';
          break;
        case 3:
          cub1 = 'c3.jpg';
          break;
        case 4:
          cub1 = 'c4.jpg';
          break;
        case 5:
          cub1 = 'c5.jpg';
          break;
        case 6:
          cub1 = 'c6.jpg';
          break;
      }
      switch (rand2) {
        case 1:
          cub2 = 'c1.jpg';
          break;
        case 2:
          cub2 = 'c2.jpg';
          break;
        case 3:
          cub2 = 'c3.jpg';
          break;
        case 4:
          cub2 = 'c4.jpg';
          break;
        case 5:
          cub2 = 'c5.jpg';
          break;
        case 6:
          cub2 = 'c6.jpg';
          break;
      }
      if (rand1 == rand2) {
        rand1 = 0;
        rand2 = 0;
        count -= 1;
      }
      if ((count % 2) == 0) {
        player += rand1 + rand2;
      } else {
        comp += rand1 + rand2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => play(context),
        child: Container(
          color: Colors.amber,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ai.png',
                    width: 100,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: Text(
                      '$comp',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              ),
              Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/images/$cub1'),
                      Image.asset('assets/images/$cub2'),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/user.png',
                    width: 100,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: Text(
                      '$player',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
