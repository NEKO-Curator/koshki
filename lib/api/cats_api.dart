// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koshki/api/cat_fact_model.dart';
import 'package:translator/translator.dart';

class CatFactAPI {
  final String _baseUrl = "https://catfact.ninja";
  final String _csrfToken = "2DQktIIqpcO0oNzgj0Vs1J1YfKyIEkAqJrTCS7Y8";
  final GoogleTranslator translator = GoogleTranslator();

  Future<CatFact> getCatFact() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/fact"),
      headers: {
        'accept': 'application/json',
        'X-CSRF-TOKEN': _csrfToken,
      },
    );

    if (response.statusCode == 200) {
      var catFact = CatFact.fromJson(json.decode(response.body));
      var translatedText =
          await translator.translate(catFact.fact, from: 'en', to: 'ru');
      return CatFact(
        fact: translatedText.text,
        length: translatedText.text.length,
      );
    } else {
      throw Exception("Failed to load cat fact");
    }
  }
}
