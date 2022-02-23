import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'currency.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio? dio;
  List<String> currencies = [];
  String? selectedCurrency;
  bool isLoading = false;
  bool isCurrencyLoading = false;
  Currency? currentCurrency;

  @override
  void initState() {
    super.initState();
    BaseOptions options = BaseOptions();
    options.baseUrl = 'https://api.frankfurter.app/';
    dio = Dio(options);
    getCurrencies();
  }

  // get currency price
  Future<void> getCurrency(String code) async {
    setState(() {
      isCurrencyLoading = true;
    });
    final response = await dio?.get('latest?from=$code');
    if (response?.statusCode == 200) {
      currentCurrency = Currency.fromJson(response?.data);
    }
    setState(() {
      isCurrencyLoading = false;
    });
  }

  // get currencies name
  Future<List> getCurrencies() async {
    print('get metodu çalıştı');
    setState(() {
      isLoading = true;
    });
    Response? result = await dio?.get('currencies');
    if (result?.statusCode == 200) {
      (result?.data as Map).forEach((key, value) {
        currencies.add(key);
        print('data eklendi çalıştı');
      });
    } else {
      print('test hata');
    }
    setState(() {
      isLoading = false;
    });
    selectedCurrency = currencies[0];
    return currencies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          alignment: Alignment.topCenter,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text('Currencies : '),
                isLoading
                    ? const CircularProgressIndicator()
                    : DropdownButton<String>(
                        value: selectedCurrency,
                        onChanged: (value) async {
                          setState(() {
                            selectedCurrency = value!;
                          });
                          await getCurrency(selectedCurrency!);
                        },
                        items: currencies
                            .map((value) => DropdownMenuItem<String>(
                                value: value, child: Text(value)))
                            .toList()),
                currentCurrency != null
                    ? isCurrencyLoading
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              Text('Currency : ${currentCurrency?.base}'),
                              Text('Date : ${currentCurrency?.date}'),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 1,
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(currentCurrency!
                                            .rates.entries
                                            .toList()[index]
                                            .key),
                                        trailing: Text(
                                            '${currentCurrency!.rates.entries.toList()[index].value}'),
                                      );
                                    },
                                    separatorBuilder: (_, ind) => Divider(),
                                    itemCount: currentCurrency!.rates.length),
                              )
                            ],
                          )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
