import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //カプチーノを使う事によってiosのデザインが使える
import '../service/coin_data.dart';
import '../components/reusable_card.dart';
import 'dart:io'
    show Platform; //でデバイスの切り替えができる showを使う事によって限定的にできる？hide で隠すこともできる？

// ignore: use_key_in_widget_constructors
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'AUD';
  bool isWaiting = false;
  Map<String, String> coinValues = {};
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    //7: Second, we set it to true when we initiate the request for prices.
    isWaiting = true;
    try {
      //6: Update this method to receive a Map containing the crypto:price key value pairs.
      var ratedata = await CoinData().fetchDataList(_selectedCurrency);
      //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
        coinValues = ratedata;
      });
    } catch (e) {
      print(e);
    }
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (value) async {
          setState(() {
            _selectedCurrency = currenciesList[value];
            getData();
          });
        },
        itemExtent: 20,
        children: currenciesList.map<Text>((String currency) {
          return Text(currency);
        }).toList());
  }

  DropdownButton<String> androidDropdownButton() {
    return DropdownButton<String>(
      value: _selectedCurrency,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCurrency = newValue!;
          getData();
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
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CryptoCard(
                    cryptoCurrency: 'BTC',
                    //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data.
                    value: isWaiting ? '?' : coinValues['BTC'],
                    selectedCurrency: _selectedCurrency),
                CryptoCard(
                  cryptoCurrency: 'ETH',
                  value: isWaiting ? '?' : coinValues['ETH'],
                  selectedCurrency: _selectedCurrency,
                ),
                CryptoCard(
                  cryptoCurrency: 'LTC',
                  value: isWaiting ? '?' : coinValues['LTC'],
                  selectedCurrency: _selectedCurrency,
                ),
              ]),
          Container(
            height: 70.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 20.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
