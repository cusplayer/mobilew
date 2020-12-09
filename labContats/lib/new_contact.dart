import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewContact extends StatefulWidget {
  final Function addTx;
  final int id;
  final String number;
  final String name;

  NewContact(this.addTx, this.id, this.name, this.number);
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  @override
  void initState() {
    _nameController.text = widget.name;
    _numberController.text = widget.number;
    // TODO: implement initState
    super.initState();
  }

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#-###-###-##-##', filter: {"#": RegExp(r'[0-9]')});

  void _submitData() {
    if (_nameController.text.isEmpty) {
      return;
    }
    final enteredNumber = _numberController.text;
    final enteredName = _nameController.text;

    if (enteredNumber.isEmpty || enteredName.isEmpty) {
      return;
    }
    widget.addTx(enteredNumber, enteredName, widget.id);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Номер'),
              keyboardType: TextInputType.number,
              controller: _numberController,
              inputFormatters: [maskFormatter],
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Имя'),
              controller: _nameController,
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            RaisedButton(
              onPressed: _submitData,
              child: Text('Сохранить'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
            )
          ],
        ),
      ),
    );
  }
}
