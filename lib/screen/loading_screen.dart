import 'package:bitcoin_ticker_flutter/screen/price_screen.dart';
import 'package:bitcoin_ticker_flutter/service/coin_data.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    fetchAUDrateData();
  }

  void fetchAUDrateData() async {
    List<dynamic> audRateData = await CoinData().fetchDataList('AUD');
  
    //
    Navigator.pushAndRemoveUntil<dynamic> (
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              PriceScreen(audRateData: audRateData)),
      (route) => false, 
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ),
    );
  }
}
