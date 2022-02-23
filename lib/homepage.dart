import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  //Currency currentCurrency;

  @override
  void initState() {
    super.initState();
    BaseOptions options = BaseOptions();
    options.baseUrl = 'https://api.frankfurter.app/';
    dio = Dio(options);
    getCurrencies();
  }

  // get currencies
  Future<List> getCurrencies() async {
    print('get metodu çalıştı');
    setState(() {
      isLoading = true;
    });
    Response? result = await dio?.get('currencies');
    if (result?.statusCode == 200) {
      (result?.data as Map).forEach((key, value) {
        currencies.add(value);
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
                        onChanged: (value) {
                          setState(() {
                            selectedCurrency = value!;
                          });
                        },
                        items: currencies
                            .map((value) => DropdownMenuItem<String>(
                                value: value, child: Text(value)))
                            .toList())
              ],
            ),
          ),
        ));
  }
}
