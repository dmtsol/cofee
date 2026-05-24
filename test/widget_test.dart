import 'package:flutter_test/flutter_test.dart';
import 'package:cofee/app.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CoffeeApp());
    expect(find.text('Cofee'), findsOneWidget);
  });
}
