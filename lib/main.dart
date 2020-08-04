import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/Widgets/new_transaction.dart';
import './Widgets/transaction_list.dart';



import 'Widgets/new_transaction.dart';
import './models/Transactions.dart';
import './Widgets/chart.dart';
void main(){
  // // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,
  //   ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoApp() :MaterialApp(
      title: "Personal Expenses",
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch:Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily:'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
            )
          ),
        )
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
// String titleInput;
// String inputAmount;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   bool _showChart=false;
  final List<Transaction> _userTransaction=[
  // Transaction(
  //  id:'t1',
  //  title:"Shoes",
  //  amount:69.99,
  //  date:DateTime.now(),
  //  ),
  //  Transaction(
  //    id: 't2',
  //    title:"Groceries",
  //    amount: 34.21,
  //    date: DateTime.now(),
  //    )
];
List<Transaction>get _rescentTransaction{
  return _userTransaction.where((tx){
    return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
  }).toList();
}
void _addNewTransaction(String txTitle,double txAmount,DateTime choosenDate){
  final newTx=Transaction(
    title: txTitle,
    amount:txAmount,
    date: choosenDate,
    id: DateTime.now().toString(),
  );
  setState(() {
    _userTransaction.add(newTx);
  });
}
  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_){
        return GestureDetector(
          onTap: (){},
          child:NewTransaction(_addNewTransaction)
        );
      }
    );
  }
  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) {
        return element.id == id;
      });
    });
  }
  List<Widget> _buildisnotLandscape(Widget txListWidget,AppBar appBar){
    return [Container(
             height:(
               MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)
               *0.3,
             child: Chart(_rescentTransaction)
             ),
             txListWidget
             ];
  } 
  List<Widget> _buildisLandscape(Widget txListWidget,AppBar appBar){
    return [
      Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
             Text("show Chart"),
             Switch(
               value: _showChart,
               onChanged:(val){
                setState(() {
                  _showChart = val;
                });
             }),
           ]
        ),
        _showChart? Container(
             height:(
               MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)
               *0.7,
             child: Chart(_rescentTransaction)
             ):
            txListWidget,
    ];
  }
  Widget _buildAppBar(){
    return Platform.isIOS ?CupertinoNavigationBar(
      middle: Text("Personal Expenses"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap:()=>_startAddNewTransaction(context),
            child: Icon(CupertinoIcons.add),
          ),
        ],
      ),
      ) 
      : AppBar(
       title:Text("Personal Expenses") ,
       actions: <Widget>[
         IconButton(
          icon: Icon(Icons.add), 
          onPressed: (){
            return _startAddNewTransaction(context);
          },
        ),
       ],
      );
  }
  @override
  Widget build(BuildContext context) {
    final isLandscape =MediaQuery.of(context).orientation==Orientation.landscape;
    final PreferredSizeWidget appBar= _buildAppBar();
    final txListWidget=Container(
      height:(MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,
      child: TransactionList(_userTransaction,_deleteTransaction)
    ); 
    final appBody =SafeArea(
      child:SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           if(isLandscape) ..._buildisLandscape(txListWidget,appBar),
           if(!isLandscape) ..._buildisnotLandscape(txListWidget,appBar),
          ],
        ),
      ),
    ); 
    return Platform.isIOS?CupertinoPageScaffold(
      child:appBody,
      navigationBar: appBar, 
      ) 
      : Scaffold(
      appBar: appBar,      
      body: appBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS? Container() : FloatingActionButton(
        onPressed:(){
          return _startAddNewTransaction(context);
        },
        child:Icon(Icons.add),
      ),
    );
  }
}