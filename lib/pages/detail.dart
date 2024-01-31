import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget{
  final Map rate;
  DetailPage({required this.rate});

  @override
  Widget build(BuildContext context) {
    List _currency=rate.keys.toList();
    List _exgrate=rate.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: _currency.length,
          itemBuilder: (_context,_index){
            String  currency = _currency[_index].toString().toUpperCase();
            String  value   = _exgrate[_index].toStringAsFixed(2);
            return ListTile(
              title: Text("$currency : $value",
                style:const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400
                ),
              ),
            );
          }
          ),
      ),
    );
  }
}