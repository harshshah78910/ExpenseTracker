import 'package:Expense_Tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function deleteTx;
  TransactionList(this.transactionList, {this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        children: transactionList.map((tx) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: FittedBox(
                  child: Text('\$${tx.amount}'),
                ),
              ),
            ),
            title: Text(
              '${tx.title}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(DateFormat.yMMMEd().format(tx.date)),
            trailing: MediaQuery.of(context).size.width > 460
                ? FlatButton.icon(
                    onPressed: () => deleteTx(tx.id),
                    label: Text('Delete'),
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    textColor: Theme.of(context).errorColor,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () => deleteTx(tx.id)),
          );
        }).toList(),
      ),
    );
  }
}
