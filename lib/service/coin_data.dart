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
  Future<List<dynamic>> fetchDataList(String currency) async {
    List<String> coinapiURLlist = [];
    List<String> coinapiURLs = cryptoList.map((String crypto) {
      String coinapiURL = '$coinapiURLString$crypto/$currency?apikey=$apikey';
      return coinapiURL;
    }).toList();
    coinapiURLlist = coinapiURLs;
    List<dynamic> dataList =
        await Future.wait(coinapiURLlist.map((String coinapiURL) async {
      NetworkHelper networkHelper = NetworkHelper(coinapiURL);
      var list = await networkHelper.fetchData();
      return list;
    }).toList());

    return dataList;
  }
  // List<dynamic> init
  //   List<Future<dynamic>> fetchDatas = cryptoList.map((String crypto) async {
  //     String coinapiURL = '$coinapiURLString$crypto/$currency?apikey=$apikey';
  //     NetworkHelper networkHelper = NetworkHelper(coinapiURL);
  //     return await networkHelper.fetchData();
  //   }).toList();
  //   //ここで複数のFutureの値を待つ事ができるらしい
  //   Future<List<dynamic>> futureList = Future.wait(fetchDatas);
  //   List<dynamic> result = await futureList;
  //   return result;
  // }


}
//List mappedList = await Future.wait(list.map((i) async => await foo(i)));.