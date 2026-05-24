import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee_calculation.dart';
import '../providers/recipe_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/recipe_tile.dart';
import 'home_screen.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cofee'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showThemeDialog(context),
            tooltip: 'Тема оформления',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddRecipe(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          if (provider.recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.coffee_maker_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет сохранённых рецептов',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите +, чтобы добавить',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: provider.recipes.length,
            itemBuilder: (context, index) {
              final recipe = provider.recipes[index];
              return RecipeTile(
                recipe: recipe,
                onTap: () => _openEditRecipe(context, recipe),
                onDelete: () => _confirmDelete(context, provider, recipe),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openAddRecipe(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Рецепт сохранён')),
      );
    }
  }

  Future<void> _openEditRecipe(BuildContext context, CoffeeCalculation recipe) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(recipe: recipe)),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Рецепт обновлён')),
      );
    }
  }

  void _showThemeDialog(BuildContext rootContext) {
    final themeProvider = rootContext.read<ThemeProvider>();
    ThemeMode currentMode = themeProvider.themeMode;

    showDialog(
      context: rootContext,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Тема оформления'),
              content: RadioGroup<ThemeMode>(
                groupValue: currentMode,
                onChanged: (value) {
                  setDialogState(() => currentMode = value ?? currentMode);
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

  void _confirmDelete(
    BuildContext context,
    RecipeProvider provider,
    CoffeeCalculation recipe,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить рецепт?'),
        content: Text('«${recipe.name}» будет удалён.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteRecipe(recipe.id!);
              Navigator.pop(ctx);
            },
            child: Text(
              'Удалить',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
