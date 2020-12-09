import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/';
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/play');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                  'Игрок и робот бросают 2 кубика (цифры от 1 до 6). Если выпадает дубль (одинаковые цифры), то кубики бросаются снова у того, у кого выпал дубль до тех пор, пока не будет дубля. Цель игры - быстрее соперника набрать 100 очков.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => selectCategory(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.all(30),
                    child: Text('Начать игру'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
