import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //カプチーノを使う事によってiosのデザインが使える
import 'coin_data.dart';
import 'components/reusable_card.dart';
import 'dart:io'
    show Platform; //でデバイスの切り替えができる showを使う事によって限定的にできる？hide で隠すこともできる？

// ignore: use_key_in_widget_constructors
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (value) {
          setState(() {
            selectedCurrency = currenciesList[value];
          });
        },
        itemExtent: 20,
        children: currenciesList.map<Text>((String currency) {
          return Text(currency);
        }).toList());
  }

  DropdownButton<String> androidDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrency = newValue!;
        });
      },
      items: //ジェネリックス便利やー map<T> で　T型を返す
          currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(), //Iterable型をtoListでlistに変更できてる
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(children: <Widget>[
            ReusableCard(
              label: '1 BTC = ? $selectedCurrency',
            ),
            ReusableCard(
              label: '1 BTC = ? $selectedCurrency',
            ),
            ReusableCard(
              label: '1 BTC = ? $selectedCurrency',
            ),
          ]),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
