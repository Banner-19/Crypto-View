import 'dart:convert';

import 'package:cypto/pages/detail.dart';
import 'package:cypto/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget{
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage>{
  double? _dheight,_dwidth;
  HTTPService? _http;
  String? _selectedCoin="Bitcoin";
  _HomeState();

  @override
  void initState() {
    super.initState();
    _http=GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _dheight=MediaQuery.sizeOf(context).height;
    _dwidth=MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectCoindrop(),_dataCoin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectCoindrop(){
    List<String> _coins=["Bitcoin","Ethereum","Tether","Solana","OKB","Bittensor","Dogecoin","TRON","Ripple","Chainlink"];
    List<DropdownMenuItem<String>> _items=_coins.map((e) {
      return DropdownMenuItem(
        value: e,
        child: Text(e,
          style:const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
            fontFamily: 'ArchitectsDaughter'
          ),
        ),
      );
    }).toList();
    return DropdownButton( value: _selectedCoin, 
      items: _items, 
      onChanged: (_value){
        setState(() {
          _selectedCoin=_value;
        });
      },
      dropdownColor:const Color.fromRGBO(193, 242, 176, 1.0),
      iconSize: 40,
      icon:const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
      style:const TextStyle(
        fontSize: 70,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _dataCoin(){
    return FutureBuilder(future: _http!.get("/coins/${_selectedCoin!.toLowerCase()}"),
     builder: (BuildContext _context, AsyncSnapshot _snapshot){
      if(_snapshot.hasData){
        Map _data=jsonDecode(_snapshot.data.toString());
        num _inr=_data["market_data"]["current_price"]["inr"];
        num _change_24h=_data["market_data"]["price_change_percentage_24h"];
        Map _chngrate=_data["market_data"]["current_price"];
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext _context){
                  return DetailPage(rate: _chngrate,);
                    },
                  ),
                );
              },
              child: _imgCoin(_data["image"]["large"]),
              
            ),
            _curPrice(_inr),
            _change_in_24h(_change_24h),
            _description(_data["description"]["en"])
          ],
        );
      }
      else{
        return const Center(child: CircularProgressIndicator(color: Colors.white,),);
      }
    });
  }

  Widget _curPrice(num _rate){
    return Text("${_rate.toStringAsFixed(2)} INR",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _change_in_24h(num _change){
    return Text("${_change.toStringAsFixed(6)} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _imgCoin(String _imgUrl){
    return Container(
      padding: EdgeInsets.symmetric(vertical: _dheight!*0.25),
      height: _dheight!*0.15,
      width: _dwidth!*0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgUrl),
        )
      ),
    );
  }

  Widget _description(String _desc){
    return Container(
      height: _dheight!*0.45,
      width: _dwidth!*0.90,
      margin: EdgeInsets.symmetric(vertical: _dheight!*0.05),
      padding: EdgeInsets.symmetric(vertical: _dheight!*0.01,horizontal: _dwidth!*0.01),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(85,124, 85, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Text(_desc,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}