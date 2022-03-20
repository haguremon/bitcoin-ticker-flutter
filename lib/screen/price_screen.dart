import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //カプチーノを使う事によってiosのデザインが使える
import '../service/coin_data.dart';
import '../components/reusable_card.dart';
import 'dart:io'
    show Platform; //でデバイスの切り替えができる showを使う事によって限定的にできる？hide で隠すこともできる？

// ignore: use_key_in_widget_constructors
class PriceScreen extends StatefulWidget {
  final List<dynamic> audRateData;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  const PriceScreen({required this.audRateData});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'AUD';
  int? _btcrate;
  int? _ethrate;
  int? _ltcrate;
  String errorMessage = '取得できませんでした';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void fetchAUDrate(List<dynamic> rateAUDListData) async {
    await updataUI(rateAUDListData);
  }

  Future updataUI(List<dynamic> rataListData) async {
    setState(() {
      if (rataListData.contains([null, null, null])) {
        return;
      }
      _btcrate = rataListData[0]['rate'].toInt() ?? 0;
      _ethrate = rataListData[1]['rate'].toInt() ?? 0;
      _ltcrate = rataListData[2]['rate'].toInt() ?? 0;
    });
  }

  void getData() async {
    //7: Second, we set it to true when we initiate the request for prices.

    try {
      //6: Update this method to receive a Map containing the crypto:price key value pairs.
      List<dynamic> ratedata =
          await CoinData().fetchDataList(_selectedCurrency);
      //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      setState(() {
        _btcrate = ratedata[0]['rate'].toInt() ?? 0;
        _ethrate = ratedata[1]['rate'].toInt() ?? 0;
        _ltcrate = ratedata[2]['rate'].toInt() ?? 0;
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
          });
          List<dynamic> ratedata =
              await CoinData().fetchDataList(_selectedCurrency);
          await updataUI(ratedata);
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
      onChanged: (String? newValue) async {
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
                ReusableCard(
                  label:
                      '1 ${cryptoList[0]} = ${_btcrate ?? errorMessage} $_selectedCurrency',
                ),
                ReusableCard(
                  label:
                      '1 ${cryptoList[1]} = ${_ethrate ?? errorMessage} $_selectedCurrency',
                ),
                ReusableCard(
                  label:
                      '1 ${cryptoList[2]} = ${_ltcrate ?? errorMessage} $_selectedCurrency',
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
