import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models.dart';

class MtgViewModel extends ChangeNotifier {
  List<MtgCard> cards = [];
  List<dynamic> sets = [];
  bool isLoading = false;
  String error = '';
  int _page = 1;

  //karty
  Future<void> fetchCards({bool loadMore = false}) async {
    if (isLoading) return;
    if (!loadMore) { cards.clear(); _page = 1; } else { _page++; }

    _setLoading(true);

    try {
      final res = await http.get(Uri.parse('https://api.magicthegathering.io/v1/cards?pageSize=20&page=$_page&contains=imageUrl'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body)['cards'] as List;
        cards.addAll(data.map((e) => MtgCard.fromJson(e)));
        _saveCardsOffline();
      } else {
        error = 'Błąd serwera: ${res.statusCode}';
      }
    } catch (e) {
      error = 'Brak sieci. Wczytuję zapisane karty.';
      if (!loadMore) _loadCardsOffline();
    } finally {
      _setLoading(false);
    }
  }

  //szukanie
  Future<void> search(String query) async {
    if (query.isEmpty) return fetchCards();
    _setLoading(true);
    try {
      final res = await http.get(Uri.parse('https://api.magicthegathering.io/v1/cards?name=$query&pageSize=20&contains=imageUrl'));
      cards = (json.decode(res.body)['cards'] as List).map((e) => MtgCard.fromJson(e)).toList();
    } catch (e) {
      error = 'Szukanie wymaga internetu.';
    } finally {
      _setLoading(false);
    }
  }

  //sety
  Future<void> fetchSets() async {
    _setLoading(true);
    try {
      final res = await http.get(Uri.parse('https://api.magicthegathering.io/v1/sets'));
      if (res.statusCode == 200) {
        sets = json.decode(res.body)['sets'];
        _saveSetsOffline();
      }
    } catch (_) {
      error = 'Brak sieci. Wczytuję zapisane sety.';
      _loadSetsOffline();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool val) { isLoading = val; notifyListeners(); }

  //offline
  Future<void> _saveCardsOffline() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cards', json.encode(cards.map((e) => e.toJson()).toList()));
  }

  Future<void> _loadCardsOffline() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('cards')) {
      final List data = json.decode(prefs.getString('cards')!);
      cards = data.map((e) => MtgCard.fromJson(e)).toList();
    }
  }

  Future<void> _saveSetsOffline() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sets', json.encode(sets));
  }

  Future<void> _loadSetsOffline() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('sets')) {
      sets = json.decode(prefs.getString('sets')!);
    }
  }
}