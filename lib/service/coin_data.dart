import '../secret_consts.dart';
import 'networkhelper.dart';

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

const coinapiURLString = 'https://rest.coinapi.io/v1/exchangerate/';

class CoinData {
  //List<decodeData>を取ってくる
  Future<List<String>> fetchDataList(String currency) async {
    final List<Future<String>> futures = <Future<String>>[];
    Future<String> f(String coinapiURL) async {
      var coinData = await NetworkHelper(coinapiURL).fetchData();
      print(coinData);
      return coinData.toStringAsFixed(0).padLeft(6, ' ');
    }

    cryptoList.forEach((crypto) {
      futures.add(f('$coinapiURLString$crypto/$currency?apikey=$apikey'));
    });

    return await Future.wait(futures);

    // return await Future.wait(cryptoList.map((crypto) {
    //   return f('$coinapiURLString$crypto/$currency?apikey=$apikey');
    // }));
  }
}
