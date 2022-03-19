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
    List<String> coinapiURLs = cryptoList.map((String crypto) {
      String coinapiURL = '$coinapiURLString$crypto/$currency?apikey=$apikey';
      return coinapiURL;
    }).toList();
    List<dynamic> dataList =
        await Future.wait(coinapiURLs.map((String coinapiURL) async {
      NetworkHelper networkHelper = NetworkHelper(coinapiURL);
      var list = await networkHelper.fetchData();
      return list;
    }).toList())
            .then(
      (content) {
        print(content.contains([null,null,null]));
        return content;
      },
    ).catchError(
      (e) {
        // do something
        throw e;
      },
    );
    return dataList;
  }
}
