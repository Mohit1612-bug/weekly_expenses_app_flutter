import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NewTransaction extends StatefulWidget {
  final Function addNewTransactionMethod;

  NewTransaction(this.addNewTransactionMethod);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController=TextEditingController();

  final amountController=TextEditingController();

  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate==null){
        return;
      }
      _selectedDate = pickedDate;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
              child: Container(
                padding:EdgeInsets.only(
                  top:10,
                  left:10,
                  right:10,
                  bottom:MediaQuery.of(context).viewInsets.bottom +20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (value) {
                        if(amountController.text.isEmpty){
                          return;
                        }
                        if(titleController.text.isEmpty||double.parse(amountController.text)<=0||_selectedDate==null){
                          return;
                        }
                        widget.addNewTransactionMethod(titleController.text,double.parse(amountController.text),_selectedDate);
                        Navigator.of(context).pop();
                      },
                      decoration: InputDecoration(
                        labelText:"Amount",
                      ),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Text(_selectedDate!=null ?"Picked Date: ${DateFormat.yMd().format(_selectedDate)}": "No Date Choosen " ),
                          FlatButton(
                          onPressed: (){
                            _presentDatePicker();
                          }, 
                          child: Text("Choose Date",style: TextStyle(color:Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold),),
                          textColor:Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Platform.isIOS ?CupertinoButton(
                      child: Text(
                        "Add Transaction",
                        style:Theme.of(context).textTheme.title,
                        ), 
                      onPressed: (){
                        if(amountController.text.isEmpty){
                          return;
                        }
                        if(titleController.text.isEmpty||double.parse(amountController.text)<=0||_selectedDate==null){
                          return;
                        }
                        widget.addNewTransactionMethod(titleController.text,double.parse(amountController.text),_selectedDate);
                        Navigator.of(context).pop();
                        
                      },
                      )
                      :RaisedButton(
                      onPressed: (){
                        if(amountController.text.isEmpty){
                          return;
                        }
                        if(titleController.text.isEmpty||double.parse(amountController.text)<=0||_selectedDate==null){
                          return;
                        }
                        widget.addNewTransactionMethod(titleController.text,double.parse(amountController.text),_selectedDate);
                        Navigator.of(context).pop();
                        
                      }, 
                      child: Text(
                        "Add Transaction",
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}