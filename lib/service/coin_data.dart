import '../secret_consts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinapiURL = 'https://rest.coinapi.io/v1/exchangerate/';

class CoinData {
  //List<decodeData>を取ってくる
  Future fetchDataList(String currency) async {
     List<Future<String>> futures = <Future<String>>[];

    Future<String> f(String coinapiURL) async {
       print(coinapiURL + ' start');
      http.Response response = await http.get(Uri.parse(coinapiURL));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
        print('lastPrice');
        print(lastPrice);
        print('lastPrice');
        return lastPrice.toStringAsFixed(0).padLeft(6, ' ');
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
   
    cryptoList.forEach((crypto) {
      futures.add(f('$coinapiURL$crypto/$currency?apikey=$apikey'));
    });
     print('Future.wait() start');
     var futureWait = Future.wait(futures);

print('start await');
  var result = await futureWait;
  print('result');
  print(result);
  print('result');

    return  result;

    // return await Future.wait(cryptoList.map((crypto) {
    //   return f('$coinapiURLString$crypto/$currency?apikey=$apikey');
    // }));
  }
}
