import 'package:flutter/material.dart';
import '../models/coffee_calculation.dart';
import '../services/storage_service.dart';

class RecipeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<CoffeeCalculation> _recipes = [];
  int _nextId = 1;

  List<CoffeeCalculation> get recipes => _recipes;

  Future<void> loadRecipes() async {
    _recipes = await _storage.getAll();
    if (_recipes.isNotEmpty) {
      _nextId = _recipes.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    notifyListeners();
  }

  Future<void> saveRecipe(CoffeeCalculation recipe) async {
    final withNewId = recipe.withId(_nextId++);
    await _storage.insert(withNewId);
    await loadRecipes();
  }

  Future<void> updateRecipe(CoffeeCalculation recipe) async {
    await _storage.update(recipe);
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await _storage.delete(id);
    await loadRecipes();
  }
}
