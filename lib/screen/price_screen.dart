import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; //カプチーノを使う事によってiosのデザインが使える
import '../service/coin_data.dart';
import '../components/reusable_card.dart';
import 'dart:io'
    show Platform; //でデバイスの切り替えができる showを使う事によって限定的にできる？hide で隠すこともできる？

// ignore: use_key_in_widget_constructors
class PriceScreen extends StatefulWidget {
  final CoinData coindata = CoinData();

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    () async {
      List<dynamic> ratedata = await widget.coindata.fetchDataList('AUD');
      await updataUI(ratedata);
    };
  }

  String _selectedCurrency = 'AUD';
  int? _btcrate;
  int? _ethrate;
  int? _ltcrate;
  String errorMessage = 'エラーが発生しました';

  Future updataUI(List<dynamic> ratadata) async {
    var baseBTC = await ratadata[0];
    var baseETH = await ratadata[1];
    var baseLTC = await ratadata[2];

    setState(() {
      if (baseBTC == null && baseETH == null && baseLTC == null) {
        return;
      }
      _btcrate = baseBTC['rate'].toInt() ?? 0;
      _ethrate = baseETH['rate'].toInt() ?? 0;
      _ltcrate = baseLTC['rate'].toInt() ?? 0;
    });
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (value) async {
          setState(() {
            _selectedCurrency = currenciesList[value];
          });
          List<dynamic> ratedata =
              await widget.coindata.fetchDataList(_selectedCurrency);
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
        });
        List<dynamic> ratedata =
            await widget.coindata.fetchDataList(_selectedCurrency);
        await updataUI(ratedata);
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
