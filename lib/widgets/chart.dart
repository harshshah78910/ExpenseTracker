import 'package:Expense_Tracker/models/transaction.dart';
import 'package:Expense_Tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionList {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalAmount = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }
      
      return {'day': DateFormat.E().format(weekday), 'amount': totalAmount};
    }).reversed.toList();
  }

  double get totalSum {
    return groupedTransactionList.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionList);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionList.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(data['day'], data['amount'],
                  totalSum == 0 ? 0.0 : (data['amount'] as double) / totalSum),
            );
          }).toList(),
        ),
      ),
    );
  }
}
