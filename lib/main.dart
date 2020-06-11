import 'dart:io';
import 'package:Expense_Tracker/widgets/chart.dart';
import 'package:Expense_Tracker/widgets/newTransaction.dart';
import 'package:Expense_Tracker/widgets/transactionList.dart';

import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  runApp(MyApp());
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  // );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        accentColor: Colors.purple,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _switch = true;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  final List<Transaction> transactionList = [
    Transaction(
      id: 'T1',
      title: 'Shoes',
      amount: 9.33,
      date: DateTime.now(),
    ),
    Transaction(
      id: 'T2',
      title: 'Trimmer',
      amount: 24,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String title, double amount, DateTime choosenDate) {
    final Transaction tx = new Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: choosenDate,
    );

    setState(() {
      transactionList.add(tx);
    });
  }

  List<Transaction> get _recentTransactions {
    return transactionList.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactionList.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        "My Expense App",
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );

    var transactionListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(
        transactionList,
        deleteTx: _deleteTransaction,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: transactionList.isEmpty
            ? Column(
                children: <Widget>[
                  const Text('There are no Transactions'),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 300,
                    child: Image.asset(
                      'assets/images/test.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Show Chart'),
                        Switch.adaptive(
                            value: _switch,
                            onChanged: (val) {
                              setState(() {
                                _switch = val;
                              });
                            }),
                      ],
                    ),
                  if (!isLandscape) _buildPotraiteWidget(context, appBar),
                  if (isLandscape && _switch)
                    _buildLandScapeWidget(context, appBar),
                  transactionListWidget,
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }

  Container _buildLandScapeWidget(BuildContext context, AppBar appBar) {
    return Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          1,
      child: Chart(_recentTransactions),
    );
  }

  Container _buildPotraiteWidget(BuildContext context, AppBar appBar) {
    return Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.3,
      child: Chart(_recentTransactions),
    );
  }
}
