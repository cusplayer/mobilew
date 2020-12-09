import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:labContats/contact.dart';
import 'package:labContats/new_contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Data class for the mini todo application.
class TodoItem {
  final int id;
  final String content;
  final String number;
  // SQLite doesn't supprot boolean. Use INTEGER/BIT (0/1 values).
  final bool isDone;
  // SQLite doesn't supprot DateTime. Store them as INTEGER (millisSinceEpoch).
  final DateTime createdAt;

  TodoItem(
      {this.id,
      this.content,
      this.number,
      this.isDone = false,
      this.createdAt});

  TodoItem.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        content = map['content'] as String,
        number = map['number'] as String,
        isDone = map['isDone'] == 1,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'content': content,
        'number': number,
        'isDone': isDone ? 1 : 0,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}

class SqliteExample extends StatefulWidget {
  const SqliteExample({Key key}) : super(key: key);

  @override
  SqliteExampleState createState() => SqliteExampleState();
}

class SqliteExampleState extends State<SqliteExample> {
  static const kDbFileName = 'sqflite_ex1.db';
  static const kDbTableName = 'example1_tbl';
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Database _db;
  List<TodoItem> _todos = [];

  // Opens a db local file. Creates the db table if it's not yet created.
  Future<void> _initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, kDbFileName);
    this._db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE $kDbTableName(
          id INTEGER PRIMARY KEY, 
          isDone BIT NOT NULL,
          content TEXT,
          number TEXT,
          createdAt INT)
        ''');
      },
    );
  }

  // Retrieves rows from the db table.
  Future<void> _getTodoItems() async {
    final List<Map<String, dynamic>> jsons =
        await this._db.rawQuery('SELECT * FROM $kDbTableName');
    print('${jsons.length} rows retrieved from db!');
    this._todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
  }

  // Inserts records to the db table.
  // Note we don't need to explicitly set the primary key (id), it'll auto
  // increment.
  Future<void> _addTodoItem(TodoItem todo) async {
    await this._db.transaction(
      (Transaction txn) async {
        final int id = await txn.rawInsert('''
          INSERT INTO $kDbTableName
            (content, number, isDone, createdAt)
          VALUES
            (
              "${todo.content}",
              "${todo.number}",
              ${todo.isDone ? 1 : 0}, 
              ${todo.createdAt.millisecondsSinceEpoch}
            )''');
        print('Inserted todo item with id=$id.');
      },
    );
  }

  // Updates records in the db table.
  Future<void> _toggleTodoItem(TodoItem todo) async {
    final int count = await this._db.rawUpdate(
        /*sql=*/ '''
      UPDATE $kDbTableName
      SET content = ?,
      number = ?
      WHERE id = ?''', [todo.content, todo.number, todo.id]);
    print('Updated $count records in db.');
  }

  // Deletes records in the db table.
  Future<void> _deleteTodoItem(TodoItem todo) async {
    final count = await this._db.rawDelete('''
        DELETE FROM $kDbTableName
        WHERE id = ${todo.id}
      ''');
    print('Updated $count records in db.');
  }

  Future<bool> _asyncInit() async {
    // Avoid this function to be called multiple times,
    // cf. https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
    await _memoizer.runOnce(() async {
      await _initDb();
      await _getTodoItems();
    });
    return true;
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewContact(_addNewTransaction, null, '', ''),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _startEditNewTransaction(BuildContext ctx, id, name, number) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewContact(_editNewTransaction, id, name, number),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addNewTransaction(String number, String name, id) {
    final newTx = Contact(
      number: number,
      name: name,
      id: 0,
    );
    _addToDb(newTx);
    // setState(() {
    //   _notes.add(newTx);
    // });
  }

  void _editNewTransaction(String number, String name, int id) {
    final newTx = Contact(
      number: number,
      name: name,
      id: id,
    );
    _editDb(newTx);
    // setState(() {
    //   _notes.add(newTx);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Контакты'),
          ),
          body: ListView(
            children: this._todos.map(_itemToListTile).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            child: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        );
      },
    );
  }

  Future<void> _updateUI() async {
    await _getTodoItems();
    setState(() {});
  }

  Card _itemToListTile(TodoItem todo) => Card(
        child: Column(children: [
          ListTile(
            title: Text(
              '${todo.content}',
              style: TextStyle(),
            ),
            isThreeLine: false,
            leading: FloatingActionButton(
              tooltip: 'Edit',
              child: Icon(Icons.edit),
              onPressed: () => _startEditNewTransaction(
                  this.context, todo.id, todo.content, todo.number),
            ),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _deleteTodoItem(todo);
                  _updateUI();
                }),
          ),
          ListTile(
            title: Text(
              '${todo.number}',
              style: TextStyle(color: Colors.blue),
            ),
            isThreeLine: false,
          ),
        ]),
      );

  _addToDb(contact) async {
    await _addTodoItem(
      TodoItem(
        content: contact.name,
        number: contact.number,
        createdAt: DateTime.now(),
      ),
    );
    _updateUI();
  }

  _editDb(contact) async {
    await _toggleTodoItem(
      TodoItem(
        content: contact.name,
        number: contact.number,
        id: contact.id,
      ),
    );
    _updateUI();
  }
}
