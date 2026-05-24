import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee_calculation.dart';
import '../providers/recipe_provider.dart';
import '../providers/theme_provider.dart';
import 'recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _grindController = TextEditingController();
  final _baseCoffeeController = TextEditingController();
  final _baseWaterController = TextEditingController();
  final _coffeeController = TextEditingController();
  final _waterController = TextEditingController();

  double _ratio = 0;

  @override
  void initState() {
    super.initState();
    _baseCoffeeController.text = '60';
    _baseWaterController.text = '1000';
    _grindController.text = '28';
    _waterController.text = '300';
    _updateRatio();
    _coffeeController.text = _formatValue(300 * _ratio);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _grindController.dispose();
    _baseCoffeeController.dispose();
    _baseWaterController.dispose();
    _coffeeController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _updateRatio() {
    final baseCoffee = double.tryParse(_baseCoffeeController.text.replaceAll(',', '.'));
    final baseWater = double.tryParse(_baseWaterController.text.replaceAll(',', '.'));
    if (baseCoffee != null && baseWater != null && baseWater > 0) {
      _ratio = baseCoffee / baseWater;
    } else {
      _ratio = 0;
    }
  }

  void _onBaseChanged() {
    _updateRatio();
    final coffee = double.tryParse(_coffeeController.text.replaceAll(',', '.'));
    if (coffee != null && _ratio > 0) {
      final newWater = coffee / _ratio;
      if (_waterController.text != _formatValue(newWater)) {
        setState(() {
          _waterController.text = _formatValue(newWater);
        });
      }
    }
  }

  void _onCoffeeChanged() {
    final coffee = double.tryParse(_coffeeController.text.replaceAll(',', '.'));
    if (coffee != null && _ratio > 0) {
      final newWater = coffee / _ratio;
      if (_waterController.text != _formatValue(newWater)) {
        setState(() {
          _waterController.text = _formatValue(newWater);
        });
      }
    }
  }

  void _onWaterChanged() {
    final water = double.tryParse(_waterController.text.replaceAll(',', '.'));
    if (water != null && _ratio > 0) {
      final newCoffee = water * _ratio;
      if (_coffeeController.text != _formatValue(newCoffee)) {
        setState(() {
          _coffeeController.text = _formatValue(newCoffee);
        });
      }
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  Future<void> _saveRecipe() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showSnackBar('Введите название рецепта');
      return;
    }
    final grind = int.tryParse(_grindController.text);
    if (grind == null) {
      _showSnackBar('Введите величину помола');
      return;
    }
    final baseCoffee = double.tryParse(_baseCoffeeController.text.replaceAll(',', '.'));
    final baseWater = double.tryParse(_baseWaterController.text.replaceAll(',', '.'));
    if (baseCoffee == null || baseWater == null || baseWater <= 0) {
      _showSnackBar('Введите корректную базовую пропорцию');
      return;
    }
    final coffee = double.tryParse(_coffeeController.text.replaceAll(',', '.'));
    final water = double.tryParse(_waterController.text.replaceAll(',', '.'));
    if (coffee == null || water == null || coffee <= 0 || water <= 0) {
      _showSnackBar('Введите корректный расчёт');
      return;
    }

    final calc = CoffeeCalculation(
      name: name,
      grindSize: grind,
      baseCoffee: baseCoffee,
      baseWater: baseWater,
      coffeeGrams: coffee,
      waterMl: water,
      createdAt: DateTime.now(),
    );

    try {
      await context.read<RecipeProvider>().saveRecipe(calc);
      if (mounted) {
        _showSnackBar('Рецепт сохранён');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Ошибка: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openRecipes() async {
    final result = await Navigator.push<CoffeeCalculation>(
      context,
      MaterialPageRoute(builder: (_) => const RecipesScreen()),
    );
    if (result != null && mounted) {
      _loadRecipe(result);
    }
  }

  void _loadRecipe(CoffeeCalculation recipe) {
    setState(() {
      _nameController.text = recipe.name;
      _grindController.text = recipe.grindSize.toString();
      _baseCoffeeController.text = _formatValue(recipe.baseCoffee);
      _baseWaterController.text = _formatValue(recipe.baseWater);
      _coffeeController.text = _formatValue(recipe.coffeeGrams);
      _waterController.text = _formatValue(recipe.waterMl);
      _updateRatio();
    });
  }

  void _showThemeDialog() {
    final themeProvider = context.read<ThemeProvider>();
    ThemeMode currentMode = themeProvider.themeMode;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Тема оформления'),
              content: RadioGroup<ThemeMode>(
                groupValue: currentMode,
                onChanged: (value) {
                  setDialogState(() => currentMode = value!);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Как в системе'),
                      value: ThemeMode.system,
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Светлая'),
                      value: ThemeMode.light,
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Тёмная'),
                      value: ThemeMode.dark,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    themeProvider.setThemeMode(currentMode);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Применить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cofee'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: _showThemeDialog,
            tooltip: 'Тема оформления',
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: _openRecipes,
            tooltip: 'Рецепты',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              context,
              title: 'Название рецепта',
              child: TextField(
                controller: _nameController,
                decoration: _inputDecoration(
                  hint: 'Мой эспрессо',
                  icon: Icons.edit_outlined,
                ),
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Базовая пропорция',
              child: Column(
                children: [
                  _buildLabeledField(
                    context,
                    label: 'Кофе (г)',
                    controller: _baseCoffeeController,
                    onChanged: (_) => _onBaseChanged(),
                    hint: '60',
                    icon: Icons.coffee_maker_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildLabeledField(
                    context,
                    label: 'Вода (мл)',
                    controller: _baseWaterController,
                    onChanged: (_) => _onBaseChanged(),
                    hint: '1000',
                    icon: Icons.water_drop_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildLabeledField(
                    context,
                    label: 'Помол',
                    controller: _grindController,
                    keyboardType: TextInputType.number,
                    hint: '15',
                    icon: Icons.grain_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Рассчитать',
              child: _ratio == 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Сначала укажите базовую пропорцию',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        _buildLabeledField(
                          context,
                          label: 'Кофе (г)',
                          controller: _coffeeController,
                          onChanged: (_) => _onCoffeeChanged(),
                          hint: '30',
                          icon: Icons.coffee_maker_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildLabeledField(
                          context,
                          label: 'Вода (мл)',
                          controller: _waterController,
                          onChanged: (_) => _onWaterChanged(),
                          hint: '500',
                          icon: Icons.water_drop_outlined,
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saveRecipe,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Сохранить рецепт'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }
}
