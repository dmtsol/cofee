class CoffeeCalculation {
  final int? id;
  final String name;
  final int grindSize;
  final double baseCoffee;
  final double baseWater;
  final double coffeeGrams;
  final double waterMl;
  final DateTime createdAt;

  CoffeeCalculation({
    this.id,
    required this.name,
    required this.grindSize,
    required this.baseCoffee,
    required this.baseWater,
    required this.coffeeGrams,
    required this.waterMl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grind_size': grindSize,
      'base_coffee': baseCoffee,
      'base_water': baseWater,
      'coffee_grams': coffeeGrams,
      'water_ml': waterMl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CoffeeCalculation.fromJson(Map<String, dynamic> json) {
    return CoffeeCalculation(
      id: json['id'] as int?,
      name: json['name'] as String,
      grindSize: json['grind_size'] as int,
      baseCoffee: (json['base_coffee'] as num).toDouble(),
      baseWater: (json['base_water'] as num).toDouble(),
      coffeeGrams: (json['coffee_grams'] as num).toDouble(),
      waterMl: (json['water_ml'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  CoffeeCalculation copyWith({
    int? id,
    String? name,
    int? grindSize,
    double? baseCoffee,
    double? baseWater,
    double? coffeeGrams,
    double? waterMl,
    DateTime? createdAt,
  }) {
    return CoffeeCalculation(
      id: id ?? this.id,
      name: name ?? this.name,
      grindSize: grindSize ?? this.grindSize,
      baseCoffee: baseCoffee ?? this.baseCoffee,
      baseWater: baseWater ?? this.baseWater,
      coffeeGrams: coffeeGrams ?? this.coffeeGrams,
      waterMl: waterMl ?? this.waterMl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  CoffeeCalculation withId(int newId) {
    return CoffeeCalculation(
      id: newId,
      name: name,
      grindSize: grindSize,
      baseCoffee: baseCoffee,
      baseWater: baseWater,
      coffeeGrams: coffeeGrams,
      waterMl: waterMl,
      createdAt: createdAt,
    );
  }
}
