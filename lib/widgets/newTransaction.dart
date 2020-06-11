import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransactionFunc;
  NewTransaction(this.addTransactionFunc);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _datePicked;

  void _submittedData() {
    final String titleEntered = titleController.text;
    final double amountEntered = double.parse(amountController.text);

    if (titleEntered.isEmpty || amountEntered < 0 || _datePicked == null) {
      return;
    }

    widget.addTransactionFunc(
        titleController.text, double.parse(amountController.text), _datePicked);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          _datePicked = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              autocorrect: true,
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submittedData(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _datePicked == null
                        ? 'No Date Chosen'
                        : DateFormat.yMMMEd().format(_datePicked),
                  ),
                ),
                Container(
                  height: 70,
                  child: FlatButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    textColor: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
            FlatButton(
              child: Text(
                'Add Transaction',
              ),
              textColor: Colors.green,
              onPressed: _submittedData,
            ),
          ],
        ),
      ),
    );
  }
}
