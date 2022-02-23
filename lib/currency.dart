// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Currency welcomeFromJson(String str) => Currency.fromJson(json.decode(str));

String welcomeToJson(Currency data) => json.encode(data.toJson());

class Currency {
  Currency({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  double amount;
  String base;
  DateTime date;
  Map<String, double> rates;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        amount: json["amount"],
        base: json["base"],
        date: DateTime.parse(json["date"]),
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "base": base,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
