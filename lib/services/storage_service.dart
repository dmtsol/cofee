import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/coffee_calculation.dart';

class StorageService {
  static List<CoffeeCalculation>? _cache;

  Future<String> get _filePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/recipes.json';
  }

  Future<List<CoffeeCalculation>> getAll() async {
    if (_cache != null) return _cache!;
    try {
      final file = File(await _filePath);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final list = (jsonDecode(content) as List)
          .map((e) => CoffeeCalculation.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache = list;
      return list;
    } catch (e) {
      debugPrint('StorageService.getAll error: $e');
      return [];
    }
  }

  Future<void> insert(CoffeeCalculation calc) async {
    final list = await getAll();
    list.add(calc);
    await _writeAll(list);
  }

  Future<void> delete(int id) async {
    final list = await getAll();
    list.removeWhere((c) => c.id == id);
    await _writeAll(list);
  }

  Future<void> _writeAll(List<CoffeeCalculation> list) async {
    final file = File(await _filePath);
    final content = jsonEncode(list.map((e) => e.toJson()).toList());
    await file.writeAsString(content);
    _cache = list;
  }
}
